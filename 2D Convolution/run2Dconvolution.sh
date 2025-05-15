#!/bin/bash
nasm -f elf64 ../asm_io.asm && 
gcc -m64 -no-pie -std=c17 -c ../driver.c
nasm -f elf64 convolution2D.asm &&
gcc -m64 -no-pie -std=c17 -o convolution2D ../driver.c convolution2D.o ../asm_io.o &&
./convolution2D
