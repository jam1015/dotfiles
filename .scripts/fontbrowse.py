#!/usr/bin/env python3
"""Browse and set the Linux console font.

On launch you pick a mode:

  1) kernel-builtin fonts only (recommended):
     Pick from fonts compiled into the kernel. Selection writes
     fbcon=font:NAME to /etc/kernel/cmdline and regenerates boot
     entries. Same font from decryption screen onward, surviving
     every fbcon reinit. Live preview is rendered through the
     closest kbd PSF analog where one exists.

  2) all kbd PSF fonts:
     Browse everything in /usr/share/kbd/consolefonts/ with live
     preview. Selection writes FONT= to vconsole.conf and runs
     setfont. Less persistent: the font only appears after
     systemd-vconsole-setup runs, and fbcon reinits can drop it.

In both modes fonts are labeled [kernel] (compiled into the kernel,
usable via fbcon=font:) or [extra] (kbd PSF, userspace only).

Keys (preview modes): n/Right next, p/Left prev, s select, q quit.
"""
import gzip
import os
import re
import struct
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Optional

FONT_DIR = Path("/usr/share/kbd/consolefonts")
VCONSOLE_SRC = Path.home() / "dotfiles/etc/vconsole.conf"
INSTALL_SCRIPT = Path.home() / "dotfiles/.scripts/install_console_font.bash"
CACHE_DIR = Path.home() / ".cache" / "fontbrowse"

# Mainline kernel source filenames for each fbcon=font:NAME. Fetched
# once and parsed into local PSFs so preview is byte-exact.
KERNEL_FONT_SRC = {
    "VGA8x8":   "font_8x8.c",
    "VGA8x16":  "font_8x16.c",
    "PEARL8x8": "font_pearl_8x8.c",
    "ACORN8x8": "font_acorn_8x8.c",
    "MINI4x6":  "font_mini_4x6.c",
    "6x8":      "font_6x8.c",
    "6x10":     "font_6x10.c",
    "7x14":     "font_7x14.c",
    "10x18":    "font_10x18.c",
    "SUN8x16":  "font_sun8x16.c",
    "SUN12x22": "font_sun12x22.c",
    "TER16x32": "font_ter16x32.c",
}
LINUX_RAW = ("https://raw.githubusercontent.com/torvalds/linux/master/"
             "lib/fonts/")

# Fonts compiled into the Linux kernel (lib/fonts/). These are the
# names accepted by the fbcon=font:NAME kernel parameter. Whether a
# given kernel build actually includes each one depends on its
# CONFIG_FONT_* options; the set below is what mainline ships.
KERNEL_BUILTIN_FONTS = [
    ("VGA8x8",    8,  8,  "PC BIOS 8x8"),
    ("VGA8x16",   8,  16, "PC BIOS 8x16 (fbcon fallback when nothing fits)"),
    ("PEARL8x8",  8,  8,  "Pearl 8x8"),
    ("ACORN8x8",  8,  8,  "Acorn 8x8"),
    ("MINI4x6",   4,  6,  "tiny 4x6"),
    ("6x8",       6,  8,  "6x8"),
    ("6x10",      6,  10, "6x10"),
    ("7x14",      7,  14, "7x14"),
    ("10x18",     10, 18, "10x18 SUN"),
    ("SUN8x16",   8,  16, "SUN 8x16"),
    ("SUN12x22",  12, 22, "SUN 12x22 (large)"),
    ("TER16x32",  16, 32, "Terminus 16x32 (large)"),
]
KERNEL_NAMES = {f[0] for f in KERNEL_BUILTIN_FONTS}
KERNEL_DIMS = {n: (w, h) for n, w, h, _ in KERNEL_BUILTIN_FONTS}

# fbcon's get_default_font() auto-picks the largest compiled-in font
# that fits the framebuffer; on hi-DPI displays this is typically
# SUN12x22 or TER16x32, not VGA8x16. VGA8x16 is only the fallback
# when nothing larger fits. So "the default" is resolution-dependent
# and we detect it at runtime instead of hardcoding.


