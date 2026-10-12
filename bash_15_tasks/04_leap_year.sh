#!/bin/bash
# Использование: ./04_leap_year.sh <год>
year=$1
if [ -z "$year" ]; then
    echo "Использование: $0 <год>"
    exit 1
fi
if (( year % 400 == 0 )) || (( year % 4 == 0 && year % 100 != 0 )); then
    echo "високосный"
else
    echo "не високосный"
fi