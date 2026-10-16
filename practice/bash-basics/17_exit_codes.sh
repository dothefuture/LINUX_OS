#!/usr/bin/env bash

ls /nonexistent >/dev/null 2>&1
bad_code=$?
echo "Код для /nonexistent: $bad_code"

ls / >/dev/null 2>&1
good_code=$?
echo "Код для /: $good_code"

echo "Ноль означает успешное выполнение, ненулевой код означает ошибку."
