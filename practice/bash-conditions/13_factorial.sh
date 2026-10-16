#!/bin/bash
factorial() {
    if [ "$1" -le 1 ]; then
        echo 1
    else
        local prev
        prev=$(factorial $(($1 - 1)))
        echo $(($1 * prev))
    fi
}

# вызов: ./13_factorial.sh 5
factorial "$1"