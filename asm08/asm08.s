section .bss
    message resb 20

section .text
    global _start

_start:
    mov rdi, [rsp]          ; argc
    cmp rdi, 2              ; Vérifier qu'il y a 1 argument
    jne fin_erreur

    mov rsi, [rsp+16]       ; argv[1]
    
    ; Convertir argv[1] en entier
    call atoi
    mov r12, rax            ; Sauvegarder N dans r12
    
    ; Calculer la somme de 1 à N-1
    xor r14, r14            ; Somme = 0
    
    ; Si N <= 1, la somme est 0
    cmp r12, 1
    jle .print_result
    
    mov r13, 1              ; i = 1
    
.sum_loop:
    add r14, r13            ; somme += i
    inc r13                 ; i++
    cmp r13, r12            ; i < N ?
    jl .sum_loop

.print_result:
    
    ; Afficher le résultat
    mov rdi, r14
    call print_number
    
    ; Sortie propre
    mov rax, 60
    xor rdi, rdi
    syscall

; Fonction atoi: convertir chaîne ASCII -> entier signé
; Entrée: rsi = pointeur sur la chaîne
; Sortie: rax = nombre
atoi:
    xor rax, rax
    xor rcx, rcx
    movzx r8, byte [rsi]
    
    cmp r8, '-'
    jne .loop
    mov rcx, 1
    inc rsi
    
.loop:
    movzx r8, byte [rsi]
    cmp r8, 0
    je .done
    cmp r8, 10
    je .done
    cmp r8, '0'
    jb .done
    cmp r8, '9'
    ja .done
    
    imul rax, rax, 10
    sub r8, '0'
    add rax, r8
    inc rsi
    jmp .loop
    
.done:
    test rcx, rcx
    jz .positive
    neg rax
.positive:
    ret

; Fonction print_number: afficher un entier signé avec newline
; Entrée: rdi = nombre à afficher
print_number:
    mov rax, rdi
    mov rsi, message
    add rsi, 19
    mov byte [rsi], 10      ; Saut de ligne
    dec rsi
    
    xor rcx, rcx
    test rax, rax
    jns .convert
    neg rax
    mov rcx, 1
    
.convert:
    mov rbx, 10
.loop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    mov [rsi], dl
    dec rsi
    test rax, rax
    jnz .loop
    
    test rcx, rcx
    jz .print
    mov byte [rsi], '-'
    dec rsi
    
.print:
    inc rsi
    mov rdx, message
    add rdx, 20
    sub rdx, rsi
    mov rax, 1
    push rdi
    mov rdi, 1
    syscall
    pop rdi
    ret

fin_erreur:
    mov rax, 60
    mov rdi, 1
    syscall