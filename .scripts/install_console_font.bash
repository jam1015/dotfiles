#!/bin/bash
# Install /etc/vconsole.conf from the tracked copy in dotfiles and
# apply the FONT immediately to all active ttys.
#
# Needs sudo. Safe to re-run; only writes when content differs.

set -e

SRC=$HOME/dotfiles/etc/vconsole.conf
DST=/etc/vconsole.conf

if [ ! -f "$SRC" ]; then
    echo "missing $SRC; skipping console font install" >&2
    exit 0
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
