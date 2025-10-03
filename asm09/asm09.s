section .data
    usage_msg db "Usage: ./asm09 [-b] <decimal_number>", 10
    usage_len equ $ - usage_msg
    newline db 10

section .bss
    buffer resb 64          ; Buffer pour la conversion
    num resb 8              ; Nombre à convertir

section .text
    global _start

_start:
    pop rdi                 ; argc
    cmp rdi, 2
    jl print_usage          ; Pas assez d'arguments
    cmp rdi, 3
    jg print_usage          ; Trop d'arguments

    pop rsi                 ; argv[0] (nom du programme)
    pop rsi                 ; argv[1] (premier argument)

    ; Vérifier si c'est l'option -b
    xor r15, r15            ; Flag: 0 = hex, 1 = binaire
    cmp byte [rsi], '-'
    jne parse_number
    cmp byte [rsi+1], 'b'
    jne print_usage
    cmp byte [rsi+2], 0
    jne print_usage
    
    ; C'est -b, on doit avoir un 3ème argument
    pop rsi                 ; argv[2]
    test rsi, rsi
    jz print_usage
    mov r15, 1              ; Mode binaire

parse_number:
    ; Convertir la chaîne ASCII en nombre
    xor rax, rax            ; Résultat
    xor rcx, rcx            ; Index
    
.loop:
    movzx rdx, byte [rsi + rcx]
    test rdx, rdx
    jz conversion_done      ; Fin de chaîne
    
    cmp dl, '0'
    jl print_usage          ; Pas un chiffre
    cmp dl, '9'
    jg print_usage          ; Pas un chiffre
    
    sub dl, '0'
    imul rax, 10
    add rax, rdx
    inc rcx
    jmp .loop

conversion_done:
    mov [num], rax          ; Sauvegarder le nombre
    
    ; Choisir le mode de conversion
    test r15, r15
    jnz convert_binary
    jmp convert_hex

convert_hex:
    mov rax, [num]
    lea rdi, [buffer + 63]  ; Partir de la fin du buffer
    mov byte [rdi], 0       ; Null terminator
    dec rdi
    
    xor rcx, rcx            ; Compteur de caractères
    
.loop:
    xor rdx, rdx
    mov rbx, 16
    div rbx                 ; rax = rax / 16, rdx = reste
    
    ; Convertir le reste en caractère hexa
    cmp dl, 9
    jle .is_digit
    add dl, 'A' - 10
    jmp .store
.is_digit:
    add dl, '0'
.store:
    mov [rdi], dl
    dec rdi
    inc rcx
    
    test rax, rax
    jnz .loop
    
    ; Afficher le résultat
    inc rdi
    mov rsi, rdi
    mov rdx, rcx
    jmp print_result

convert_binary:
    mov rax, [num]
    lea rdi, [buffer + 63]
    mov byte [rdi], 0
    dec rdi
    
    xor rcx, rcx
    
.loop:
    mov rdx, rax
    and rdx, 1              ; Obtenir le bit de poids faible
    add dl, '0'
    mov [rdi], dl
    dec rdi
    inc rcx
    
    shr rax, 1              ; Décaler vers la droite
    test rax, rax
    jnz .loop
    
    ; Afficher le résultat
    inc rdi
    mov rsi, rdi
    mov rdx, rcx

print_result:
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    syscall
    
    ; Afficher newline
    mov rax, 1
    mov rdi, 1
    lea rsi, [newline]
    mov rdx, 1
    syscall
    
    jmp exit_success

print_usage:
    mov rax, 1
    mov rdi, 1
    lea rsi, [usage_msg]
    mov rdx, usage_len
    syscall
    mov rdi, 1
    jmp exit

exit_success:
    xor rdi, rdi

exit:
    mov rax, 60             ; sys_exit
    syscall