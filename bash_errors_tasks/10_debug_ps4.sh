#!/bin/bash
# Задача 10. Отладка через set -x и PS4

export PS4='+ ${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '
set -x

multiply() {
    local a=$1
    local b=$2
    echo $((a * b))
}

multiply 6 7