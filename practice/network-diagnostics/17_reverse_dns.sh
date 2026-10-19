#!/usr/bin/env bash

# Задача 17. Выполняет прямой и обратный DNS-запросы.

if ! command -v dig >/dev/null 2>&1; then
    echo "Ошибка: установите пакет dnsutils или bind-utils."
    exit 1
fi

reverse_name=$(dig -x 8.8.8.8 +short | head -n 1)
cloudflare_ips=$(dig one.one.one.one A +short)

echo "8.8.8.8 → ${reverse_name:-имя не найдено}"
echo "one.one.one.one →"
printf '%s\n' "$cloudflare_ips"

echo
echo "Это разные DNS-сервисы: 8.8.8.8 относится к Google, а one.one.one.one — к Cloudflare."
