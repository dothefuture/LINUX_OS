#!/usr/bin/env bash

# Задача 18. Временно добавляет mytest.local в /etc/hosts и восстанавливает файл.

set -u

backup=$(mktemp)
restored=0

restore_hosts() {
    if [[ $restored -eq 0 ]]; then
        echo
        echo "Восстанавливаю /etc/hosts..."
        sudo cp "$backup" /etc/hosts || true
        restored=1
    fi
    rm -f "$backup"
}

trap restore_hosts EXIT

sudo cp /etc/hosts "$backup"

if grep -qE '(^|[[:space:]])mytest\.local([[:space:]]|$)' /etc/hosts; then
    echo "Запись mytest.local уже есть в /etc/hosts. Изменения не внесены."
    restored=1
    exit 1
fi

echo "127.0.0.1 mytest.local" | sudo tee -a /etc/hosts >/dev/null

echo "Проверяю временную запись:"
grep 'mytest.local' /etc/hosts
ping -c 2 mytest.local

read -r -p "Нажмите Enter, чтобы восстановить /etc/hosts..."
restore_hosts

echo
if grep -q 'mytest.local' /etc/hosts; then
    echo "Запись всё ещё найдена. Проверьте /etc/hosts вручную."
    exit 1
else
    echo "Откат выполнен: записи mytest.local больше нет."
fi
