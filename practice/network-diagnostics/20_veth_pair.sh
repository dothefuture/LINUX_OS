#!/usr/bin/env bash

# Задача 20. Соединяет хост и namespace парой veth.

set -u

if sudo ip netns list | awk '{print $1}' | grep -qx testns; then
    echo "Namespace testns уже существует. Скрипт не будет его изменять."
    exit 1
fi

if ip link show veth-host >/dev/null 2>&1; then
    echo "Интерфейс veth-host уже существует."
    exit 1
fi

created=0

cleanup() {
    if [[ $created -eq 1 ]]; then
        echo "Удаляю testns и созданную veth-пару..."
        sudo ip netns del testns || true
    fi
}

trap cleanup EXIT

sudo ip netns add testns
created=1
sudo ip netns exec testns ip link set lo up

sudo ip link add veth-host type veth peer name veth-ns
sudo ip link set veth-ns netns testns

sudo ip addr add 10.50.0.1/24 dev veth-host
sudo ip link set veth-host up

sudo ip netns exec testns ip addr add 10.50.0.2/24 dev veth-ns
sudo ip netns exec testns ip link set veth-ns up

echo "Пинг из хоста в namespace:"
ping -c 2 10.50.0.2

echo
echo "Пинг из namespace в хост:"
sudo ip netns exec testns ping -c 2 10.50.0.1

read -r -p "Нажмите Enter, чтобы удалить тестовую сеть..."
