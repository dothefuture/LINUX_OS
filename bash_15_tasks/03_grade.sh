#!/bin/bash
# Использование: ./03_grade.sh <оценка 1-5>
grade=$1
case "$grade" in
    5) echo "отлично" ;;
    4) echo "хорошо" ;;
    3) echo "удовлетворительно" ;;
    1|2) echo "плохо" ;;
    *) echo "неверная оценка" ;;
esac