def cmdline_fbcon_font() -> Optional[str]:
    """fbcon=font:NAME on the running kernel cmdline, if any."""
    try:
        m = re.search(r'\bfbcon=font:([^\s]+)',
                      Path("/proc/cmdline").read_text())
        return m.group(1) if m else None
    except OSError:
        return None


def active_kernel_default() -> Optional[str]:
    """Best guess at the kernel font currently being rendered.

    If fbcon=font:NAME is on /proc/cmdline, that's it. Otherwise the
    kernel auto-selected based on framebuffer size; we snapshot the
    live font via `setfont -O` and match its (width, height) against
    the compiled-in fonts. Needs sudo for the snapshot path."""
    explicit = cmdline_fbcon_font()
    if explicit:
        return explicit
    import tempfile
    fd, path = tempfile.mkstemp(prefix="fontbrowse-detect-", suffix=".psf")
    os.close(fd)
    try:
        r = subprocess.run(["sudo", "setfont", "-O", path],
                           stderr=subprocess.DEVNULL)
        if r.returncode != 0 or os.path.getsize(path) == 0:
            return None
        try:
            w, h, _ = parse_font(Path(path))
        except Exception:
            return None
        matches = [n for n, (kw, kh) in KERNEL_DIMS.items()
                   if (kw, kh) == (w, h)]
        # Prefer non-VGA over VGA when ambiguous (auto-select biases
        # toward the larger / more featureful one, but pure dim match
        # can hit both VGA8x16 and SUN8x16). Just return the first
        # match if unambiguous; otherwise None.
        return matches[0] if len(matches) == 1 else None
    finally:
        try:
            os.unlink(path)
        except OSError:
            pass

# Fallback PSF analog (kbd consolefonts) when the kernel source can't
# be fetched. Only used if ensure_kernel_psf() returns None.
KERNEL_PREVIEW = {
    "VGA8x16":  "default8x16",
    "SUN12x22": "sun12x22",
    "SUN8x16":  "lat0-sun16",
    "TER16x32": "ter-132n",
}


ACTIVE_DEFAULT: Optional[str] = None  # filled in by detect_active_default()


def label(name: str) -> str:
    base = "[kernel]" if name in KERNEL_NAMES else "[extra] "
    if ACTIVE_DEFAULT and name == ACTIVE_DEFAULT:
        base += " [CURRENT]"
    return base


PSF1_MAGIC = b"\x36\x04"
PSF2_MAGIC = b"\x72\xb5\x4a\x86"


def font_name(path: Path) -> str:
    name = path.name
    for ext in (".psfu.gz", ".psf.gz", ".psfu", ".psf", ".gz"):
        if name.endswith(ext):
            return name[: -len(ext)]
    return name


def find_psf(stem: str) -> Optional[Path]:
    for ext in (".psfu.gz", ".psf.gz", ".psfu", ".psf"):
        p = FONT_DIR / (stem + ext)
        if p.exists():
            return p
    return None


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
    print(f"\nselected: {name} {label(name)}")
    print(f"updated {VCONSOLE_SRC}")
    print(f"running {INSTALL_SCRIPT}...")
    subprocess.run([str(INSTALL_SCRIPT)], check=False)


def write_kernel_selection(name: str):
    print(f"\nselected: {name} [kernel]")
    print(f"running {INSTALL_SCRIPT} --kernel-font {name}...")
    subprocess.run([str(INSTALL_SCRIPT), "--kernel-font", name], check=False)


# ---------- entry types ----------

