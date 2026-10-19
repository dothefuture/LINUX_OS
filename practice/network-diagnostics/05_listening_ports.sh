#!/usr/bin/env bash
set -euo pipefail

command -v ss >/dev/null 2>&1 || {
  echo "Ошибка: команда ss не найдена (установите пакет iproute2)." >&2
  exit 1
}

if (( EUID == 0 )); then
  SUDO=()
elif command -v sudo >/dev/null 2>&1; then
  SUDO=(sudo)
else
  echo "Ошибка: для показа процессов нужен root или sudo." >&2
  exit 1
fi

echo "Все слушающие TCP-порты:"
ports_output=$("${SUDO[@]}" ss -tlpn)
printf '%s\n' "$ports_output"

echo
echo "Поиск процесса sshd:"
ssh_lines=$(grep -F 'sshd' <<< "$ports_output" || true)

if [[ -z "$ssh_lines" ]]; then
  echo "Слушающий процесс sshd не найден."
  exit 0
fi

printf '%s\n' "$ssh_lines"
ssh_ports=$(awk 'NR > 0 {address=$4; sub(/^.*:/, "", address); print address}' <<< "$ssh_lines" | sort -nu | paste -sd, -)
echo "Порт(ы) SSH: $ssh_ports"

if grep -Eq '(^|[[:space:]])(0\.0\.0\.0|\*|\[::\]):[0-9]+[[:space:]]' <<< "$ssh_lines"; then
  echo "SSH слушает все интерфейсы."
elif grep -Eq '(^|[[:space:]])(127\.0\.0\.1|\[::1\]):[0-9]+[[:space:]]' <<< "$ssh_lines"; then
  echo "SSH слушает только localhost."
else
  echo "SSH слушает конкретный адрес; он указан в строке выше."
fi

echo
echo "Отдельная проверка стандартного порта 22:"
grep -E '(^|[[:space:]])([^[:space:]]*:)?22[[:space:]]' <<< "$ports_output" || echo "TCP-порт 22 не прослушивается."
