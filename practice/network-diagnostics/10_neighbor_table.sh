#!/usr/bin/env bash
set -euo pipefail

for cmd in ip ping; do
  command -v "$cmd" >/dev/null 2>&1 || {
    echo "Ошибка: команда $cmd не найдена." >&2
    exit 1
  }
done

gateway=$(ip route show default | awk 'NR == 1 {for (i = 1; i <= NF; i++) if ($i == "via") {print $(i + 1); exit}}')
if [[ -z "$gateway" ]]; then
  echo "Ошибка: шлюз по умолчанию не найден." >&2
  exit 1
fi

echo "Проверяем доступность шлюза $gateway:"
ping -c 2 "$gateway"

echo
echo "Neighbor-таблица:"
ip neigh show

echo
echo "Запись для шлюза $gateway:"
gateway_entry=$(ip neigh show "$gateway" || true)
if [[ -z "$gateway_entry" ]]; then
  echo "Запись для шлюза не найдена." >&2
  exit 1
fi
printf '%s\n' "$gateway_entry"

gateway_mac=$(awk '{for (i = 1; i <= NF; i++) if ($i == "lladdr") {print $(i + 1); exit}}' <<< "$gateway_entry")
echo "MAC-адрес шлюза: ${gateway_mac:-не найден}"
