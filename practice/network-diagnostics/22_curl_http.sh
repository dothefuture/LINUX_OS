#!/usr/bin/env bash

# Задача 22. Загружает example.com, показывает HTTP-код и проверяет файл.

set -u

if ! command -v curl >/dev/null 2>&1; then
    echo "Ошибка: команда curl не найдена."
    exit 1
fi

output="$HOME/example.html"

echo "Загружаю https://example.com..."
http_code=$(curl -sS -o "$output" -w "%{http_code}" https://example.com)
echo "HTTP-код: $http_code"

if [[ "$http_code" != "200" ]]; then
    echo "Ожидался код 200."
    exit 1
fi

echo
ls -l "$output"
echo "Количество тегов title: $(grep -ci '<title>' "$output")"

echo
echo "Запрос с таймаутом 5 секунд:"
curl --max-time 5 -sSI https://example.com | head -n 1
