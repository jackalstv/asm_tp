section .bss
    buffer resb 8

section .data
    message db "1337", 0xA  ; Le message avec un saut de ligne
    msg_len equ $ - message           ; Calcul de la longueur du message

section .text
    global _start

_start:
    mov rax,0
    mov rdi,0
    mov rsi, buffer
    mov rdx, 8
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, message
    mov rdx, msg_len
    syscall

    mov al, byte[buffer]
    cmp al,'0'
    jl isnotnumber
    cmp al, '9'
    jg isnotnumber
    
    mov al, byte[buffer]
    test al,1
    jne skip0
goto0:
    mov rdi,0 
isnotnumber:
    mov rdi, 2

skip0:  
    mov rax, 60    
    syscall      