@dataclass
class Entry:
    name: str                   # installed name + display name
    kind: str                   # 'kernel' or 'extra'
    preview: Optional[Path]     # PSF to render/setfont, or None
    info: str = ""              # extra description for the header
    resolver: Optional[callable] = None  # lazy: () -> (Path|None, info_suffix)
    resolved: bool = False

    def ensure_preview(self):
        """Run the lazy resolver (e.g. fetch + parse kernel C source)
        the first time the user navigates to this entry."""
        if self.resolved or self.resolver is None:
            return
        self.resolved = True
        path, suffix = self.resolver()
        if path is not None:
            self.preview = path
        if suffix:
            self.info = (self.info + "  " + suffix).strip()

    def install(self):
        if self.kind == "kernel":
            write_kernel_selection(self.name)
        else:
            write_selection(self.name)


def parse_c_font(text: str, w: int, h: int):
    """Parse a kernel lib/fonts/font_*.c byte array into (w, h, glyphs).

    Strips C comments first so the binary-bit notation in the source
    (e.g. '00000000') can't be mistaken for data. Hex bytes are then
    pulled out by regex and sliced into glyphs of (rb*h) bytes."""
    text = re.sub(r"/\*.*?\*/", "", text, flags=re.S)
    text = re.sub(r"//[^\n]*", "", text)
    nums = [int(m, 16) for m in re.findall(r"0x([0-9a-fA-F]{1,2})\b", text)]
    rb = (w + 7) // 8
    cs = rb * h
    count = len(nums) // cs
    if count == 0:
        raise ValueError(f"no glyphs parsed (got {len(nums)} bytes, "
                         f"need at least {cs})")
    data = bytes(nums[:count * cs])
    return w, h, [data[i * cs:(i + 1) * cs] for i in range(count)]


def write_psf2(path: Path, w: int, h: int, glyphs: list[bytes]):
    rb = (w + 7) // 8
    cs = rb * h
    hdr = struct.pack("<4sIIIIIII",
                      PSF2_MAGIC, 0, 32, 0, len(glyphs), cs, h, w)
    path.write_bytes(hdr + b"".join(glyphs))


def ensure_kernel_psf(name: str, w: int, h: int) -> Optional[Path]:
    """Return a local PSF rendering of kernel font NAME, fetching and
    parsing the kernel source on first use. None on any failure."""
    src = KERNEL_FONT_SRC.get(name)
    if not src:
        return None
    out = CACHE_DIR / f"{name}.psf"
    if out.exists():
        return out
    import urllib.request, urllib.error
    try:
        text = urllib.request.urlopen(LINUX_RAW + src, timeout=10) \
            .read().decode("utf-8", errors="replace")
    except (urllib.error.URLError, OSError):
        return None
    try:
        pw, ph, glyphs = parse_c_font(text, w, h)
    except Exception:
        return None
    CACHE_DIR.mkdir(parents=True, exist_ok=True)
    write_psf2(out, pw, ph, glyphs)
    return out


def build_kernel_entries() -> list[Entry]:
    out = []
    for name, w, h, desc in KERNEL_BUILTIN_FONTS:
        info = f"{w}x{h}  {desc}"
        cached = CACHE_DIR / f"{name}.psf"
        if cached.exists():
            out.append(Entry(name=name, kind="kernel",
                             preview=cached,
                             info=info + "  (exact)", resolved=True))
            continue

        def resolver(name=name, w=w, h=h):
            p = ensure_kernel_psf(name, w, h)
            if p is not None:
                return p, "(exact)"
            stem = KERNEL_PREVIEW.get(name)
            if stem:
                p = find_psf(stem)
                if p is not None:
                    return p, f"(approx via {stem})"
            return None, "(no preview)"

        out.append(Entry(name=name, kind="kernel", preview=None,
                         info=info, resolver=resolver))
    return out


def build_psf_entries() -> list[Entry]:
    if not FONT_DIR.is_dir():
        sys.exit(f"no such directory: {FONT_DIR}")
    paths = sorted(p for p in FONT_DIR.iterdir()
                   if p.is_file() and ".psf" in p.name)
    if not paths:
        sys.exit("no fonts found")
    out = []
    for p in paths:
        n = font_name(p)
        out.append(Entry(name=n,
                         kind="kernel" if n in KERNEL_NAMES else "extra",
                         preview=p))
    return out


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


