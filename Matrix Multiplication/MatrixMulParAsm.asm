%include "asm_io.inc"         ; Include the assembly I/O library

segment .data                 ; Define the data segment
    matrix_1 dd 68000 DUP(0)  ; Declaration of matrix_1 with 68000 elements initialized to 0
    matrix_2 dd 68000 DUP(0)  ; Declaration of matrix_2 with 68000 elements initialized to 0
    _i dq 0                    ; Declaration of _i variable initialized to 0
    _j dq 0                    ; Declaration of _j variable initialized to 0
    _k dq 0                    ; Declaration of _k variable initialized to 0
    n dq 0                     ; Declaration of n variable initialized to 0
    n_squared dq 0             ; Declaration of n_squared variable initialized to 0
    result dd 68000 DUP(0)     ; Declaration of result array with 68000 elements initialized to 0
    one dd 1.0, 0.0, 0.0, 0.0  ; Declaration of one array with 4 floating-point values
    two dd 1.0, 1.0, 0.0, 0.0  ; Declaration of two array with 4 floating-point values
    three dd 1.0, 1.0, 1.0, 0.0; Declaration of three array with 4 floating-point values
    four dd 1.0, 1.0, 1.0, 1.0 ; Declaration of four array with 4 floating-point values

segment .text                 ; Define the code segment

global asm_main               ; Define asm_main as a global symbol

