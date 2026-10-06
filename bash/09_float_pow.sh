#! /bin/bash
# bc for 5.67 style float
res=$(echo "scale=2; 10/3" | bc)
echo "10/3 = $res"
echo "2^10 = $((2**10))"