def vconsole_font() -> Optional[str]:
    """FONT= from the active /etc/vconsole.conf, or None if blank/absent."""
    try:
        for line in Path("/etc/vconsole.conf").read_text().splitlines():
            m = re.match(r'\s*FONT=("?)([^"\s]*)\1\s*$', line)
            if m and m.group(2):
                return m.group(2)
    except OSError:
        pass
    return None


def tty_loop(entries: list[Entry]):
    import tempfile
    if not entries:
        sys.exit("no fonts")

    # Warm sudo timestamp up front so later restores don't trip on an
    # invisible password prompt. We never suppress stderr on save or
    # restore, so any later re-auth or failure is visible.
    subprocess.run(["sudo", "-v"])

    orig_fd, orig_path = tempfile.mkstemp(prefix="fontbrowse-orig-",
                                          suffix=".psf")
    os.close(orig_fd)
    saved_orig = (subprocess.run(["sudo", "setfont", "-O", orig_path]).returncode == 0
                  and os.path.getsize(orig_path) > 0)
    # Verify the saved file is actually a parseable PSF; setfont -O
    # has been known to write garbage for some loaded fonts.
    if saved_orig:
        try:
            parse_font(Path(orig_path))
        except Exception as ex:
            print(f"WARNING: saved font at {orig_path} is unreadable ({ex});"
                  f" will fall back to /etc/vconsole.conf on revert")
            saved_orig = False

    vc_fallback = vconsole_font()

    def restore_orig():
        # Refresh sudo timestamp so the restore can't silently stall on
        # a hidden password prompt.
        subprocess.run(["sudo", "-v"])
        if saved_orig:
            print(f"\nrestoring original font from {orig_path}...")
            subprocess.run(["sudo", "setfont", orig_path])
        elif vc_fallback:
            print(f"\nrestoring via /etc/vconsole.conf FONT={vc_fallback}...")
            subprocess.run(["sudo", "setfont", vc_fallback])
        else:
            print("\nrestoring kernel default font (no original saved,"
                  " FONT= blank in /etc/vconsole.conf)...")
            subprocess.run(["sudo", "setfont"])

    os.system("clear")
    print("fontbrowse: console font preview")
    print("=" * 60)
    print()
    print("Cycles through fonts by calling setfont on your active tty")
    print("(or, for kernel-builtin entries, by rendering a closest")
    print("PSF analog -- the *installed* font is still the kernel one).")
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
    print("  s    SELECT + INSTALL current font (persistent)")
    print("  k    KEEP current preview for this session (NOT persistent)")
    print("  q / Ctrl-C    QUIT and revert to original font")
    print()
    print("WARNING: tiny fonts (4x6, 8x8) make these instructions")
    print("unreadable. Press q (or Ctrl-C) blind to revert.")
    print()
    print("Press any key to begin...")
    getch()

    i = 0
    try:
        while True:
            e = entries[i]
            e.ensure_preview()
            previewed = False
            if e.preview is not None:
                r = subprocess.run(["sudo", "setfont", str(e.preview)])
                previewed = r.returncode == 0
            if not previewed:
                restore_orig()  # neutral baseline for entries without preview
            os.system("clear")
            print(f"[{i+1}/{len(entries)}] {label(e.name)} {e.name}"
                  f"   {e.info}")
            print("n/Space/Right=next  p/Left=prev  "
                  "s=select+install  k=keep-for-session  "
                  "q/Ctrl-C=revert-to-original")
            if previewed:
                print_all_chars()
            else:
                print()
                print("  (no live preview for this font; install it to see it)")
            k = getch()
            if k in ("q", "\x03"):
                restore_orig()
                return
            if k == "k":
                print(f"\nkeeping current preview for this session "
                      f"(not installed; lost on reboot).")
                return
            if k == "s":
                restore_orig()
                e.install()
                return
            if k in ("n", "\x1b[C", " ", "\r"):
                i = (i + 1) % len(entries)
            elif k in ("p", "\x1b[D"):
                i = (i - 1) % len(entries)
    except (KeyboardInterrupt, Exception):
        restore_orig()
        raise
    finally:
        try:
            os.unlink(orig_path)
        except OSError:
            pass


