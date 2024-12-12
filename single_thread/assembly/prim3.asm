; Prime Number Finder (x64) using Division Method
; Compile with: nasm -f win64 prime_finder.asm
; Link with: link /subsystem:console /ENTRY:Start prime_finder.obj kernel32.lib

global Start
extern ExitProcess
extern GetStdHandle
extern WriteConsoleA

section .data
    max_num dq 100        ; Maximum number to check for primes
    space db ' ', 0

section .bss
    buffer resb 20        ; Buffer for number conversion

section .text
Start:
    int 3
    int 3
    int 3

    ; Print primes from 2 to max_num
    mov rcx, 2
.prime_loop:
    cmp rcx, [max_num]
    ja .exit

    ; Check if current number is prime
    call is_prime
    test rax, rax
    jz .continue

    ; Convert and print prime
    mov rdi, buffer
    mov rax, rcx
    call int_to_str

    ; Get console handle
    sub rsp, 32
    mov rcx, -11     ; STD_OUTPUT_HANDLE
    call GetStdHandle

    ; Write number to console
    mov rcx, rax     ; Console handle
    mov rdx, buffer  ; Buffer
    mov r8, rdi      ; Length
    mov r9, 0        ; Chars written (optional)
    call WriteConsoleA

    ; Print space
    mov rcx, rax
    mov rdx, space
    mov r8, 1
    mov r9, 0
    call WriteConsoleA
    add rsp, 32

.continue:
    inc rcx
    jmp .prime_loop

.exit:
    xor rcx, rcx
    call ExitProcess

; Check if number in RCX is prime
; Returns 1 in RAX if prime, 0 if not
is_prime:
    cmp rcx, 1
    jle .not_prime   ; Numbers <= 1 are not prime
    
    mov rax, rcx
    mov rdx, 2
.check_divisor:
    mul rdx          ; Multiply current divisor
    cmp rax, rcx     ; Stop if divisor > number
    ja .is_prime

    mov rax, rcx     ; Restore original number
    xor rdx, rdx
    div rbx          ; Divide number by current divisor
    test rdx, rdx    ; Check remainder
    jz .not_prime    ; If remainder is 0, not prime

    inc rbx
    mov rax, rbx
    mul rax
    cmp rax, rcx
    jle .check_divisor

.is_prime:
    mov rax, 1
    ret

.not_prime:
    xor rax, rax
    ret

; Convert integer to string
; Input: RAX = number to convert, RDI = buffer
; Output: RDI = length of string
int_to_str:
    push rdi
    mov rcx, 10
    xor rdx, rdx
    mov rsi, rdi

.convert_loop:
    div rcx
    add dl, '0'
    mov [rdi], dl
    inc rdi
    xor rdx, rdx
    test rax, rax
    jnz .convert_loop

    ; Reverse the string
    mov rcx, rdi
    sub rcx, rsi
    shr rcx, 1
    jz .done
    mov rdi, rsi

.reverse_loop:
    mov al, [rsi]
    mov ah, [rdi-1]
    mov [rsi], ah
    mov [rdi-1], al
    inc rsi
    dec rdi
    loop .reverse_loop

.done:
    pop rdi
    mov rax, rdi
    sub rax, rsi
    ret