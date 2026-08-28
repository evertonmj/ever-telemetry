#!/usr/bin/env bash

set -u

read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
total_before=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle_before=$((idle + iowait))
sleep 0.15
read -r _ user nice system idle iowait irq softirq steal _ < /proc/stat
total_after=$((user + nice + system + idle + iowait + irq + softirq + steal))
idle_after=$((idle + iowait))
total_delta=$((total_after - total_before))
idle_delta=$((idle_after - idle_before))

if (( total_delta > 0 )); then
  cpu=$((100 * (total_delta - idle_delta) / total_delta))
else
  cpu=0
fi

mem_total=$(awk '/^MemTotal:/ { print $2 }' /proc/meminfo)
mem_available=$(awk '/^MemAvailable:/ { print $2 }' /proc/meminfo)
memory=$((100 * (mem_total - mem_available) / mem_total))

temperature=$(sensors 2>/dev/null | awk '
  /Package id 0:/ { gsub(/[+°C]/, "", $4); print int($4); found=1; exit }
  /Tctl:/ { gsub(/[+°C]/, "", $2); print int($2); found=1; exit }
  END { if (!found) print "--" }
')

load=$(awk '{ print $1 }' /proc/loadavg)
disk=$(df -P / | awk 'NR == 2 { gsub(/%/, "", $5); print $5 }')

printf '%s|%s|%s|%s|%s\n' "$cpu" "$memory" "$temperature" "$load" "$disk"
