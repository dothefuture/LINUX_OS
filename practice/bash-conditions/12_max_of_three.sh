#!/bin/bash
max_of_three() {
    local a=$1 b=$2 c=$3
    local max=$a
    [ "$b" -gt "$max" ] && max=$b
    [ "$c" -gt "$max" ] && max=$c
    echo "$max"
}

# вызов: ./12_max_of_three.sh 3 9 1
max_of_three "$1" "$2" "$3"