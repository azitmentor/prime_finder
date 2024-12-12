.DATA
    max_num QWORD 100
    space BYTE ' ', 0

.CODE
EXTERN GetStdHandle:PROC
EXTERN WriteConsoleA:PROC
EXTERN ExitProcess:PROC

; RCX = number to check
IsPrime PROC
    ; Handle numbers <= 1
    cmp rcx, 1
    jle ReturnFalse

    ; Check divisibility
    mov rax, 2
CheckDivisor:
    mov rdx, 0
    div rcx
    test rdx, rdx
    jz ReturnFalse

    inc rax
    mul rax
    cmp rax, rcx
    jle CheckDivisor

    mov rax, 1
    ret

ReturnFalse:
    xor rax, rax
    ret
IsPrime ENDP

; RCX = number to convert, RDI = buffer
IntToStr PROC
    push rdi
    mov rax, rcx
    mov rcx, 10
    xor rdx, rdx
    mov rsi, rdi

ConvertLoop:
    div rcx
    add dl, '0'
    mov [rdi], dl
    inc rdi
    xor rdx, rdx
    test rax, rax
    jnz ConvertLoop

    ; Reverse string
    mov rcx, rdi
    sub rcx, rsi
    shr rcx, 1
    jz Done
    mov rdi, rsi

ReverseLoop:
    mov al, [rsi]
    mov ah, [rdi-1]
    mov [rsi], ah
    mov [rdi-1], al
    inc rsi
    dec rdi
    loop ReverseLoop

Done:
    pop rdi
    mov rax, rdi
    sub rax, rsi
    ret
IntToStr ENDP

main PROC
    ; Prime finding loop
    mov r12, 2
PrimeLoop:
    cmp r12, max_num
    ja Exit

    mov rcx, r12
    call IsPrime
    test rax, rax
    jz Continue

    ; Convert and print prime
    lea rdi, [rsp-20h]
    mov rcx, r12
    call IntToStr

    ; Print number
    mov rcx, -11     ; STD_OUTPUT_HANDLE
    call GetStdHandle
    mov rcx, rax
    mov rdx, rdi
    mov r8, rax
    xor r9, r9
    call WriteConsoleA

    ; Print space
    mov rcx, -11     ; STD_OUTPUT_HANDLE
    call GetStdHandle
    mov rcx, rax
    lea rdx, space
    mov r8, 1
    xor r9, r9
    call WriteConsoleA

Continue:
    inc r12
    jmp PrimeLoop

Exit:
    xor rcx, rcx
    call ExitProcess
main ENDP

END