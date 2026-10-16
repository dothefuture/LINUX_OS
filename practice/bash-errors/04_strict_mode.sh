#!/bin/bash
# Задача 4. Strict mode

set -euo pipefail

trap 'echo "Переменная не задана"' ERR

check_variable() {
    if [[ ! -v UNDEFINED_VAR ]]; then
        return 1
    fi
    echo "$UNDEFINED_VAR"
}

check_variable
