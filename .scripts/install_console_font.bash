#!/bin/bash
# Install the console font.
#
# No args:
#   userspace path. Copies $HOME/dotfiles/etc/vconsole.conf to
#   /etc/vconsole.conf and runs setfont on /dev/tty[1-6]. The font
#   is whatever FONT= says in vconsole.conf. This font is only
#   applied once systemd-vconsole-setup has run, and is dropped
#   whenever fbcon reinitializes (e.g. after KMS handoff).
#
# --kernel-font NAME:
#   persistent path. Sets fbcon=font:NAME on the kernel command line
#   (/etc/kernel/cmdline) and regenerates the boot entries, then
#   blanks FONT= in vconsole.conf so userspace doesn't fight it.
#   NAME must be one of the fonts compiled into the kernel.
#   With this, the same font is used from decryption onward and
#   survives fbcon reinit.
#
# --reset:
#   removes fbcon=font: from the kernel command line, blanks FONT=
#   in vconsole.conf, regenerates boot entries, and resets the
#   active ttys. Restores everything to the kernel default font.
#
# --video CONNECTOR MODE:
#   sets video=CONNECTOR:MODE on the kernel command line (e.g.
#   --video eDP-1 1920x1080). Lower modes give visually larger
#   glyphs from decryption onward because fbcon's framebuffer is
#   smaller. Takes effect on next boot.
#
# --video-reset CONNECTOR:
#   removes video=CONNECTOR: from the kernel command line so the
#   kernel auto-selects the panel's native mode again.
#
# Needs sudo. Safe to re-run.

set -e

SRC=$HOME/dotfiles/etc/vconsole.conf
DST=/etc/vconsole.conf
CMDLINE=/etc/kernel/cmdline

apply_vconsole() {
    if [ ! -f "$SRC" ]; then
        echo "missing $SRC; skipping" >&2
        return 0
    fi
    if ! cmp -s "$SRC" "$DST"; then
        sudo install -m 0644 "$SRC" "$DST"
        echo "installed $DST"
    else
        echo "$DST already up to date"
    fi
    font=$(awk -F= '/^FONT=/ {print $2}' "$SRC" | tr -d '"')
    if [ -n "$font" ] && command -v setfont >/dev/null 2>&1; then
        for tty in /dev/tty[1-6]; do
            sudo setfont -C "$tty" "$font" 2>/dev/null || true
        done
        echo "applied FONT=$font to active ttys"
    fi
}

set_kernel_font() {
    local name=$1
    if [ ! -f "$CMDLINE" ]; then
        echo "missing $CMDLINE; cannot set kernel font" >&2
        exit 1
    fi
    local current new
    current=$(cat "$CMDLINE")
    if grep -q 'fbcon=font:' "$CMDLINE"; then
        new=$(printf '%s\n' "$current" | sed -E "s/fbcon=font:[^ ]+/fbcon=font:${name}/")
    else
        new="${current% } fbcon=font:${name}"
    fi
    if [ "$new" != "$current" ]; then
        printf '%s\n' "$new" | sudo tee "$CMDLINE" >/dev/null
        echo "updated $CMDLINE: fbcon=font:$name"
    else
        echo "$CMDLINE already set to fbcon=font:$name"
    fi

    # Blank FONT= so vconsole-setup doesn't override the kernel font.
    if [ -f "$SRC" ] && grep -q '^FONT=' "$SRC"; then
        sed -i 's/^FONT=.*/FONT=/' "$SRC"
        echo "cleared FONT= in $SRC"
    fi
    apply_vconsole

    if command -v reinstall-kernels >/dev/null 2>&1; then
        echo "regenerating boot entries..."
        sudo reinstall-kernels
    else
        echo "WARNING: reinstall-kernels not found; regenerate boot entries manually" >&2
    fi
    echo "fbcon=font:$name will take effect on next boot"
}

