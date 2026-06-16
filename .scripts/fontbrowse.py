#!/usr/bin/env python3
"""Browse /usr/share/kbd/consolefonts/.

GUI session (DISPLAY/WAYLAND_DISPLAY set): Tk window with glyph grid.
Bare tty: setfont+showconsolefont loop.

Keys (both modes): n/Right next, p/Left prev, s select, q quit.
On select, writes FONT=<name> into ~/dotfiles/etc/vconsole.conf and
runs install_console_font.bash to install + apply system-wide.
"""
import gzip
import os
import re
import struct
import subprocess
import sys
from pathlib import Path

FONT_DIR = Path("/usr/share/kbd/consolefonts")
VCONSOLE_SRC = Path.home() / "dotfiles/etc/vconsole.conf"
INSTALL_SCRIPT = Path.home() / "dotfiles/.scripts/install_console_font.bash"

PSF1_MAGIC = b"\x36\x04"
PSF2_MAGIC = b"\x72\xb5\x4a\x86"


def font_name(path: Path) -> str:
    name = path.name
    for ext in (".psfu.gz", ".psf.gz", ".psfu", ".psf", ".gz"):
        if name.endswith(ext):
            return name[: -len(ext)]
    return name


def read_bytes(path: Path) -> bytes:
    opener = gzip.open if path.suffix == ".gz" else open
    with opener(path, "rb") as f:
        return f.read()


def parse_font(path: Path):
    """(width, height, glyphs) or raise."""
    data = read_bytes(path)
    if data.startswith(PSF2_MAGIC):
        (_m, _v, hdr, _f, length, cs, h, w) = struct.unpack("<4sIIIIIII", data[:32])
        rb = (w + 7) // 8
        assert cs == rb * h
        return w, h, [data[hdr + i * cs: hdr + (i + 1) * cs] for i in range(length)]
    if data.startswith(PSF1_MAGIC):
        mode, cs = data[2], data[3]
        length = 512 if (mode & 0x01) else 256
        return 8, cs, [data[4 + i * cs: 4 + (i + 1) * cs] for i in range(length)]
    if len(data) % 256 == 0 and 0 < len(data) // 256 <= 32:
        h = len(data) // 256
        return 8, h, [data[i * h: (i + 1) * h] for i in range(256)]
    raise ValueError("unrecognized format")


def print_all_chars(per_row=32):
    """Print all 256 glyph slots of the current console font.

    Uses the Linux console's direct-to-font PUA mapping: code points
    U+F000..U+F0FF are routed straight to glyph slots 0..255, bypassing
    the unicode->font lookup table. They are valid UTF-8 sequences so
    they survive tmux / terminal emulators (unlike raw 0x80..0xFF bytes,
    which get rejected as invalid UTF-8 continuation bytes and rendered
    as '?').

    ASCII (slots 0x20..0x7E) is printed as itself so control codes don't
    sneak through; the rest goes via PUA."""
    out = sys.stdout
    for row_start in range(0, 256, per_row):
        chars = []
        for b in range(row_start, row_start + per_row):
            if 0x20 <= b < 0x7F:
                chars.append(chr(b))
            else:
                chars.append(chr(0xF000 + b))
        out.write("".join(chars) + "\n")
    out.flush()


def bits(glyph, width, height):
    rb = (width + 7) // 8
    for y in range(height):
        row = glyph[y * rb:(y + 1) * rb]
        for x in range(width):
            if row[x // 8] & (0x80 >> (x % 8)):
                yield x, y


def write_selection(name: str):
    if VCONSOLE_SRC.exists():
        txt = VCONSOLE_SRC.read_text()
        if re.search(r"^FONT=", txt, re.M):
            txt = re.sub(r"^FONT=.*$", f"FONT={name}", txt, flags=re.M)
        else:
            txt = txt.rstrip() + f"\nFONT={name}\n"
    else:
        VCONSOLE_SRC.parent.mkdir(parents=True, exist_ok=True)
        txt = f"KEYMAP=us\nFONT={name}\n"
    VCONSOLE_SRC.write_text(txt)
    print(f"\nselected: {name}")
    print(f"updated {VCONSOLE_SRC}")
    print(f"running {INSTALL_SCRIPT}...")
    subprocess.run([str(INSTALL_SCRIPT)], check=False)


# ---------- tty mode ----------

def getch():
    import termios, tty
    fd = sys.stdin.fileno()
    old = termios.tcgetattr(fd)
    try:
        tty.setraw(fd)
        c = sys.stdin.read(1)
        if c == "\x1b":
            c += sys.stdin.read(2)
        return c
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old)


