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
  echo "Ошибка: для изменения MAC-адреса нужен root или sudo." >&2
  exit 1
fi

if [[ "${1:-}" == "--cleanup" ]]; then
  if ip link show dummy0 >/dev/null 2>&1; then
    "${SUDO[@]}" ip link del dummy0
    echo "Интерфейс dummy0 удалён."
  else
    echo "Интерфейс dummy0 уже отсутствует."
  fi
  exit 0
fi

if ! ip link show dummy0 >/dev/null 2>&1; then
  echo "Ошибка: интерфейс dummy0 не найден. Сначала запустите 07_create_dummy.sh." >&2
  exit 1
fi

interface_is_down=false
restore_interface() {
  if [[ "$interface_is_down" == true ]]; then
    "${SUDO[@]}" ip link set dummy0 up 2>/dev/null || true
  fi
}
trap restore_interface EXIT

"${SUDO[@]}" ip link set dummy0 down
interface_is_down=true
"${SUDO[@]}" ip link set dummy0 address 02:00:00:00:00:42
"${SUDO[@]}" ip link set dummy0 up
interface_is_down=false

echo "MAC-адрес dummy0 изменён:"
ip link show dummy0 | grep 'link/ether'

actual_mac=$(ip -o link show dummy0 | awk '{for (i = 1; i <= NF; i++) if ($i == "link/ether") {print $(i + 1); exit}}')
if [[ "$actual_mac" != "02:00:00:00:00:42" ]]; then
  echo "Ошибка: получен неожиданный MAC-адрес $actual_mac." >&2
  exit 1
fi

echo "Проверка пройдена."
echo "Откат: $0 --cleanup"
