#!/bin/bash
read -p "Введите число (1-10): " n
for i in {1..10}; do
    echo "$n x $i = $((n * i))"
done