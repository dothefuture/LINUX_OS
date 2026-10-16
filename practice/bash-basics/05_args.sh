#! /bin/bash
# $0 name, $1.. args, $@ all, $# count
echo "name script $0"
echo "count: $#"
echo "All arg: $*"
echo "1 arg:  $1"
if [ $# -gt 0 ]; then
  eval "echo \"last arg: \${$#}\""
else
  echo "last arg: (none)"
fi