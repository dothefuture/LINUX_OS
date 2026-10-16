#!/usr/bin/env bash

read -r -p "Логин: " login
read -r -s -p "Пароль: " password
echo

if [ -z "$password" ]; then
    echo "Пароль не введён" >&2
    exit 1
fi

echo "Пользователь $login авторизован"
