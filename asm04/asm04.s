section .bss
    buffer resb 8

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 2
    syscall
    
    mov al, [buffer]
    sub al, '0'         ; Conversion ASCII -> nombre
    
    ; Vérifier si c'est un chiffre valide (0-9)
    cmp al, 9
    ja Retour2          ; Si > 9, c'est un caractère invalide -> retourne 2
    
    ; Vérifier si pair ou impair
    test al, 1          ; Teste le bit de poids faible
    jnz Retour1         ; Si bit=1 -> impair -> retourne 1
    
    ; Sinon c'est pair -> retourne 0
    jmp Retour0

Retour0:
    mov rax, 60
    mov rdi, 0          ; pair -> 0
    syscall

Retour1:
    mov rax, 60
    mov rdi, 1          ; impair -> 1
    syscall

Retour2:
    mov rax, 60
    mov rdi, 2          ; caractère non-chiffre -> 2
    syscall