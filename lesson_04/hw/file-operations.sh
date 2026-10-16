#!/usr/bin/env bash

set -u

workdir="$(mktemp -d -t file-homework.XXXXXX)"
trap 'rm -rf -- "$workdir"' EXIT

run() {
    printf '\n$'
    printf ' %q' "$@"
    printf '\n'
    "$@"
}

echo "Рабочий каталог: $workdir"
cd "$workdir"

run pwd
run mkdir dir
run bash -c 'cd "$1/dir"; pwd' bash "$workdir"
run mkdir -m 750 private
run mkdir dir1 dir2 dir3
run mkdir -p tree/level2/level3
run touch file1 file2 file3 notes.txt docs.txt
printf '1 Ivan 578 moscow\n2 Peter 435 newyork\n3 Sasha 734 orel\n' > tabl1
printf 'linux\nRed Hat Linux\nget\nput\nprint\nwrite\n' > docs.txt

run ls
run ls -F
run ls -l
run cat docs.txt
run more docs.txt
run cp file1 file1-copy
echo
echo '$ printf n | cp -i file1 file1-copy'
printf 'n\n' | cp -i file1 file1-copy
run cp -r tree tree-copy
run mv file2 renamed-file2
run mv renamed-file2 dir/
run cut -c 1,3,4,5,16-22 tabl1
run grep linux docs.txt
run grep -ci 'Red Hat Linux' docs.txt
run grep -E 'get|put|print|write' docs.txt
run grep '^l.*x$' docs.txt
run find . -name '*.txt'
run find . -maxdepth 1 -type f

echo
for tool in ed vi man; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "$tool: $(command -v "$tool")"
    else
        echo "$tool: команда не установлена"
    fi
done

run rm file3
run rm -r tree-copy
run rmdir dir1 dir2 dir3

echo
echo "Итоговое содержимое:"
run find . -maxdepth 3 -print
