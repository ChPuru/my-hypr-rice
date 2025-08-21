#!/bin/bash

wifi_count=$(nmcli -t -f TYPE device | grep -c wifi)
ethernet_count=$(nmcli -t -f TYPE device | grep -c ethernet)
connected_count=$(nmcli -t -f DEVICE,STATE device | grep -c ":connected")

if [ "$wifi_count" -gt 0 ] && [ "$connected_count" -gt 0 ]; then
  echo "📶 $(nmcli -t -f ACTIVE,SSID dev wifi | grep '^yes' | cut -d: -f2)"
elif [ "$ethernet_count" -gt 0 ] && [ "$connected_count" -gt 0 ]; then
  echo "🌐 Ethernet"
else
  echo "❌ Offline"
fi