#!/bin/bash
# Использование: ./01_sign.sh <число>
n=$1
if [ -z "$n" ]; then
    echo "Использование: $0 <число>"
    exit 1
fi
if [ "$n" -gt 0 ] 2>/dev/null; then
    echo "положительное"
elif [ "$n" -lt 0 ] 2>/dev/null; then
    echo "отрицательное"
elif [ "$n" -eq 0 ] 2>/dev/null; then
    echo "ноль"
else
    echo "неверное значение"
fi