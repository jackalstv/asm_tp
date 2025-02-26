section .text
    global _start
_start:

    mov rsi , [rsp+16]
    mov rcx, 1

loop_start:

    inc rcx
    mov al, byte[rsi+rcx-1]
    cmp al,0
    jne loop_start
    add byte[rsi+rcx-1], 0x08
    mov al, byte[rsi+rcx]
    cmp al,'S'
    jne loop_start

    mov rax, 1
    mov rdi, 1
    mov rdx, rcx
    syscall

    mov rax, 1           
    mov rdi, 1           
    mov rsi, 0xA 
    mov rdx, 1           
    syscall

    mov rdi, 0   
    mov rax, 60    
    syscall      
