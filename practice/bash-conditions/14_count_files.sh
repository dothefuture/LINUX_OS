#!/bin/bash
count_files() {
    local dir=$1
    if [ ! -d "$dir" ]; then
        echo "директория не найдена: $dir" >&2
        return 1
    fi
    find "$dir" -maxdepth 1 -type f | wc -l
}

# вызов: ./14_count_files.sh /path/to/dir
count_files "${1:-.}"