#!/usr/bin/env bash
set -euo pipefail

command -v ip >/dev/null 2>&1 || {
  echo "Ошибка: команда ip не найдена (установите пакет iproute2)." >&2
  exit 1
}

if ! ip link show dummy0 >/dev/null 2>&1; then
  echo "Ошибка: интерфейс dummy0 не найден. Сначала запустите 07_create_dummy.sh." >&2
  exit 1
fi

if (( EUID == 0 )); then
  SUDO=()
elif command -v sudo >/dev/null 2>&1; then
  SUDO=(sudo)
else
  echo "Ошибка: для изменения маршрутов нужен root или sudo." >&2
  exit 1
fi

route_added=false
cleanup() {
  if [[ "$route_added" == true ]]; then
    "${SUDO[@]}" ip route del 10.99.0.0/24 dev dummy0 metric 100 2>/dev/null || true
  fi
}
trap cleanup EXIT

echo "Маршрут, автоматически созданный для адреса dummy0:"
ip route show 10.99.0.0/24

echo
echo "Добавляем отдельный маршрут с метрикой 100:"
"${SUDO[@]}" ip route add 10.99.0.0/24 dev dummy0 metric 100
route_added=true
ip route show 10.99.0.0/24

echo
echo "Выбор маршрута для 10.99.0.5:"
ip route get 10.99.0.5

echo
echo "Удаляем добавленный маршрут с метрикой 100:"
"${SUDO[@]}" ip route del 10.99.0.0/24 dev dummy0 metric 100
route_added=false
ip route show 10.99.0.0/24

echo
echo "Примечание: connected-route без metric 100 остаётся, пока на dummy0 назначен 10.99.0.1/24."
