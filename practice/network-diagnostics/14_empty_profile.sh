#!/usr/bin/env bash

# Задача 14. Создаёт неактивный dummy-профиль и затем удаляет его.

set -u

if nmcli connection show test-profile >/dev/null 2>&1; then
    echo "Профиль test-profile уже существует. Сначала удалите или переименуйте его."
    exit 1
fi

created=0

cleanup() {
    if [[ $created -eq 1 ]]; then
        echo "Удаляю test-profile..."
        sudo nmcli connection delete test-profile >/dev/null || true
    fi
}

trap cleanup EXIT

sudo nmcli connection add type dummy ifname dummy-test con-name test-profile
created=1

echo
echo "Профиль создан, но не активирован:"
nmcli -f NAME,TYPE,DEVICE,STATE connection show

read -r -p "Нажмите Enter, чтобы удалить тестовый профиль..."