def tty_loop(paths):
    import tempfile
    paths = [p for p in paths if ".psf" in p.name]
    if not paths:
        sys.exit("no PSF fonts found")

    orig_fd, orig_path = tempfile.mkstemp(prefix="fontbrowse-orig-",
                                          suffix=".psf")
    os.close(orig_fd)
    saved_orig = subprocess.run(
        ["sudo", "setfont", "-O", orig_path],
        stderr=subprocess.DEVNULL).returncode == 0

    def restore_orig():
        if saved_orig and os.path.getsize(orig_path) > 0:
            subprocess.run(["sudo", "setfont", orig_path],
                           stderr=subprocess.DEVNULL)
        else:
            subprocess.run(["sudo", "setfont"])

    os.system("clear")
    print("fontbrowse: console font preview")
    print("=" * 60)
    print()
    print("Cycles through PSF fonts in /usr/share/kbd/consolefonts/ by")
    print("calling `setfont` on your active tty. The font you see *is*")
    print("the font being previewed -- including these instructions.")
    print()
    if saved_orig:
        print(f"Saved your current tty font to {orig_path}")
        print("so 'q' can restore exactly what you had.")
    else:
        print("WARNING: could not save current tty font; 'q' will fall")
        print("back to the kernel default font instead.")
    print()
    print("KEYS:")
    print("  n / Right / Space    next font")
    print("  p / Left             previous font")
    print()
    print("  s    SELECT + INSTALL current font (persistent):")
    print("         1. writes FONT= into ~/dotfiles/etc/vconsole.conf")
    print("         2. copies that to /etc/vconsole.conf (sudo)")
    print("         3. runs setfont on /dev/tty[1-6] (sudo)")
    print("       Persists across reboot.")
    print()
    print("  k    KEEP for this session (NOT persistent):")
    print("         quits with the currently-previewed font still active")
    print("         on this tty. Does NOT write any config, does NOT")
    print("         install anything. Lost on reboot or `setfont` reset.")
    print()
    print("  q    QUIT and REVERT:")
    print("         restores the font that was active when this script")
    print("         started. Nothing written, nothing installed.")
    print()
    print("  Ctrl-C   same as q (revert).")
    print()
    print("WARNING:")
    print("  Many PSF fonts are tiny (8x8). When such a font loads, these")
    print("  instructions become unreadable. Press q (or Ctrl-C) blind to")
    print("  revert to your original font.")
    print()
    print("Press any key to begin...")
    getch()

    i = 0
    try:
        while True:
            path = paths[i]
            name = font_name(path)
            r = subprocess.run(["sudo", "setfont", name],
                               stderr=subprocess.DEVNULL)
            if r.returncode != 0:
                paths.pop(i)
                if not paths:
                    sys.exit("no working fonts left")
                i %= len(paths)
                continue
            os.system("clear")
            print(f"[{i+1}/{len(paths)}] {name}")
            print("n/Space/Right=next  p/Left=prev  "
                  "s=select+install  k=keep-for-session  "
                  "q/Ctrl-C=revert-to-original")
            print_all_chars()
            k = getch()
            if k in ("q", "\x03"):
                restore_orig()
                return
            if k == "k":
                print(f"\nkeeping {name} for this session "
                      f"(not installed; lost on reboot).")
                return
            if k == "s":
                restore_orig()
                write_selection(name)
                return
            if k in ("n", "\x1b[C", " ", "\r"):
                i = (i + 1) % len(paths)
            elif k in ("p", "\x1b[D"):
                i = (i - 1) % len(paths)
    except (KeyboardInterrupt, Exception):
        restore_orig()
        raise
    finally:
        try:
            os.unlink(orig_path)
        except OSError:
            pass


