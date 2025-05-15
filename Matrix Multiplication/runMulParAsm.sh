#!/bin/bash
nasm -f elf64 asm_io.asm && 
gcc -m64 -no-pie -std=c17 -c ../driver.c
nasm -f elf64 MatrixMulParAsm.asm &&
gcc -m64 -no-pie -std=c17 -o MatrixMulParAsm ../driver.c MatrixMulParAsm.o asm_io.o &&
./MatrixMulParAsm