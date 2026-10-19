#!/usr/bin/env bash

# Задача 21. Запускает временный TCP-слушатель и проверяет порт 8080.

set -u

if ! command -v nc >/dev/null 2>&1; then
    echo "Ошибка: команда nc не найдена. Установите netcat."
    exit 1
fi

listener_pid=""

cleanup() {
    if [[ -n "$listener_pid" ]]; then
        kill "$listener_pid" 2>/dev/null || true
        wait "$listener_pid" 2>/dev/null || true
    fi
}

trap cleanup EXIT

nc -l 8080 >/dev/null 2>&1 &
listener_pid=$!
sleep 1

echo "Проверяю порт 8080:"
if nc -zv 127.0.0.1 8080; then
    echo "Порт 8080 доступен."
else
    echo "Не удалось подключиться к порту 8080."
    exit 1
fi
