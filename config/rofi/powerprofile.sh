#!/usr/bin/env bash

chosen=$(printf "Performance\nBalanced\nPower Saver" | rofi -dmenu -p "⚡ Power Mode:" -theme ~/hallnix/config/rofi/config.rasi)

case "$chosen" in
    "Performance") powerprofilesctl set performance ;;
    "Balanced") powerprofilesctl set balanced ;;
    "Power Saver") powerprofilesctl set power-saver ;;
    *) exit 0 ;;
esac
