#!/usr/bin/env bash
set -u

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

failures=0

check_ping() {
  local title=$1
  local target=$2

  echo
  echo "=== $title: $target ==="
  if ping -c 3 -W 3 "$target"; then
    echo "Результат: успешно"
  else
    echo "Результат: ошибка или потеря пакетов" >&2
    failures=$((failures + 1))
  fi
}

check_ping "1. Доступность шлюза" "$gateway"
check_ping "2. IP-связность с интернетом" "8.8.8.8"
check_ping "3. IP-связность и DNS-резолв" "example.com"

echo
if (( failures == 0 )); then
  echo "Все три проверки пройдены без ошибок."
else
  echo "Не пройдено проверок: $failures" >&2
  exit 1
fi
