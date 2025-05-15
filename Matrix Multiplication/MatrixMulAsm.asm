%include "asm_io.inc"

segment .data
    matrix_1 dd 80000 DUP(0)    ; Declaration of matrix_1 with 68000 elements initialized to 0
    matrix_2 dd 80000 DUP(0)    ; Declaration of matrix_2 with 68000 elements initialized to 0
    _i dq 0                      ; Declaration of _i variable initialized to 0
    _j dq 0                      ; Declaration of _j variable initialized to 0
    _k dq 0                      ; Declaration of _k variable initialized to 0
    n dq 0                       ; Declaration of n variable initialized to 0
    n_squared dq 0               ; Declaration of n_squared variable initialized to 0
    result dd 80000 DUP(0)       ; Declaration of result array with 68000 elements initialized to 0

segment .text

global asm_main

asm_main:

    push rbp                    ; Save the value of rbp register on the stack
    push rbx                    ; Save the value of rbx register on the stack
    push r12                    ; Save the value of r12 register on the stack
    push r13                    ; Save the value of r13 register on the stack
    push r14                    ; Save the value of r14 register on the stack
    push r15                    ; Save the value of r15 register on the stack

    sub rsp, 8                  ; Allocate space on the stack

    call read_int               ; Call read_int to read an integer from input
    mov [n], eax                ; Move the value read into the n variable

    imul eax, eax               ; Multiply eax by itself
    mov [n_squared], eax        ; Move the result into the n_squared variable

    mov ebx, 0                  ; Initialize ebx to 0

    input_loop1:                ; Start of the loop to read input for matrix_1
        cmp ebx, [n_squared]    ; Compare ebx with n_squared
        jge input_loop1_end     ; Jump to input_loop1_end if ebx is greater than or equal to n_squared

        call read_float         ; Call read_float to read a floating-point number from input
        mov matrix_1[ebx*4], eax   ; Move the value read into the matrix_1 array
        mov edi, ebx            ; Move ebx into edi for printing purposes

        inc ebx                 ; Increment ebx
        jmp input_loop1         ; Jump back to input_loop1

    input_loop1_end:

    mov ebx, 0                  ; Initialize ebx to 0

    input_loop2:                ; Start of the loop to read input for matrix_2
        cmp ebx, [n_squared]    ; Compare ebx with n_squared
        jge input_loop2_end     ; Jump to input_loop2_end if ebx is greater than or equal to n_squared

        call read_float         ; Call read_float to read a floating-point number from input
        mov matrix_2[ebx*4], eax   ; Move the value read into the matrix_2 array
        mov edi, ebx            ; Move ebx into edi for printing purposes

        inc ebx                 ; Increment ebx
        jmp input_loop2         ; Jump back to input_loop2

    input_loop2_end:

    mov eax, 0                  ; Initialize eax to 0
    mov ebx, 0                  ; Initialize ebx to 0
    mov r12, [n]                ; Move the value of n into r12

    loop_i:                     ; Start of the loop for i
        mov qword [_j], 0       ; Set _j to 0
        loop_j:                 ; Start of the loop for j
            mov qword [_k], 0   ; Set _k to 0
            loop_k:             ; Start of the loop for k
                mov rcx, [n]    ; Move the value of n into rcx
                imul rcx, [_i]  ; Multiply rcx by _i
                add rcx, [_k]   ; Add _k to rcx
                mov eax, matrix_1[rcx*4]   ; Move the value at matrix_1[rcx*4] into eax

                mov rcx, [n]    ; Move the value of n into rcx
                imul rcx, [_k]  ; Multiply rcx by _k
                add rcx, [_j]   ; Add _j to rcx
                mov ebx, matrix_2[rcx*4]   ; Move the value at matrix_2[rcx*4] into ebx

                mov rcx, [n]    ; Move the value of n into rcx
                imul rcx, [_i]  ; Multiply rcx by _i
                add rcx, [_j]   ; Add _j to rcx
                movd xmm0, eax  ; Move the value in eax into xmm0
                movd xmm1, ebx  ; Move the value in ebx into xmm1
                mulss xmm0, xmm1    ; Multiply the values in xmm0 and xmm1, and store the result in xmm0
                movd eax, xmm0  ; Move the value in xmm0 into eax

                mov ebx, result[rcx*4]  ; Move the value at result[rcx*4] into ebx

                movd xmm0, eax  ; Move the value in eax into xmm0
                movd xmm1, ebx  ; Move the value in ebx into xmm1
                addss xmm0, xmm1    ; Add the values in xmm0 and xmm1, and store the result in xmm0
                movd eax, xmm0  ; Move the value in xmm0 into eax

                mov result[rcx*4], eax  ; Move the value in eax into result[rcx*4]

                inc qword [_k]  ; Increment _k
                cmp r12, [_k]   ; Compare r12 with _k
                jg loop_k       ; Jump to loop_k if r12 is greater than _k

            inc qword [_j]       ; Increment _j
            cmp r12, [_j]        ; Compare r12 with _j
            jg loop_j            ; Jump to loop_j if r12 is greater than _j

        inc qword [_i]            ; Increment _i
        cmp r12, [_i]             ; Compare r12 with _i
        jg loop_i                 ; Jump to loop_i if r12 is greater than _i

    mov ebx, 0                    ; Clear ebx
    xor ebx, ebx                  ; Clear ebx
    xor r12, r12                  ; Clear r12

    mov rdi, [n]                  ; Move the value of n into rdi
    call print_int                ; Call print_int to print the value of n
    call print_nl                 ; Call print_nl to print a new line

    print_result:
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
