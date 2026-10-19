#!/usr/bin/env bash
set -euo pipefail

command -v traceroute >/dev/null 2>&1 || {
  echo "Ошибка: traceroute не установлен." >&2
  echo "Ubuntu/Debian: sudo apt install traceroute" >&2
  echo "Fedora/RHEL: sudo dnf install traceroute" >&2
  exit 1
}

tmp_file=$(mktemp)
trap 'rm -f "$tmp_file"' EXIT

echo "Трассировка до 8.8.8.8 без DNS-резолва:"
traceroute -n 8.8.8.8 | tee "$tmp_file"

hop_count=$(awk '/^[[:space:]]*[0-9]+[[:space:]]/ {count++} END {print count + 0}' "$tmp_file")
last_hop=$(awk '/^[[:space:]]*[0-9]+[[:space:]]/ {hop=$1} END {print hop + 0}' "$tmp_file")

echo
echo "Показано строк с хопами: $hop_count"
echo "Номер последнего показанного хопа: $last_hop"
