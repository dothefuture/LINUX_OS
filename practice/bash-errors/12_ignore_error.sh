#!/usr/bin/env bash

set -e

false || true
echo "После false скрипт продолжил работу"

if ! ls /missing-example >/dev/null 2>&1; then
    echo "Ошибка обработана внутри if"
fi

echo "Успешная команда"

# Конструкция || true игнорирует только выбранную ошибку.
# Команда set +e отключила бы проверку ошибок для всех следующих команд.
