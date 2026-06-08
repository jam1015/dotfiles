#!/bin/sh
case "$(fcitx5-remote -n)" in
  keyboard-us)            next=pinyin ;;
  pinyin)                 next=keyboard-apl-unified ;;
  keyboard-apl-unified|*) next=keyboard-us ;;
esac
fcitx5-remote -s "$next"
