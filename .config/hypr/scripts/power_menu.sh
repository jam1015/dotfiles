#!/bin/sh
# Click-to-focus while menu is open: cursor travel doesn't shift focus,
# but a real click on another window fires `activewindow` → watcher kills fuzzel.
PREV=$(hyprctl -j getoption input:follow_mouse \
       | python3 -c 'import json,sys;print(json.load(sys.stdin)["int"])')
hyprctl keyword input:follow_mouse 2 >/dev/null

SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
(
  socat -u UNIX-CONNECT:"$SOCK" - 2>/dev/null | while IFS= read -r line; do
    case "$line" in
      activewindow*|workspace*|focusedmon*)
        pkill -x fuzzel
        break
        ;;
    esac
  done
) &
WATCHER=$!

choice=$(printf "Lock\nSuspend\nHibernate\nLog out\nReboot\nShutdown" \
  | fuzzel --dmenu --prompt "Power: " --anchor top-right \
           --width 14 --lines 6 --x-margin 8 --y-margin 24)

kill "$WATCHER" 2>/dev/null
hyprctl keyword input:follow_mouse "$PREV" >/dev/null

case "$choice" in
  Lock)      swaylock -f --color 000000 ;;
  Suspend)   systemctl suspend ;;
  Hibernate) systemctl hibernate ;;
  "Log out") hyprctl dispatch exit ;;
  Reboot)    systemctl reboot ;;
  Shutdown)  systemctl poweroff ;;
esac
