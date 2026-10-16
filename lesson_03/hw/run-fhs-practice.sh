#!/usr/bin/env bash

set -u

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
out="$repo/lesson_03/hw/output"
lab="$(mktemp -d -t linux-fhs-lab.XXXXXX)"
mounted=0

cleanup() {
    if [ "$mounted" -eq 1 ]; then
        umount "$lab/mount-demo" 2>/dev/null || true
    fi
    rm -rf "$lab"
}
trap cleanup EXIT

mkdir -p "$out"

{
    echo '$ cd /'
    cd /
    echo '$ pwd'
    pwd
    echo '$ ls -lah /'
    ls -lah / | head -n 28
} > "$out/01-root.txt" 2>&1

{
    echo '$ cd ~'
    cd ~
    echo '$ pwd'
    pwd
    echo '$ ls -a'
    ls -a | head -n 30
} > "$out/02-home.txt" 2>&1

{
    echo '$ cat /etc/os-release'
    cat /etc/os-release
    echo
    echo '$ getent passwd root nobody'
    getent passwd root nobody
} > "$out/03-system.txt" 2>&1

{
    clean_path='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'
    echo '$ command -v python3'
    PATH="$clean_path" command -v python3
    echo '$ type cd'
    type cd
    echo '$ type ls'
    PATH="$clean_path" type ls
    echo '$ echo "$PATH"'
    echo "$clean_path"
} > "$out/04-programs.txt" 2>&1

{
    echo '$ ls /var'
    ls /var
    echo '$ findmnt -T /run'
    findmnt -T /run
} > "$out/05-var.txt" 2>&1

{
    echo '$ ls -l /dev/null'
    ls -l /dev/null
    echo '$ echo $?'
    echo $?
} > "$out/06-dev.txt" 2>&1

{
    cd "$lab"
    echo '$ cat /proc/uptime'
    cat /proc/uptime
    echo '$ cp /proc/uptime saved-uptime.txt'
    cp /proc/uptime saved-uptime.txt
    echo '$ sleep 2'
    sleep 2
    echo '$ cat /proc/uptime'
    cat /proc/uptime
    echo '$ cat saved-uptime.txt'
    cat saved-uptime.txt
} > "$out/07-proc.txt" 2>&1

{
    echo '$ ls /sys/class/net'
    ls /sys/class/net
} > "$out/08-sys.txt" 2>&1

{
    cd "$lab"
    mkdir -p data
    printf 'Linux filesystem\n' > data/info.txt
    ln data/info.txt data/info-hard.txt
    ln -s data/info.txt info-link.txt
    echo '$ ls -li data/info.txt data/info-hard.txt info-link.txt'
    ls -li data/info.txt data/info-hard.txt info-link.txt
    echo '$ rm data/info.txt'
    rm data/info.txt
    echo '$ cat info-link.txt'
    cat info-link.txt 2>&1 || true
    echo '$ cat data/info-hard.txt'
    cat data/info-hard.txt
} > "$out/09-links.txt" 2>&1

{
    cd "$lab"
    echo '$ findmnt /'
    findmnt /
    echo '$ df -h .'
    df -h .
    echo '$ du -sh data'
    du -sh data
} > "$out/10-space.txt" 2>&1

mkdir -p "$lab/mount-demo"
printf 'on original filesystem\n' > "$lab/mount-demo/before.txt"
mount -t tmpfs -o size=4m tmpfs "$lab/mount-demo"
mounted=1
printf 'inside tmpfs\n' > "$lab/mount-demo/inside.txt"

{
    cd "$lab"
    echo '$ findmnt -T mount-demo'
    findmnt -T mount-demo
    echo '$ ls -la mount-demo'
    ls -la mount-demo
    echo '$ cat mount-demo/before.txt'
    cat mount-demo/before.txt 2>&1 || true
} > "$out/11-mount-before.txt" 2>&1

umount "$lab/mount-demo"
mounted=0

{
    cd "$lab"
    echo '$ findmnt -T mount-demo'
    findmnt -T mount-demo
    echo '$ cat mount-demo/before.txt'
    cat mount-demo/before.txt
    echo '$ ls mount-demo/inside.txt'
    ls mount-demo/inside.txt 2>&1 || true
} > "$out/12-mount-after.txt" 2>&1

{
    cd "$lab"
    mkdir -p model-root/etc/shop-api
    mkdir -p model-root/var/lib/shop-api
    mkdir -p model-root/var/log/shop-api
    touch model-root/etc/shop-api/app.conf
    touch model-root/var/lib/shop-api/database.db
    touch model-root/var/log/shop-api/app.log
    echo '$ find model-root -type f | sort'
    find model-root -type f | sort
} > "$out/13-model.txt" 2>&1

echo "FHS practice completed"
