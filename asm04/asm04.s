section .bss
    buffer resb 8

section .text
    global _start

_start:
    mov rax,0
    mov rdi,0
    mov rsi, buffer
    mov rdx, 8
    syscall

    
    mov al, byte[buffer]
    cmp al, '4'
    jne skip0
    mov al, byte[buffer+2]
    cmp al, 0x0A
    je passkip0
passkip0:

    mov rax, 60
    mov rdi, 0
    syscall

skip0:  
    mov rax, 60
    mov rdi, 1
    syscall      
