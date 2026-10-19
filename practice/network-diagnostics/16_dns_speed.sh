#!/usr/bin/env bash

# Задача 16. Сравнивает время ответа двух DNS и системного резолвера.

if ! command -v dig >/dev/null 2>&1; then
    echo "Ошибка: установите пакет dnsutils или bind-utils."
    exit 1
fi

measure() {
    local name=$1
    shift
    local output time address

    output=$(dig example.com A "$@")
    time=$(awk '/Query time:/ {print $4; exit}' <<< "$output")
    address=$(awk '/^example\.com\..*IN[[:space:]]+A[[:space:]]+/ {print $5; exit}' <<< "$output")

    if [[ -z "$time" || -z "$address" ]]; then
        echo "Не удалось получить ответ от $name." >&2
        return 1
    fi

    echo "$name: ${time} мс, A-запись $address" >&2
    printf '%s' "$time"
}

google_time=$(measure "8.8.8.8" @8.8.8.8) || exit 1
cloudflare_time=$(measure "1.1.1.1" @1.1.1.1) || exit 1
system_time=$(measure "Системный DNS") || exit 1

fastest_name="8.8.8.8"
fastest_time=$google_time

if (( cloudflare_time < fastest_time )); then
    fastest_name="1.1.1.1"
    fastest_time=$cloudflare_time
fi

if (( system_time < fastest_time )); then
    fastest_name="Системный DNS"
    fastest_time=$system_time
fi

echo
echo "Самый быстрый: $fastest_name — ${fastest_time} мс."
