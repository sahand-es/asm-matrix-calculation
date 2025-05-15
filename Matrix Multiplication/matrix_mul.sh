# !bin/bash

if [ -z "$1" ]; then
    echo "Please enter a n for matrices!"
    exit
fi


echo $1 | python3 inputGenerate.py > input.txt

first_line=$(head -n 1 input.txt)

# Check if the first line equals "too big n"
if ! (grep -qE '^[0-9]+$' <<< "$first_line"); then
echo $first_line
    exit 
fi

./runMulAsm.sh < input.txt > asm_out.txt
./runMulParAsm.sh < input.txt > asm_par_out.txt
python3 MatrixMul.py < input.txt > py_out.txt
java MatrixMul < input.txt > java_out.txt


# Measure the runtime of run2Dconvolution.sh and save it to time_asm
time_asm=$( { time ./runMulAsm.sh < input.txt; } 2>&1 | grep 'real' | awk -F 'm|s' '{print $2}' )

time_par_asm=$( { time ./runMulParAsm.sh < input.txt; } 2>&1 | grep 'real' | awk -F 'm|s' '{print $2}' )

# Measure the runtime of timeCompare.py and save it to time_py
time_py=$( { time python3 MatrixMul.py < input.txt; } 2>&1 | grep real | awk -F 'm|s' '{print $2}' )

time_java=$( { time java MatrixMul < input.txt; } 2>&1 | grep real | awk -F 'm|s' '{print $2}' )


cat py_out.txt > validate_this.txt
cat asm_out.txt >> validate_this.txt


if !([ -z "$2" ]); then
    echo input:
    cat input.txt
    echo -e "\nAsm output:\n"
    cat asm_out.txt
    echo -e "\nParallel Asm output:\n"
    cat asm_par_out.txt
    echo -e "Python output:\n"
    cat py_out.txt
    echo -e "\nJava output:\n"
    cat java_out.txt
    
fi

echo $time_asm $time_par_asm $time_py $time_java > times.txt


# rm input.txt asm_out.txt py_out.txt validate_this.txt
