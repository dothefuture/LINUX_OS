#!/bin/bash
# Задача 7. Свой die()
# Использование: ./07_die.sh <файл>

die() {
    echo "ОШИБКА: $*" >&2
    exit 1
}

if [ $# -lt 1 ]; then
    die "укажите файл"
fi

if [ ! -r "$1" ]; then
    die "нет доступа к $1"
fi

echo "Файл читаем: $1"