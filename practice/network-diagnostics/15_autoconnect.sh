#!/usr/bin/env bash

# Задача 15. Переключает autoconnect у test-profile и удаляет профиль.

set -u

created=0

cleanup() {
    if nmcli connection show test-profile >/dev/null 2>&1; then
        echo "Удаляю test-profile..."
        sudo nmcli connection delete test-profile >/dev/null || true
    fi
}

trap cleanup EXIT

if ! nmcli connection show test-profile >/dev/null 2>&1; then
    echo "Создаю test-profile, потому что его ещё нет."
    sudo nmcli connection add type dummy ifname dummy-test con-name test-profile
    created=1
fi

echo
echo "Отключаю autoconnect:"
sudo nmcli connection modify test-profile connection.autoconnect no
nmcli -g connection.autoconnect connection show test-profile

echo
echo "Включаю autoconnect обратно:"
sudo nmcli connection modify test-profile connection.autoconnect yes
nmcli -g connection.autoconnect connection show test-profile

echo
echo "Проверка закончена."
