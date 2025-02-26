section .text
    global _start
_start:

    mov rdi, [rsp]
    cmp rdi, 2
    jl erreur
    mov rsi , [rsp+16]
    xor rcx, rcx


loop_start:
    inc rcx
    mov al, byte[rsi+rcx-1]
    cmp al,0
    jne loop_start
    mov al, byte[rsi+rcx]
    cmp al, 'S'
    jne loop_start


endloop:
    mov rax, 1
    mov rdi, 1
    mov rdx, rcx
    syscall
erreur:
    mov rdi, 0   
    mov rax, 60    
    syscall      
