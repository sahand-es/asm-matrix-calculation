#!/bin/bash


if [ -z "$1" ]; then
    echo "Please enter a image name for convolution."
    exit
fi

if [ -z "$2" ]; then
    echo "Please enter a kernel for convolution."
    exit
fi

valid_image_inputs=("jahan" "cat" "flower" "kid")

check_input_image() {
    input="$1"
    for valid_input in "${valid_image_inputs[@]}"; do
        if [ "$input" == "$valid_input" ]; then
            return 0  # Input is valid
        fi
    done
    return 1  # Input is not valid
}

input="$1"

if !(check_input_image "$input"); then
    echo "Input imgae is not valid."
    exit
fi

valid_kernel_inputs=("gaussian_blur_3" "gaussian_blur_5" "emboss" "laplacian" "sharpen")

check_input_kernel() {
    input="$1"
    for valid_input in "${valid_kernel_inputs[@]}"; do
        if [ "$input" == "$valid_input" ]; then
            return 0  # Input is valid
        fi
    done
    return 1  # Input is not valid
}

input="$2"

if !(check_input_kernel "$input"); then
    echo "Input kernel is not valid."
    exit
fi


# Create a file named selected_input.txt containing the image path and additional input data
echo -e "../Images/$1.jpg\n$2" > selected_input.txt

# Generate input.txt by processing selected_input.txt using pictureToMatrix.py
cat selected_input.txt | python3 pictureToMatrix.py > input.txt

# Perform 2D convolution using run2Dconvolution.sh with input from input.txt and save the output to asm_out.txt
cat input.txt | ./run2Dconvolution.sh > asm_out.txt

# Run timeCompare.py with input from selected_input.txt and save the output to py_out.txt
cat selected_input.txt | python3 timeCompare.py > py_out.txt

# Measure the runtime of run2Dconvolution.sh and save it to time_asm
time_asm=$( { time ./run2Dconvolution.sh < input.txt; } 2>&1 | grep real | awk -F 'm|s' '{print $2}')

# Measure the runtime of timeCompare.py and save it to time_py
time_py=$( { time python3 timeCompare.py < selected_input.txt; } 2>&1 | grep real | awk -F 'm|s' '{print $2}' )


# Write the measured runtimes to temp.txt
echo $time_asm $time_py > temp.txt

# Append additional data and filenames to temp.txt
echo $2 >> temp.txt
echo -e "../Images/$1.jpg" >> temp.txt
cat asm_out.txt >> temp.txt
cat py_out.txt >> temp.txt

# Display the images using showPicture.py
cat temp.txt | python3 showPicture.py

# Clean up temporary files
rm asm_out.txt temp.txt selected_input.txt py_out.txt input.txt
