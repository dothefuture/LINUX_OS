#!/bin/bash
find . -maxdepth 1 -type f -printf "%s\t%p\n" | sort -n | while IFS=$'\t' read -r size name; do
    echo "$size байт  $name"
done