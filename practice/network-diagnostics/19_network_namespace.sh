#!/usr/bin/env bash

# Задача 19. Создаёт изолированный namespace и проверяет сеть.

set -u

if sudo ip netns list | awk '{print $1}' | grep -qx testns; then
    echo "Namespace testns уже существует. Скрипт не будет его изменять."
    exit 1
fi

created=0

cleanup() {
    if [[ $created -eq 1 ]]; then
        echo "Удаляю testns..."
        sudo ip netns del testns || true
    fi
}

trap cleanup EXIT

sudo ip netns add testns
created=1
sudo ip netns exec testns ip link set lo up

echo "Проверяю loopback:"
sudo ip netns exec testns ping -c 2 127.0.0.1

echo
echo "Проверяю отсутствие внешней сети:"
if sudo ip netns exec testns ping -c 2 -W 2 8.8.8.8; then
    echo "Внешняя сеть доступна, хотя по условию ожидалась изоляция."
else
    echo "Внешняя сеть недоступна — это ожидаемый результат."
fi

read -r -p "Нажмите Enter, чтобы удалить testns..."
