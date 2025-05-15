#!/bin/bash
nasm -f elf64 asm_io.asm && 
gcc -m64 -no-pie -std=c17 -c ../driver.c
nasm -f elf64 MatrixMulAsm.asm &&
gcc -m64 -no-pie -std=c17 -o MatrixMulAsm ../driver.c MatrixMulAsm.o asm_io.o &&
./MatrixMulAsm