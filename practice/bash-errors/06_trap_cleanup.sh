#!/bin/bash
# Задача 6. trap на EXIT и сигналы
# Запуск: ./06_trap_cleanup.sh
# Проверка Ctrl+C: подожди пару секунд и нажми Ctrl+C

TMPDIR_PATH=$(mktemp -d)
echo "Временная директория: $TMPDIR_PATH"

cleanup() {
    rm -rf "$TMPDIR_PATH"
    echo "Убрано"
}

trap cleanup EXIT INT TERM

echo "Спим 30 секунд (Ctrl+C для проверки cleanup)..."
sleep 30
echo "Обычное завершение"