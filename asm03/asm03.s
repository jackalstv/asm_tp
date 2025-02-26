section .bss
    buffer resb 8

section .data
    message db "1337", 0xA  ; Le message avec un saut de ligne
    msg_len equ $ - message           ; Calcul de la longueur du message

section .text
    global _start

_start:

    mov rax, 1
    mov rdi, 1
    mov rsi, message
    mov rdx, msg_len
    syscall

    mov rdi, [rsp]
    cmp rdi, 2
    jl goto0

    mov rsi, [rsp+16]
    

    mov al, byte[rsi]
    cmp al, '4'
    jne skip0
    mov al, byte[rsi+1]
    cmp al, '2'
    jne skip0
    mov al, byte[rsi+2]
    cmp al, ''
    jne skip0
goto0:
    mov rdi,0 

skip0:  
    mov rax, 60    
    syscall      