# ---------- gui mode ----------

def gui_loop(entries: list[Entry]):
    import tkinter as tk

    CELL = 4
    COLS = 32
    PAD = 4

    class App:
        def __init__(self, root):
            self.root = root
            self.all = entries
            self.entries = list(entries)
            self.idx = 0
            self.selected: Optional[Entry] = None
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
            self.entries = [e for e in self.all if needle in e.name.lower()] \
                or list(self.all)
            self.idx = 0
            self.render()

        def step(self, n):
            if self.entries:
                self.idx = max(0, min(len(self.entries) - 1, self.idx + n))
                self.render()

        def select(self):
            if self.entries:
                self.selected = self.entries[self.idx]
                self.root.destroy()

        def render(self):
            self.canvas.delete("all")
            if not self.entries:
                self.info.config(text="no entries")
                return
            e = self.entries[self.idx]
            e.ensure_preview()
            self.label.config(
                text=f"[{self.idx+1}/{len(self.entries)}] "
                     f"{label(e.name)} {e.name}   "
                     f"(n/p step, s select+install, / filter, q quit)")
            if e.preview is None:
                self.info.config(text=f"  {e.info}  (no preview available)")
                self.canvas.create_text(
                    20, 20, anchor="nw", fill="white",
                    font=("TkFixedFont", 14),
                    text="(no preview -- install to see it)")
                return
            try:
                w, h, glyphs = parse_font(e.preview)
            except Exception as ex:
                self.info.config(text=f"  preview failed: {ex}")
                return
            extra = f"  {w}x{h}px  {len(glyphs)} glyphs"
            if e.info:
                extra = f"  {e.info}{extra}"
            self.info.config(text=extra)
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
        app.selected.install()


def pick_mode() -> str:
    print("fontbrowse")
    print("=" * 60)
    print("  1) kernel-builtin fonts only [recommended]")
    print("       persistent across decryption / vconsole-setup /")
    print("       fbcon reinit. live preview via closest PSF analog.")
    print("  2) all kbd PSF fonts")
    print("       live preview. less persistent: a fbcon reinit")
    print("       (e.g. KMS handoff) can drop the font.")
    print("  3) reset to kernel default")
    print("       removes fbcon=font: from cmdline, blanks FONT= in")
    print("       vconsole.conf, regenerates boot entries. No browsing.")
    print("  q) quit")
    print()
    while True:
        try:
            raw = input("pick a mode: ").strip().lower()
        except (EOFError, KeyboardInterrupt):
            print()
            return "q"
        if raw in ("1", "2", "3", "q", ""):
            return raw or "q"
        print("invalid")


def reset_all():
    print(f"\nrunning {INSTALL_SCRIPT} --reset...")
    subprocess.run([str(INSTALL_SCRIPT), "--reset"], check=False)


def font_phase():
    mode = pick_mode()
    if mode == "q":
        return
    if mode == "3":
        reset_all()
        return
    entries = build_kernel_entries() if mode == "1" else build_psf_entries()
    if os.environ.get("DISPLAY") or os.environ.get("WAYLAND_DISPLAY"):
        gui_loop(entries)
    else:
        tty_loop(entries)


# ---------- video phase ----------

SYS_DRM = Path("/sys/class/drm")


