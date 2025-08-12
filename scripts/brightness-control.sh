#!/usr/bin/env bash
VALUE=$(brightnessctl g)
MAX=$(brightnessctl m)
PERCENT=$((VALUE * 100 / MAX))
ags -q "globalThis.show_osd({ name: '󰃠 Bright', value: ${PERCENT} })"