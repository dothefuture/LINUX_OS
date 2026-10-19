#!/usr/bin/env bash
set -euo pipefail

command -v dig >/dev/null 2>&1 || {
  echo "Ошибка: команда dig не найдена." >&2
  echo "Ubuntu/Debian: sudo apt install dnsutils" >&2
  echo "Fedora/RHEL: sudo dnf install bind-utils" >&2
  exit 1
}

echo "Настройка системного DNS-резолвера:"
if command -v resolvectl >/dev/null 2>&1; then
  resolvectl status
else
  cat /etc/resolv.conf
fi

echo
echo "=== Запрос через системный резолвер ==="
dig example.com A

echo
echo "=== Прямой запрос через 8.8.8.8 ==="
dig @8.8.8.8 example.com A

echo
echo "Краткое сравнение (SERVER и Query time):"
echo "Системный резолвер:"
dig example.com A | grep -E '^(;; Query time:|;; SERVER:)'
echo "Google DNS 8.8.8.8:"
dig @8.8.8.8 example.com A | grep -E '^(;; Query time:|;; SERVER:)'
