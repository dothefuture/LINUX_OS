#!/usr/bin/env bash

# Задача 11. Показывает профили, устройства и активное подключение.

if ! command -v nmcli >/dev/null 2>&1; then
    echo "Ошибка: команда nmcli не найдена."
    exit 1
fi

echo "Все профили:"
nmcli connection show

echo
echo "Сетевые устройства:"
nmcli device status

echo
echo "Активные профили:"
nmcli -f NAME,DEVICE,STATE connection show --active

main_line=$(nmcli -t -f NAME,DEVICE connection show --active | awk -F: '$2 != "" {print; exit}')
if [[ -n "$main_line" ]]; then
    profile=${main_line%%:*}
    device=${main_line#*:}
    echo
    echo "Основное подключение: профиль '$profile', устройство '$device'."
else
    echo
    echo "Активный профиль с устройством не найден."
fi
