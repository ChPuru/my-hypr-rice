#!/usr/bin/env bash
VALUE=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -n 1 | tr -d '%')
ags -q "globalThis.show_osd({ name: ' Vol', value: ${VALUE} })"