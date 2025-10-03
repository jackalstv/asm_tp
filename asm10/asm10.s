section .bss
    result resb 20

section .text
    global _start

_start:
    ; Récupérer les pointeurs vers les arguments
    mov r12, [rsp+16]   ; pointeur vers argv[1]
    mov r13, [rsp+24]   ; pointeur vers argv[2]
    mov r14, [rsp+32]   ; pointeur vers argv[3]
    
    ; Convertir argv[1] en entier
    mov rsi, r12
    call atoi
    mov r8, rax         ; r8 = premier nombre
    
    ; Convertir argv[2] en entier
    mov rsi, r13
    call atoi
    mov r9, rax         ; r9 = deuxième nombre
    
    ; Convertir argv[3] en entier
    mov rsi, r14
    call atoi
    mov r10, rax        ; r10 = troisième nombre
    
    ; Trouver le maximum
    mov rax, r8         ; max = premier nombre
    
    cmp r9, rax
    jle check_r10
    mov rax, r9         ; max = r9
    
check_r10:
    cmp r10, rax
    jle convert_result
    mov rax, r10        ; max = r10
    
convert_result:
    ; Convertir le résultat en chaîne
    mov rdi, result
    mov rsi, rax
    call itoa
    mov rdx, rax        ; longueur de la chaîne
    
    ; Afficher le résultat
    mov rax, 1          ; sys_write
    mov rdi, 1          ; stdout
    mov rsi, result
    syscall
    
    ; Afficher newline
    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall
    
exit:
    mov rax, 60         ; sys_exit
    xor rdi, rdi
    syscall

; Fonction atoi : convertit une chaîne ASCII en entier
; Entrée : rsi = pointeur vers la chaîne
; Sortie : rax = nombre entier
atoi:
    xor rax, rax        ; résultat = 0
    xor rcx, rcx        ; signe = positif
    xor r11, r11        ; index
    
    ; Vérifier si le nombre est négatif
    cmp byte [rsi], '-'
    jne .parse_digits
    mov rcx, 1          ; signe négatif
    inc rsi             ; passer le '-'
    
.parse_digits:
    movzx rdx, byte [rsi]
    cmp rdx, 0          ; fin de chaîne ?
    je .done
    cmp rdx, '0'
    jb .done
    cmp rdx, '9'
    ja .done
    
    ; rax = rax * 10 + (chiffre - '0')
    imul rax, 10
    sub rdx, '0'
    add rax, rdx
    inc rsi
    jmp .parse_digits
    
.done:
    ; Appliquer le signe
    cmp rcx, 1
    jne .return
    neg rax
    
.return:
    ret

; Fonction itoa : convertit un entier en chaîne ASCII
; Entrée : rdi = buffer, rsi = nombre
; Sortie : rax = longueur de la chaîne
itoa:
    mov rax, rsi        ; nombre à convertir
    mov rcx, 10         ; diviseur
    xor r11, r11        ; compteur de chiffres
    mov r15, rdi        ; sauvegarder le pointeur du début
    
    ; Gérer le signe négatif
    test rax, rax
    jns .positive
    mov byte [rdi], '-'
    inc rdi
    inc r11
    neg rax
    
.positive:
    ; Cas spécial : 0
    test rax, rax
    jnz .convert_loop
    mov byte [rdi], '0'
    inc r11
    mov rax, r11
    ret
    
.convert_loop:
    ; Compter les chiffres et les stocker temporairement
    mov rbx, rdi        ; position de départ des chiffres
    
.push_digits:
    test rax, rax
    jz .reverse_digits
    xor rdx, rdx
    div rcx             ; rax = rax / 10, rdx = rax % 10
    add dl, '0'
    mov [rdi], dl
    inc rdi
    inc r11
    jmp .push_digits
    
.reverse_digits:
    ; Inverser les chiffres
    mov rsi, rbx        ; début
    lea rdi, [rdi-1]    ; fin
    
.reverse_loop:
    cmp rsi, rdi
    jge .done_itoa
    
    mov al, [rsi]
    mov ah, [rdi]
    mov [rdi], al
    mov [rsi], ah
    
    inc rsi
    dec rdi
    jmp .reverse_loop
    
.done_itoa:
    mov rax, r11        ; retourner la longueur
    ret

section .data
    newline db 0x0A