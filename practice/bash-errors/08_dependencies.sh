#!/bin/bash
# Задача 8. command -v и зависимости

missing=()

for cmd in git curl jq; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        missing+=("$cmd")
    fi
done

if [ ${#missing[@]} -gt 0 ]; then
    echo "Отсутствуют: ${missing[*]}" >&2
    exit 127
fi

echo "Все зависимости на месте"