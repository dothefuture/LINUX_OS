#!/usr/bin/env bash
set -euo pipefail

command -v ip >/dev/null 2>&1 || {
  echo "Ошибка: команда ip не найдена (установите пакет iproute2)." >&2
  exit 1
}

if (( EUID == 0 )); then
  SUDO=()
elif command -v sudo >/dev/null 2>&1; then
  SUDO=(sudo)
else
  echo "Ошибка: для создания интерфейса нужен root или sudo." >&2
  exit 1
fi

if ip link show dummy0 >/dev/null 2>&1; then
  if ! ip -d -o link show dummy0 | grep -qw 'dummy'; then
    echo "Ошибка: интерфейс dummy0 уже существует, но имеет другой тип." >&2
    exit 1
  fi
  echo "Интерфейс dummy0 уже существует."
else
  "${SUDO[@]}" ip link add dummy0 type dummy
  echo "Интерфейс dummy0 создан."
fi

if ! ip -4 addr show dev dummy0 | grep -q '10\.99\.0\.1/24'; then
  "${SUDO[@]}" ip addr add 10.99.0.1/24 dev dummy0
fi
"${SUDO[@]}" ip link set dummy0 up

echo
echo "Состояние dummy0:"
ip -br addr show dummy0

echo
echo "Проверка связи с собственным адресом:"
ping -c 2 10.99.0.1

echo
echo "Интерфейс оставлен включённым для задач 8 и 9."
echo "Откат: sudo ip link del dummy0"
