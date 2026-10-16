#!/usr/bin/env bash

read -r -a words -p "Введите несколько слов: "

for index in "${!words[@]}"; do
    echo "$((index + 1)). ${words[index]}"
done
