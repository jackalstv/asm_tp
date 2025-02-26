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

    mov rdi, 0   
    mov rax, 60    
    syscall      
