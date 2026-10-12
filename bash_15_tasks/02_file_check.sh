#!/bin/bash
# Использование: ./02_file_check.sh <имя_файла>
if [ -z "$1" ]; then
    echo "Использование: $0 <имя_файла>"
    exit 1
fi
if [ -e "$1" ]; then
    echo "существует: да"
else
    echo "существует: нет"
    exit 0
fi
if [ -d "$1" ]; then
    echo "является директорией: да"
else
    echo "является директорией: нет"
fi
if [ -r "$1" ]; then
    echo "право на чтение: да"
else
    echo "право на чтение: нет"
fi