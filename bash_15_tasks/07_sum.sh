#!/bin/bash
read -p "Введите N: " n
sum=0
for ((i=1; i<=n; i++)); do
    sum=$((sum + i))
done
echo "Сумма = $sum"