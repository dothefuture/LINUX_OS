#!/bin/bash
check_host() {
    local host=$1
    if ping -c 1 -W 2 "$host" >/dev/null 2>&1; then
        echo "$host: доступен"
    else
        echo "$host: недоступен"
    fi
}

for h in 127.0.0.1 8.8.8.8 1.1.1.1 ya.ru github.com; do
    check_host "$h"
done