#!/usr/bin/env bash
set -euo pipefail

command -v ip >/dev/null 2>&1 || {
  echo "Ошибка: команда ip не найдена (установите пакет iproute2)." >&2
  exit 1
}

echo "Все сетевые интерфейсы:"
ip -br addr

route_to_internet=$(ip route get 1.1.1.1)
main_iface=$(awk '{for (i = 1; i <= NF; i++) if ($i == "dev") {print $(i + 1); exit}}' <<< "$route_to_internet")

if [[ -z "$main_iface" ]]; then
  echo "Ошибка: не удалось определить основной интерфейс." >&2
  exit 1
fi

mac_address=$(ip -o link show dev "$main_iface" | awk '{for (i = 1; i <= NF; i++) if ($i == "link/ether") {print $(i + 1); exit}}')
ip_address=$(ip -4 -o addr show dev "$main_iface" scope global | awk 'NR == 1 {print $4}')

echo
printf '%-16s %-20s %-20s\n' "Интерфейс" "IPv4" "MAC"
printf '%-16s %-20s %-20s\n' "$main_iface" "${ip_address:-не назначен}" "${mac_address:-не найден}"

echo
echo "Проверка MAC-адреса:"
ip link show "$main_iface" | grep 'link/ether'
