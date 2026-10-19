#!/usr/bin/env bash

# Задача 12. Сохраняет настройки активного профиля в ~/nm-backup.txt.

if ! command -v nmcli >/dev/null 2>&1; then
    echo "Ошибка: команда nmcli не найдена."
    exit 1
fi

profile=$(nmcli -t -f NAME,DEVICE connection show --active | awk -F: '$2 != "" {print $1; exit}')
if [[ -z "$profile" ]]; then
    echo "Активный профиль не найден."
    exit 1
fi

backup="$HOME/nm-backup.txt"

echo "Активный профиль: $profile"
nmcli connection show "$profile" | tee "$backup"

echo
echo "Файл сохранён: $backup"
wc -l "$backup"

echo
echo "Параметры IPv4:"
grep -i 'ipv4' "$backup" || true
