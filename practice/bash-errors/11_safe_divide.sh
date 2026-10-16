#!/usr/bin/env bash

safe_divide() {
    local a=$1
    local b=$2

    if [ "$b" -eq 0 ]; then
        echo "Ошибка: деление на ноль" >&2
        return 1
    fi

    echo $((a / b))
    return 0
}

safe_divide 10 2
echo "Код возврата: $?"

safe_divide 10 0
echo "Код возврата: $?"
