#! /bin/bash
echo "--- bez export ---"
MYVAR="secret"
bash -c 'echo MYVAR=$MYVAR'
echo "--- s export ---"
export MYVAR="secret"
bash -c 'echo MYVAR=$MYVAR'