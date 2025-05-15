%include "asm_io.inc"

segment .data
    ARRAY_LENGTH db 100                   ; Define array length
    ARRAY_SIZE dq 100                     ; Define array size
    matrix dd 200000 DUP(0)               ; Define matrix with 150000 elements initialized to 0
    kernel dd 200000 DUP(0)               ; Define kernel with 150000 elements initialized to 0
    _i dq 0                                ; Define variable _i initialized to 0
    _j dq 0                                ; Define variable _j initialized to 0
    _k dq 0                                ; Define variable _k initialized to 0
    _l dq 0                                ; Define variable _l initialized to 0
    n dq 0                                 ; Define variable n initialized to 0
    m dq 0                                 ; Define variable m initialized to 0
    n_squared dq 0                         ; Define variable n_squared initialized to 0
    m_squared dq 0                         ; Define variable m_squared initialized to 0
    k_row dq 0                             ; Define variable k_row initialized to 0
    k_col dq 0                             ; Define variable k_col initialized to 0
    mat_row dq 0                           ; Define variable mat_row initialized to 0
    mat_col dq 0                           ; Define variable mat_col initialized to 0
    center dq 0                            ; Define variable center initialized to 0
    result dd 200000 DUP(0)                ; Define result array with 150000 elements initialized to 0 

segment .text

global asm_main

asm_main:

    push rbp                              ; Preserve rbp register
    push rbx                              ; Preserve rbx register
    push r12                              ; Preserve r12 register
    push r13                              ; Preserve r13 register
    push r14                              ; Preserve r14 register
    push r15                              ; Preserve r15 register

    sub rsp, 8                            ; Adjust stack pointer

    call read_int                         ; Call read_int to read n
    mov [n], eax                          ; Save n as input                                       

    imul eax, eax                         ; Calculate n^2
    mov [n_squared], eax                 ; Save n^2 in n_squared

    mov ebx, 0                            ; Initialize loop counter ebx

    input_loop1:                          ; Loop to get input for matrix
        cmp ebx, [n_squared]              ; Compare ebx with n_squared
        jge input_loop1_end               ; If ebx >= n_squared, exit loop

        call read_float                    ; Call read_float to read matrix element
        mov matrix[ebx*4], eax            ; Save input number in matrix[ebx]

        inc ebx                           ; Increment ebx
        jmp input_loop1                   ; Continue loop

    input_loop1_end:

    call read_int                         ; Call read_int to read m
    mov [m], eax                          ; Save m as input                                       

    imul eax, eax                         ; Calculate m^2
    mov [m_squared], eax                 ; Save m^2 in m_squared

    mov ebx, 0                            ; Initialize loop counter ebx

    input_loop2:                          ; Loop to get input for kernel
        cmp ebx, [m_squared]              ; Compare ebx with m_squared
        jge input_loop2_end               ; If ebx >= m_squared, exit loop

        call read_float                    ; Call read_float to read kernel element
        mov kernel[ebx*4], eax            ; Save input number in kernel[ebx]

        inc ebx                           ; Increment ebx
        jmp input_loop2                   ; Continue loop

    input_loop2_end:

    mov r12, [n]                          ; Save n in r12 for comparing
    mov r13, [m]                          ; Save m in r13 for comparing

    mov eax, [m]                          ; Calculate center of kernel
    shr eax, 1
    mov [center], eax                     ; Find center of kernel by dividing m by 2

    loop_i:                               ; Loop for i
        mov qword [_j], 0   
        loop_j:                           ; Loop for j
            mov qword [_k], 0
            loop_k:                       ; Loop for k
                mov qword [_l], 0

                mov rcx, [m]                     ; Set rcx to m
                dec rcx                          ; Decrement rcx
                sub rcx, [_k]                   ; Subtract k from rcx
                mov [k_row], rcx                ; Save result in k_row

                loop_l:

                    mov rcx, [m]                     ; Set rcx to m
                    dec rcx                          ; Decrement rcx
                    sub rcx, [_l]                   ; Subtract l from rcx
                    mov [k_col], rcx                ; Save result in k_col

                    mov rcx, [_i]                   ; Calculate mat_row = i + (center - k_row)
                    add rcx, [center]
                    sub rcx, [k_row]
                    mov [mat_row], rcx

                    mov rcx, [_j]                   ; Calculate mat_col = j + (Center - k_col)
                    add rcx, [center]
                    sub rcx, [k_col]
                    mov [mat_col], rcx

                    mov r14, [mat_row]              ; Compare mat_row with boundaries
                    cmp r14, 0
                    jl continue                     ; If mat_row < 0, continue

                    cmp r14, [n]
                    jge continue                     ; If mat_row >= n, continue

                    mov r14, [mat_col]              ; Compare mat_col with boundaries
                    cmp r14, 0
                    jl continue                     ; If mat_col < 0, continue

                    cmp r14, [n]
                    jge continue                     ; If mat_col >= n, continue

                    mov rcx, [n]                    ; Calculate index in matrix
                    imul rcx, [mat_row] 
                    add rcx, [mat_col]
                    mov eax, matrix[rcx*4]          ; Load first element

                    mov rcx, [m]                    ; Calculate index in kernel
                    imul rcx, [k_row] 
                    add rcx, [k_col]
                    mov ebx, kernel[rcx*4]          ; Load second element

                    mov rcx, [n]                    ; Calculate index in result
                    imul rcx, [_i]
                    add rcx, [_j]
                    movd xmm0, eax
                    movd xmm1, ebx
                    mulss xmm0, xmm1                ; Calculate product of two elements
                    movd eax, xmm0

                    mov ebx, result[rcx*4]          ; Load result element

                    movd xmm0, eax
                    movd xmm1, ebx
                    addss xmm0, xmm1
                    movd eax, xmm0                  ; Add multiplication of first and second element

                    mov result[rcx*4], eax          ; Save result in result array

                continue:

                inc qword [_l]                     ; Increment l
                cmp r13, [_l]
                jg loop_l                          ; Continue loop

            inc qword [_k]                         ; Increment k
            cmp r13, [_k]
            jg loop_k                             ; Continue loop

        inc qword [_j]                             ; Increment j
        cmp r12, [_j]
        jg loop_j                                 ; Continue loop

    inc qword [_i]                                 ; Increment i
    cmp r12, [_i]
    jg loop_i                                      ; Continue loop

    xor ebx, ebx                                   ; Clear ebx
    xor r12, r12                                   ; Clear r12

    mov rdi, [n]                                   ; Prepare to print n
    call print_int                                 ; Print n
    call print_nl                                 ; Print newline

    print_result:
        cmp ebx, [n_squared]                      ; Check if we reached end of print
        jge print_result_end                      ; If so, exit

        mov edi, result[ebx*4]                    ; Load i'th number in result
        call print_float                          ; Print float
        mov edi, ebx                              ; Prepare for next iteration

        inc ebx                                   ; Increment ebx
        inc r12                                   ; Increment r12

        mov edi, 32                               ; Prepare to print space
        call print_char                           ; Print space

        cmp r12, [n]                              ; Check if we reached n print of row to print new line 
        je print_new_line_result

        jmp print_result

    print_new_line_result:                        ; Print new line in result print
        call print_nl
        xor r12, r12
        jmp print_result

    print_result_end:
        call print_nl
    add rsp, 8

    pop r15                                       ; Restore r15 register
    pop r14                                       ; Restore r14 register
    pop r13                                       ; Restore r13 register
    pop r12                                       ; Restore r12 register
    pop rbx                                       ; Restore rbx register
    pop rbp                                       ; Restore rbp register

    ret                                           ; Return
