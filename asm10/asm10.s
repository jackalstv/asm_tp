section .bss
    result resb 2

section .text
    global _start

_start:
    ; Récupérer les pointeurs vers les arguments
    mov r8, [rsp+16]   ; pointeur vers argv[1]
    mov r9, [rsp+24]   ; pointeur vers argv[2]
    mov r10, [rsp+32]  ; pointeur vers argv[3]
    
    ; Charger les valeurs (premier caractère de chaque chaîne)
    movzx r8, byte [r8]   ; déréférencer le pointeur
    movzx r9, byte [r9]
    movzx r10, byte [r10]
    
    ; Convertir ASCII -> nombre
    sub r8, '0'
    sub r9, '0'
    sub r10, '0'
    
    ; Trouver le maximum
    mov rax, r8           ; max = premier nombre
    
    cmp r9, rax
    jle check_r10         ; si r9 <= max, vérifier r10
    mov rax, r9           ; sinon max = r9
    
check_r10:
    cmp r10, rax
    jle print_result      ; si r10 <= max, on a fini
    mov rax, r10          ; sinon max = r10
    
print_result:
    ; Convertir nombre -> ASCII et stocker en mémoire
    add rax, '0'
    mov [result], al
    mov byte [result+1], 0x0A  ; newline
    
    ; Afficher le résultat
    mov rax, 1            ; sys_write
    mov rdi, 1            ; stdout
    mov rsi, result       ; adresse du buffer
    mov rdx, 2            ; longueur (chiffre + newline)
    syscall
    
exit:
    mov rax, 60           ; sys_exit
    xor rdi, rdi          ; code 0
    syscall