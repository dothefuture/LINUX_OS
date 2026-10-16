#!/usr/bin/env bash

set -u

sleep 120 &
sleep_pid=$!
tail -f /dev/null >/dev/null 2>&1 &
tail_pid=$!
trap 'kill "$sleep_pid" "$tail_pid" 2>/dev/null || true' EXIT

echo '$ head -n 20 /proc/iomem'
head -n 20 /proc/iomem

echo
echo '$ head -n 30 /proc/meminfo'
head -n 30 /proc/meminfo

echo
printf 'Процессы: bash=%s sleep=%s tail=%s\n' "$$" "$sleep_pid" "$tail_pid"

for pid in "$$" "$sleep_pid" "$tail_pid"; do
    echo
    echo "$ head -n 12 /proc/$pid/maps"
    head -n 12 "/proc/$pid/maps"
done

for pid in "$$" "$sleep_pid" "$tail_pid"; do
    echo
    echo "$ ls -l /proc/$pid/mem"
    ls -l "/proc/$pid/mem"
    echo "$ dd if=/proc/$pid/mem bs=16 count=1 status=none"
    sample="$(mktemp)"
    error="$(mktemp)"
    if dd if="/proc/$pid/mem" of="$sample" bs=16 count=1 status=none 2>"$error"; then
        od -An -tx1 "$sample"
        echo "Чтение завершено"
    else
        cat "$error"
        echo "Чтение ограничено ядром"
    fi
    rm -f "$sample" "$error"
done
