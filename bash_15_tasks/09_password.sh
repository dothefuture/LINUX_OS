#!/bin/bash
CORRECT="secret"
attempts=3
while [ "$attempts" -gt 0 ]; do
    read -s -p "Введите пароль: " pass
    echo
    if [ "$pass" = "$CORRECT" ]; then
        echo "Доступ разрешён"
        exit 0
    fi
    attempts=$((attempts - 1))
    echo "Неверный пароль. Осталось попыток: $attempts"
done
echo "Доступ запрещён"
exit 1