#!/bin/bash
read -p "Введите высоту N: " n
for ((i=1; i<=n; i++)); do
    spaces=$((n - i))
    stars=$((2 * i - 1))
    printf "%*s" "$spaces" ""
    printf "%*s\n" "$stars" "" | tr ' ' '*'
done