def list_outputs() -> list[tuple[str, list[str]]]:
    """[(connector, [modes...]), ...] for connected DRM outputs."""
    out = []
    if not SYS_DRM.is_dir():
        return out
    for d in sorted(SYS_DRM.iterdir()):
        if not d.is_dir() or "-" not in d.name:
            continue
        try:
            if (d / "status").read_text().strip() != "connected":
                continue
        except OSError:
            continue
        conn = d.name.split("-", 1)[1]   # strip 'cardN-'
        try:
            raw = (d / "modes").read_text().splitlines()
        except OSError:
            raw = []
        seen, modes = set(), []
        for m in raw:
            if m and m not in seen:
                modes.append(m); seen.add(m)
        out.append((conn, modes))
    return out


def cmdline_video() -> dict[str, str]:
    """video=CONNECTOR:MODE entries on /proc/cmdline -> {conn: mode}."""
    try:
        cmd = Path("/proc/cmdline").read_text()
    except OSError:
        return {}
    return {m.group(1): m.group(2)
            for m in re.finditer(r'\bvideo=([^\s:]+):([^\s]+)', cmd)}


def video_phase():
    outputs = list_outputs()
    if not outputs:
        print("no connected DRM outputs found")
        return
    current = cmdline_video()
    print()
    print("Connected outputs (current cmdline override in parens):")
    for i, (c, _) in enumerate(outputs, 1):
        cur = current.get(c, "auto")
        print(f"  {i}. {c:<10}  (currently: {cur})")
    print("  q) cancel")
    print()
    while True:
        try:
            raw = input("pick an output: ").strip().lower()
        except (EOFError, KeyboardInterrupt):
            print(); return
        if raw in ("q", ""):
            return
        if raw.isdigit() and 1 <= int(raw) <= len(outputs):
            conn, modes = outputs[int(raw) - 1]
            break
        print("invalid")

    print(f"\nModes for {conn} (native first):")
    if not modes:
        print("  (no modes reported)")
        return
    for i, m in enumerate(modes, 1):
        marker = "  (native)" if i == 1 else ""
        cur = "  [CURRENT]" if current.get(conn) == m else ""
        print(f"  {i:2}. {m}{marker}{cur}")
    print()
    print("  r) revert (remove video= for this output)")
    print("  q) cancel")
    print()
    print("Lower modes = visually larger glyphs from decryption onward,")
    print("because fbcon's framebuffer is smaller. Takes effect on next")
    print("boot. Wayland/X will still drive the panel at native res.")
    print()
    while True:
        try:
            raw = input("pick a mode: ").strip().lower()
        except (EOFError, KeyboardInterrupt):
            print(); return
        if raw in ("q", ""):
            return
        if raw == "r":
            subprocess.run([str(INSTALL_SCRIPT), "--video-reset", conn],
                           check=False)
            return
        if raw.isdigit() and 1 <= int(raw) <= len(modes):
            subprocess.run([str(INSTALL_SCRIPT),
                            "--video", conn, modes[int(raw) - 1]],
                           check=False)
            return
        print("invalid")


# ---------- entry point ----------

def pick_phase() -> str:
    print("fontbrowse")
    print("=" * 60)
    print("  f) console font  (kernel-builtin / all PSF / reset)")
    print("  v) video mode    (KMS resolution / reset)")
    print("  q) quit")
    print()
    while True:
        try:
            raw = input("pick a phase: ").strip().lower()
        except (EOFError, KeyboardInterrupt):
            print(); return "q"
        if raw in ("f", "v", "q", ""):
            return raw or "q"
        print("invalid")


def main():
    global ACTIVE_DEFAULT
    ACTIVE_DEFAULT = active_kernel_default()
    if ACTIVE_DEFAULT:
        print(f"(active kernel font detected: {ACTIVE_DEFAULT})")
    else:
        print("(could not detect active kernel font; no [CURRENT] tag)")
    vid = cmdline_video()
    if vid:
        print("(active video= overrides: "
              + ", ".join(f"{c}={m}" for c, m in vid.items()) + ")")
    phase = pick_phase()
    if phase == "f":
        font_phase()
    elif phase == "v":
        video_phase()


if __name__ == "__main__":
    main()
