#!/usr/bin/env bash
# ~/.config/hypr/scripts/volume.sh

sink="@DEFAULT_AUDIO_SINK@"

case "$1" in
    up)
        wpctl set-volume -l 1.5 $sink 5%+
        ;;
    down)
        wpctl set-volume $sink 5%-
        ;;
    mute)
        wpctl set-mute $sink toggle
        ;;
esac
