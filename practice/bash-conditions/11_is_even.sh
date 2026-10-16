#!/bin/bash
is_even() {
    if (( $1 % 2 == 0 )); then
        return 0
    else
        return 1
    fi
}

for i in {1..20}; do
    if is_even "$i"; then
        echo "$i"
    fi
done