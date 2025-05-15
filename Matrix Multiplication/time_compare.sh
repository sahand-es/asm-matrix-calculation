#!/bin/bash

# Define ANSI escape code for blue color
CYAN='\u001b[31m'
NC='\033[0m' # No Color

# Print blue-colored titles
echo -e "${CYAN}  n  | Mean Time (ASM) | Mean Time (Parallel ASM) | Mean Time (Python) | Mean Time (Java)${NC}"
echo -e "${CYAN}-----+-----------------+--------------------------+--------------------+-----------------${NC}"

# Loop through powers of 2 from 2^1 to 2^8
for ((power = 1; power <= 8; power++)); do
    n=$((2 ** power))
    total_time_asm=0
    total_time_par_asm=0
    total_time_py=0
    total_time_java=0
    num_runs=5  # Number of runs for each n value

    for ((i = 1; i <= num_runs; i++)); do
        ./matrix_mul.sh "$n" 
        read time_asm time_par_asm time_py time_java < times.txt
        total_time_asm=$(awk "BEGIN {print $total_time_asm + $time_asm}")
        total_time_par_asm=$(awk "BEGIN {print $total_time_par_asm + $time_par_asm}")
        total_time_py=$(awk "BEGIN {print $total_time_py + $time_py}")
        total_time_java=$(awk "BEGIN {print $total_time_java + $time_java}")
    done

    mean_time_asm=$(awk "BEGIN {print $total_time_asm / $num_runs}")
    mean_time_par_asm=$(awk "BEGIN {print $total_time_par_asm / $num_runs}")
    mean_time_py=$(awk "BEGIN {print $total_time_py / $num_runs}")
    mean_time_java=$(awk "BEGIN {print $total_time_java / $num_runs}")

    printf "%3d  | %15s | %24s | %18s | %15s\n" "$n" "$mean_time_asm" "$mean_time_par_asm" "$mean_time_py" "$mean_time_java"
done
