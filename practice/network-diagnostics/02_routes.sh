#!/usr/bin/env bash
set -euo pipefail

command -v ip >/dev/null 2>&1 || {
  echo "Ошибка: команда ip не найдена (установите пакет iproute2)." >&2
  exit 1
}

echo "Таблица маршрутизации:"
ip route show

default_route=$(ip route show default | head -n 1)
if [[ -z "$default_route" ]]; then
  echo "Ошибка: маршрут по умолчанию не найден." >&2
  exit 1
fi

gateway=$(awk '{for (i = 1; i <= NF; i++) if ($i == "via") {print $(i + 1); exit}}' <<< "$default_route")
iface=$(awk '{for (i = 1; i <= NF; i++) if ($i == "dev") {print $(i + 1); exit}}' <<< "$default_route")

echo
echo "Шлюз по умолчанию: ${gateway:-не указан}"
echo "Интерфейс: ${iface:-не указан}"
echo
echo "Маршрут для 1.1.1.1:"
ip route get 1.1.1.1
