section .data
    newline db 10, 0                         ; Newline character
    buffer db 20 dup(0)                      ; Buffer for number output
    buffer_size db 0                         ; Size of the number in buffer
    upper_limit equ 200000000                  ; Limit to search for primes
    console_out dq -11                       ; Standard output handle (-11)

section .bss
    num resq 1                               ; Current number to test

section .text
    global main
    extern GetStdHandle, WriteFile, ExitProcess

main:
    ; Get the standard output handle
    mov rcx, console_out                     ; -11 for STD_OUTPUT_HANDLE
    call GetStdHandle                        ; Get console handle
    mov r12, rax                             ; Save handle for output

    mov rdi, 2                               ; Start testing from 2
    call find_primes

    ; Exit the program
    xor rcx, rcx                             ; Exit code 0
    call ExitProcess

find_primes:
    mov rax, rdi                             ; Test the current number in rdi
    mov [num], rax                           ; Save it to num
    call is_prime                            ; Check if it's a prime
    test rax, rax                            ; Check the result
    jz not_prime                             ; If not zero, skip to next

    ; Convert the prime number to string and output it
    mov rax, [num]                           ; Load the number
    call print_number                        ; Convert and print
    mov rcx, r12                             ; Handle to console
    lea rdx, [newline]                       ; Newline character
    mov r8, 1                                ; Length of newline
    lea r9, [buffer_size]                    ; Unused parameter
    call WriteFile                           ; Print newline

not_prime:
    inc rdi                                  ; Increment to the next number
    cmp rdi, upper_limit                     ; Check if reached the limit
    jl find_primes                           ; Continue if below the limit
    ret

is_prime:
    mov rax, [num]                           ; Load the number to test
    cmp rax, 2                               ; Special case for 2
    je is_prime_yes                          ; 2 is a prime
    mov rcx, 2                               ; Start testing divisors from 2

prime_loop:
    mov rdx, 0                               ; Clear rdx for division
    div rcx                                  ; Divide rax by rcx
    test rdx, rdx                            ; Check if remainder is 0
    jz is_prime_no                           ; Not prime if divisible

    inc rcx                                  ; Increment divisor
    mov rdx, 0                               ; Clear rdx
    mov rax, [num]                           ; Reload the number
    cmp rcx, rax                             ; Check if divisor reaches number
    jl prime_loop                            ; Continue testing divisors

is_prime_yes:
    mov rax, [num]                           ; Return the prime number
    ret

is_prime_no:
    xor rax, rax                             ; Return 0 (not prime)
    ret

print_number:
    mov rcx, buffer + 19                     ; Start from the end of buffer
    xor rdx, rdx                             ; Clear rdx for division
    mov rbx, 10                              ; Divisor for base 10
    mov rdi, 0                               ; Count of digits

convert_to_digits:
    div rbx                                  ; Divide rax by 10
    add dl, '0'                              ; Convert remainder to ASCII
    dec rcx                                  ; Move pointer backward
    mov [rcx], dl                            ; Store digit
    inc rdi                                  ; Increment digit count
    test rax, rax                            ; Check if quotient is zero
    jnz convert_to_digits                    ; Continue if not zero

    ; Calculate the start of the number in the buffer
    mov rax, buffer + 19                     ; End of buffer
    sub rax, rdi                             ; Start of the number
    lea rsi, [rax]                           ; Load address of digits

    ; Write digits to console
    mov rcx, r12                             ; Handle to console
    mov rdx, rsi                             ; Pointer to buffer
    mov r8, rdi                              ; Number of bytes
    lea r9, [buffer_size]                    ; Unused parameter
    call WriteFile
    ret
