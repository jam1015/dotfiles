#!/bin/sh
# Read terminal buffer (visible or scrollback) from stdin and open in nvim.
# Foot pipes terminal contents to stdin via pipe-visible / pipe-scrollback actions.
f=$(mktemp --suffix=.txt /tmp/foot-dump.XXXXXX)
cat > "$f"
exec foot -- nvim -u ~/.config/foot/scrollback-pager/nvim/init.vim "$f" -c 'normal! G$'