# ---------- gui mode ----------

def gui_loop(paths):
    import tkinter as tk

    CELL = 4
    COLS = 32
    PAD = 4

    class App:
        def __init__(self, root):
            self.root = root
            self.all = paths
            self.paths = list(paths)
            self.idx = 0
            self.selected = None
            root.title("consolefonts")
            root.bind("<Left>", lambda _e: self.step(-1))
            root.bind("<Right>", lambda _e: self.step(1))
            root.bind("p", lambda _e: self.step(-1))
            root.bind("n", lambda _e: self.step(1))
            root.bind("<Prior>", lambda _e: self.step(-10))
            root.bind("<Next>", lambda _e: self.step(10))
            root.bind("q", lambda _e: root.destroy())
            root.bind("s", lambda _e: self.select())
            root.bind("/", lambda _e: self.entry.focus_set())

            top = tk.Frame(root); top.pack(fill="x", padx=PAD, pady=PAD)
            self.label = tk.Label(top, font=("TkDefaultFont", 12, "bold"),
                                  anchor="w")
            self.label.pack(side="left", fill="x", expand=True)
            tk.Label(top, text="filter:").pack(side="left")
            self.fv = tk.StringVar()
            self.fv.trace_add("write", lambda *_: self.filter())
            self.entry = tk.Entry(top, textvariable=self.fv, width=20)
            self.entry.pack(side="left")

            self.info = tk.Label(root, anchor="w", font=("TkFixedFont", 10))
            self.info.pack(fill="x", padx=PAD)
            self.canvas = tk.Canvas(root, bg="black", highlightthickness=0)
            self.canvas.pack(fill="both", expand=True, padx=PAD, pady=PAD)
            self.render()

        def filter(self):
            needle = self.fv.get().lower()
            self.paths = [p for p in self.all if needle in p.name.lower()] \
                or list(self.all)
            self.idx = 0
            self.render()

        def step(self, n):
            if self.paths:
                self.idx = max(0, min(len(self.paths) - 1, self.idx + n))
                self.render()

        def select(self):
            if self.paths:
                self.selected = font_name(self.paths[self.idx])
                self.root.destroy()

        def render(self):
            self.canvas.delete("all")
            while self.paths:
                path = self.paths[self.idx]
                try:
                    w, h, glyphs = parse_font(path)
                    break
                except Exception:
                    del self.paths[self.idx]
                    if not self.paths:
                        self.info.config(text="no parseable fonts")
                        return
                    self.idx %= len(self.paths)
            else:
                return
            name = font_name(path)
            self.label.config(
                text=f"[{self.idx+1}/{len(self.paths)}] {name}   "
                     f"(n/p step, s select+install, / filter, q quit)")
            rows = (len(glyphs) + COLS - 1) // COLS
            self.info.config(text=f"  {w}x{h}px  {len(glyphs)} glyphs")
            cw, ch, gap = w * CELL, h * CELL, CELL
            for gi, g in enumerate(glyphs):
                gx = (gi % COLS) * (cw + gap)
                gy = (gi // COLS) * (ch + gap)
                for x, y in bits(g, w, h):
                    px, py = gx + x * CELL, gy + y * CELL
                    self.canvas.create_rectangle(
                        px, py, px + CELL, py + CELL,
                        fill="white", outline="")

    root = tk.Tk()
    root.geometry("1200x800")
    app = App(root)
    root.mainloop()
    if app.selected:
        write_selection(app.selected)


def main():
    if not FONT_DIR.is_dir():
        sys.exit(f"no such directory: {FONT_DIR}")
    paths = sorted(p for p in FONT_DIR.iterdir() if p.is_file())
    if not paths:
        sys.exit("no fonts found")
    if os.environ.get("DISPLAY") or os.environ.get("WAYLAND_DISPLAY"):
        gui_loop(paths)
    else:
        tty_loop(paths)


if __name__ == "__main__":
    main()
