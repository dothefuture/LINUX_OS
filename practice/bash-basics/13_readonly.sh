#! /bin/bash
# only read
readonly var="not change"
echo "var=$var"
echo "try change:"
var="new value"
var1=5
echo "var1=$var1"
# delete var
unset var1
echo "after unset var1=${var1-EMPTY}"