asm_main:                     ; Start of the asm_main function

    push rbp                  ; Save the value of rbp register on the stack
    push rbx                  ; Save the value of rbx register on the stack
    push r12                  ; Save the value of r12 register on the stack
    push r13                  ; Save the value of r13 register on the stack
    push r14                  ; Save the value of r14 register on the stack
    push r15                  ; Save the value of r15 register on the stack

    sub rsp, 8                ; Allocate space on the stack

    call read_int             ; Call read_int to read an integer from input
    mov [n], eax              ; Move the value read into the n variable

    imul eax, eax             ; Multiply eax by itself
    mov [n_squared], eax      ; Move the result into the n_squared variable

    mov ebx, 0                ; Initialize ebx to 0

    input_loop1:              ; Start of the loop to read input for matrix_1
        cmp ebx, [n_squared]  ; Compare ebx with n_squared
        jge input_loop1_end   ; Jump to input_loop1_end if ebx is greater than or equal to n_squared

        call read_float       ; Call read_float to read a floating-point number from input
        mov matrix_1[ebx*4], eax ; Move the value read into the matrix_1 array
        mov edi, ebx          ; Move ebx into edi for printing purposes

        inc ebx               ; Increment ebx
        jmp input_loop1       ; Jump back to input_loop1

    input_loop1_end:

    mov ebx, 0                ; Initialize ebx to 0

    input_loop2:              ; Start of the loop to read input for matrix_2
        cmp ebx, [n_squared]  ; Compare ebx with n_squared
        jge input_loop2_end   ; Jump to input_loop2_end if ebx is greater than or equal to n_squared

        call read_float       ; Call read_float to read a floating-point number from input
        mov  result[ebx*4], eax ; Move the value read into the matrix_2 array
        mov edi, ebx          ; Move ebx into edi for printing purposes

        inc ebx               ; Increment ebx
        jmp input_loop2       ; Jump back to input_loop2

    input_loop2_end: 


    ;Transpose second matrix

    xor eax, eax              ; Clear eax register
    xor rcx, rcx              ; Clear rcx register
    mov eax, 0                ; Initialize eax to 0
    mov ebx, 0                ; Initialize ebx to 0
    mov r12, [n]              ; Move the value of n into r12

    loop_i_t:                 ; Start of the loop for i
        mov qword [_j], 0     ; Set _j to 0
        loop_j_t:    

            mov rcx, [n]      ; Move the value of n into rcx
            imul rcx, [_i]    ; Multiply rcx by _i
            add rcx, [_j]     ; Add _j to rcx
            mov eax, result[rcx*4] ; Move the value at matrix_1[i][j] into eax 

            mov dword result[rcx*4], 0 ; Set result[i][j] to 0

            mov rcx, [n]      ; Move the value of n into rcx
            imul rcx, [_j]    ; Multiply rcx by _i
            add rcx, [_i]     ; Add _i to rcx
            mov matrix_2[rcx*4], eax ; Store the transposed value to matrix_2

        inc qword [_j]         ; Increment _j
        cmp r12, [_j]          ; Compare r12 with _j
        jg loop_j_t            ; Jump to loop_j if r12 is greater than _j

    inc qword [_i]            ; Increment _i
    cmp r12, [_i]             ; Compare r12 with _i
    jg loop_i_t               ; Jump to loop_i if r12 is greater than _i

    mov qword [_i], 0         ; Clear _i
    mov qword [_j], 0         ; Clear _j

    mov eax, 0                ; Initialize eax to 0
    mov ebx, 0                ; Initialize ebx to 0
    mov r12, [n]              ; Move the value of n into r12
    movups xmm4, [four]      ; Load four into xmm4

    loop_i:                   ; Start of the loop for i
        mov qword [_j], 0     ; Set _j to 0
        loop_j:               ; Start of the loop for j
            mov qword [_k], 0 ; Set _k to 0
            xor rax, rax      ; Clear rax register
            pxor xmm5, xmm5   ; Clear xmm5 register
            loop_k:           ; Start of the loop for k    

                add qword [_k], 4  ; Increment _k by 4
                cmp r12, [_k]      ; Compare r12 with _k
                jl load_with_zero  ; Jump to load_with_zero if r12 is less than _k

                normal_load:       ; Normal load if r12 is greater than or equal to _k
                    mov r14, [_k]             ; Move _k to r14
                    sub r14, 4                ; Decrement r14 by 4
                    mov rcx, [n]              ; Move the value of n into rcx
                    imul rcx, [_i]            ; Multiply rcx by _i
                    add rcx, r14              ; Add r14 to rcx
                    movups xmm6, matrix_1[rcx*4] ; Load matrix_1[i][k] into xmm6
                    mov rcx, [n]              ; Move the value of n into rcx
                    imul rcx, [_j]            ; Multiply rcx by _j
                    add rcx, r14              ; Add r14 to rcx
                    movups xmm1, matrix_2[rcx*4] ; Load matrix_2[j][k] into xmm1
                    dpps xmm6, xmm1, 0xFF     ; Dot product of xmm6 and xmm1
                    addss xmm5, xmm6          ; Add the result to xmm5
                    jmp store_to_result      ; Jump to store_to_result

                load_with_zero:              ; Load with zero if r12 is less than _k
                    mov r14, [_k]             ; Move _k to r14
                    sub r14, 4                ; Decrement r14 by 4
                    mov r13, [n]              ; Move the value of n into r13
                    sub r13, r14              ; Subtract r14 from r13
                    cmp r13, 0                ; Compare r13 with 0
                    je store_to_result        ; Jump to store_to_result if r13 is equal to 0
                    mov rcx, [n]              ; Move the value of n into rcx
                    imul rcx, [_i]            ; Multiply rcx by _i
                    add rcx, r14              ; Add r14 to rcx
                    movups xmm6, matrix_1[rcx*4] ; Load matrix_1[i][k] into xmm6
                    mov rcx, [n]              ; Move the value of n into rcx
                    imul rcx, [_j]            ; Multiply rcx by _j
                    add rcx, r14              ; Add r14 to rcx
                    movups xmm1, matrix_2[rcx*4] ; Load matrix_2[j][k] into xmm1
                    cmp qword r13, 1         ; Compare r13 with 1
                    je one_load              ; Jump to one_load if r13 is equal to 1
                    cmp qword r13, 2         ; Compare r13 with 2
                    je two_load              ; Jump to two_load if r13 is equal to 2
                    cmp qword r13, 3         ; Compare r13 with 3
                    je three_load            ; Jump to three_load if r13 is equal to 3

                    one_load:                ; Load one if r13 is equal to 1
                        movups xmm3, [one]   ; Load one into xmm3
                        mulps xmm6, xmm3     ; Multiply xmm6 by xmm3
                        mulps xmm1, xmm3     ; Multiply xmm1 by xmm3
                        jmp dot              ; Jump to dot

                    two_load:                ; Load two if r13 is equal to 2
                        movups xmm3, [two]   ; Load two into xmm3
                        mulps xmm6, xmm3     ; Multiply xmm6 by xmm3
                        mulps xmm1, xmm3     ; Multiply xmm1 by xmm3
                        jmp dot              ; Jump to dot

                    three_load:              ; Load three if r13 is equal to 3
                        movups xmm3, [three] ; Load three into xmm3
                        mulps xmm6, xmm3     ; Multiply xmm6 by xmm3
                        mulps xmm1, xmm3     ; Multiply xmm1 by xmm3

                    dot:                      ; Calculate dot product
                        dpps xmm6, xmm1, 0xFF ; Dot product of xmm6 and xmm1
                        addss xmm5, xmm6      ; Add the result to xmm5

                store_to_result:             ; Store result to result array
                    cmp r12, [_k]            ; Compare r12 with _k
                    jg loop_k                ; Jump to loop_k if r12 is greater than _k
                    mov rcx, [n]             ; Move the value of n into rcx
                    imul rcx, [_i]           ; Multiply rcx by _i
                    add rcx, [_j]            ; Add _j to rcx
                    movd eax, xmm5           ; Move the value in xmm5 to eax
                    mov result[rcx*4], eax   ; Move the value in eax to result[rcx*4]

            inc qword [_j]            ; Increment _j
            cmp r12, [_j]             ; Compare r12 with _j
            jg loop_j                 ; Jump to loop_j if r12 is greater than _j

        inc qword [_i]               ; Increment _i
        cmp r12, [_i]                ; Compare r12 with _i
        jg loop_i                    ; Jump to loop_i if r12 is greater than _i

    mov ebx, 0                       ; Clear ebx
    xor ebx, ebx                     ; Clear ebx
    xor r12, r12                     ; Clear r12

    mov rdi, [n]                     ; Move the value of n into rdi
    call print_int                   ; Call print_int to print the value of n
    call print_nl                    ; Call print_nl to print a new line

    print_result:                    ; Start of print_result
        cmp ebx, [n_squared]         ; Compare ebx with n_squared
        jge print_result_end         ; Jump to print_result_end if ebx is greater than or equal to n_squared

        mov edi, result[ebx*4]       ; Move the value at result[ebx*4] into edi
        call print_float             ; Call print_float to print the value in edi as a floating-point number
        mov edi, ebx                 ; Move ebx into edi for printing purposes

        inc ebx                      ; Increment ebx
        inc r12                      ; Increment r12

        mov edi, 32                  ; Move 32 into edi (ASCII value for space)
        call print_char              ; Call print_char to print a space character

        cmp r12, [n]                 ; Compare r12 with the value of n
        je print_new_line_result    ; Jump to print_new_line_result if r12 is equal to n

        jmp print_result             ; Jump back to print_result

    print_new_line_result:          ; Start of print_new_line_result
        call print_nl               ; Call print_nl to print a new line
        xor r12, r12                ; Clear r12
        jmp print_result            ; Jump back to print_result

    print_result_end:               ; End of print_result
        call print_nl               ; Call print_nl to print a new line

    add rsp, 8                     ; Restore the stack pointer
    pop r15                        ; Restore the value of r15 register from the stack
    pop r14                        ; Restore the value of r14 register from the stack
    pop r13                        ; Restore the value of r13 register from the stack
    pop r12                        ; Restore the value of r12 register from the stack
    pop rbx                        ; Restore the value of rbx register from the stack
    pop rbp                        ; Restore the value of rbp register from the stack

    ret                            ; Return from asm_main
