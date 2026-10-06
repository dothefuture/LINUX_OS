#! /bin/bash
# $() - command substitution
kernel=$(uname -s)
free_root=$(df -h / | awk 'NR==2{print $4}')
files=$(ls -A /etc | wc -l)
echo "Kernel: $kernel"
echo "Free /: $free_root"
echo "file in /etc: $files"