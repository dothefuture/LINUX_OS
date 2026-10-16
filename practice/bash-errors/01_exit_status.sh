#!/bin/bash
# Задача 1. Базовый $? и &&/||

test -f /etc/passwd && echo "Файл есть" || echo "Файла нет"
echo "Код возврата: $?"