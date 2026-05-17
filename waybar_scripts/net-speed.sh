#!/bin/bash

interface=$(ip route | awk '/default/ {print $5; exit}')

rx1=$(cat /sys/class/net/$interface/statistics/rx_bytes)
tx1=$(cat /sys/class/net/$interface/statistics/tx_bytes)

sleep 1

rx2=$(cat /sys/class/net/$interface/statistics/rx_bytes)
tx2=$(cat /sys/class/net/$interface/statistics/tx_bytes)

rx_speed=$(( (rx2 - rx1) / 1024 ))
tx_speed=$(( (tx2 - tx1) / 1024 ))

echo "Download: ${rx_speed}KB/s    Upload: ${tx_speed}KB/s"
