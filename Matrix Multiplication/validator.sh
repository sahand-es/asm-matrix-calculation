#!/bin/bash

if [ -z "$1" ]; then
    echo "Please enter a n for tests!"
    exit
fi

echo Running 10 tests with n = $1


for ((x = 1; x <= 10; x++)); do
    # echo "Running with n = $x:"
    ./matrix_mul.sh $1 
    echo test$x >> validate_this.txt
    python3 validator.py < validate_this.txt
done