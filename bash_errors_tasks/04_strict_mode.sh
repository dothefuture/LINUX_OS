#!/bin/bash
# Задача 4. Strict mode

set -euo pipefail

trap 'echo "Переменная не задана"' ERR

# Обращение к незаданной переменной при set -u вызовет ERR
echo "$UNDEFINED_VAR"