reset_all() {
    if [ -f "$CMDLINE" ] && grep -q 'fbcon=font:' "$CMDLINE"; then
        local current new
        current=$(cat "$CMDLINE")
        new=$(printf '%s\n' "$current" | sed -E 's/ *fbcon=font:[^ ]+//g')
        printf '%s\n' "$new" | sudo tee "$CMDLINE" >/dev/null
        echo "removed fbcon=font: from $CMDLINE"
    else
        echo "$CMDLINE has no fbcon=font: to remove"
    fi

    if [ -f "$SRC" ] && grep -q '^FONT=' "$SRC"; then
        sed -i 's/^FONT=.*/FONT=/' "$SRC"
        echo "cleared FONT= in $SRC"
    fi
    apply_vconsole

    # Drop whatever's currently loaded; kernel default takes over.
    if command -v setfont >/dev/null 2>&1; then
        for tty in /dev/tty[1-6]; do
            sudo setfont -C "$tty" 2>/dev/null || true
        done
        echo "reset active ttys to kernel default font"
    fi

    if command -v reinstall-kernels >/dev/null 2>&1; then
        echo "regenerating boot entries..."
        sudo reinstall-kernels
    else
        echo "WARNING: reinstall-kernels not found; regenerate boot entries manually" >&2
    fi
    echo "kernel default font will be active from next boot"
}

set_video() {
    local conn=$1 mode=$2
    [ -f "$CMDLINE" ] || { echo "missing $CMDLINE" >&2; exit 1; }
    local current new
    current=$(cat "$CMDLINE")
    # strip any existing video=<conn>:... entry, then append the new one
    new=$(printf '%s\n' "$current" | sed -E "s/ *video=${conn}:[^ ]+//g")
    new="${new% } video=${conn}:${mode}"
    if [ "$new" != "$current" ]; then
        printf '%s\n' "$new" | sudo tee "$CMDLINE" >/dev/null
        echo "updated $CMDLINE: video=${conn}:${mode}"
    else
        echo "$CMDLINE already set to video=${conn}:${mode}"
    fi
    if command -v reinstall-kernels >/dev/null 2>&1; then
        echo "regenerating boot entries..."
        sudo reinstall-kernels
    else
        echo "WARNING: reinstall-kernels not found; regenerate boot entries manually" >&2
    fi
    echo "video=${conn}:${mode} will take effect on next boot"
}

reset_video() {
    local conn=$1
    [ -f "$CMDLINE" ] || { echo "missing $CMDLINE" >&2; exit 1; }
    local current new
    current=$(cat "$CMDLINE")
    new=$(printf '%s\n' "$current" | sed -E "s/ *video=${conn}:[^ ]+//g")
    if [ "$new" != "$current" ]; then
        printf '%s\n' "$new" | sudo tee "$CMDLINE" >/dev/null
        echo "removed video=${conn}: from $CMDLINE"
        if command -v reinstall-kernels >/dev/null 2>&1; then
            sudo reinstall-kernels
        fi
    else
        echo "$CMDLINE has no video=${conn}: to remove"
    fi
}

case ${1:-} in
    --kernel-font)
        [ -n "${2:-}" ] || { echo "usage: $0 --kernel-font NAME" >&2; exit 2; }
        set_kernel_font "$2"
        ;;
    --reset)
        reset_all
        ;;
    --video)
        [ -n "${2:-}" ] && [ -n "${3:-}" ] \
            || { echo "usage: $0 --video CONNECTOR MODE" >&2; exit 2; }
        set_video "$2" "$3"
        ;;
    --video-reset)
        [ -n "${2:-}" ] || { echo "usage: $0 --video-reset CONNECTOR" >&2; exit 2; }
        reset_video "$2"
        ;;
    "")
        apply_vconsole
        ;;
    *)
        echo "usage: $0 [--kernel-font NAME | --reset |" >&2
        echo "          --video CONNECTOR MODE | --video-reset CONNECTOR]" >&2
        exit 2
        ;;
esac
