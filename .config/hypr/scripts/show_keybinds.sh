#!/bin/bash
# show_keybinds.sh
# Display all Hyprland keybindings grouped by submap in a floating kitty window.

decode_mod() {
    local mask=$1
    local mods=""
    [ $((mask & 64)) -ne 0 ] && mods="${mods}SUPER+"
    [ $((mask & 4))  -ne 0 ] && mods="${mods}CTRL+"
    [ $((mask & 8))  -ne 0 ] && mods="${mods}ALT+"
    [ $((mask & 1))  -ne 0 ] && mods="${mods}SHIFT+"
    echo "${mods%+}"
}

header() {
    printf "\n  ── %s ──\n\n" "$1"
    printf "  %-16s  %-12s  %-22s  %s\n" "MOD" "KEY" "DISPATCHER" "ARG"
    printf "  %-16s  %-12s  %-22s  %s\n" "---" "---" "----------" "---"
}

format_binds() {
    local target_submap="$1"
    hyprctl binds -j | jq -c '.[]' | while read -r bind; do
        submap=$(echo "$bind" | jq -r '.submap')
        [ "$submap" != "$target_submap" ] && continue

        key=$(echo "$bind" | jq -r '.key')
        dispatcher=$(echo "$bind" | jq -r '.dispatcher')
        arg=$(echo "$bind" | jq -r '.arg')
        modmask=$(echo "$bind" | jq -r '.modmask')
        mod=$(decode_mod "$modmask")

        printf "  %-16s  %-12s  %-22s  %s\n" "$mod" "$key" "$dispatcher" "$arg"
    done
}

{
    header "global"
    format_binds ""

    header "prefix  (Super → ...)"
    format_binds "prefix"

    header "prefix2  (Super → Super → ...)"
    format_binds "prefix2"
} | less -R
