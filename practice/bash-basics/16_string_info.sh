#!/usr/bin/env bash

read -r -p "Введите строку: " text
echo "Верхний регистр: ${text^^}"
echo "Нижний регистр: ${text,,}"
echo "Длина: ${#text}"
