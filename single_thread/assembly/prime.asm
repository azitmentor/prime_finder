extern ExitProcess : proc
extern printf : proc
extern GetTickCount64 : proc    ; Windows API for timing

.data
    limit dq 20000000
    count dq 0
    startTime dq 0
    endTime dq 0
    fmt db "Found %lld primes in %lld milliseconds", 0Ah, 0

.code
main proc
    sub rsp, 40h
    
    call GetTickCount64      ; Get start time
    mov [startTime], rax
    
    mov qword ptr [count], 1
    mov rbx, 3
    
check_next:
    cmp rbx, [limit]
    ja print_result
    
    mov rcx, 3
    mov rax, rbx
    
    cvtsi2sd xmm0, rax
    sqrtsd xmm0, xmm0
    cvttsd2si r10, xmm0
    
check_prime:
    cmp rcx, r10
    ja is_prime
    
    xor rdx, rdx
    div rcx
    cmp rdx, 0
    je not_prime
    
    mov rax, rbx
    add rcx, 2
    jmp check_prime
    
is_prime:
    inc qword ptr [count]
    
not_prime:
    add rbx, 2
    jmp check_next
    
print_result:
    call GetTickCount64      ; Get end time
    mov [endTime], rax
    
    lea rcx, fmt
    mov rdx, [count]
    mov r8, [endTime]
    sub r8, [startTime]      ; Calculate elapsed time
    call printf
    
    xor rcx, rcx
    call ExitProcess
main endp
end