#!/usr/bin/env bash

# Задача 13. Временно добавляет DNS 1.1.1.1 и затем удаляет его.

set -u

if ! command -v nmcli >/dev/null 2>&1; then
    echo "Ошибка: команда nmcli не найдена."
    exit 1
fi

profile=$(nmcli -t -f NAME,DEVICE connection show --active | awk -F: '$2 != "" {print $1; exit}')
if [[ -z "$profile" ]]; then
    echo "Активный профиль не найден."
    exit 1
fi

changed=0

rollback() {
    if [[ $changed -eq 1 ]]; then
        echo
        echo "Возвращаю исходные настройки..."
        sudo nmcli connection modify "$profile" -ipv4.dns 1.1.1.1 || true
        sudo nmcli connection down "$profile" || true
        sudo nmcli connection up "$profile" || true
    fi
}

trap rollback EXIT

echo "Профиль: $profile"
echo "DNS до изменения:"
nmcli -g ipv4.dns connection show "$profile"

sudo nmcli connection modify "$profile" +ipv4.dns 1.1.1.1
changed=1
sudo nmcli connection down "$profile"
sudo nmcli connection up "$profile"

echo
echo "DNS после изменения:"
nmcli -g ipv4.dns connection show "$profile"

if command -v resolvectl >/dev/null 2>&1; then
    echo
    resolvectl status | grep -A2 "DNS Servers" || true
fi

read -r -p "Нажмите Enter, чтобы выполнить откат..."
