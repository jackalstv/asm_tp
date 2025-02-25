section .text
    global _start

_start:
    mov rdi, 0    ; Code de retour (42)
    mov rax, 60    ; Syscall exit (60 en x86-64)
    syscall        ; Appel du noyau
