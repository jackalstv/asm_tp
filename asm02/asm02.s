section .bss
    buffer resb 8        ; Tampon pour lire l'entrée standard (8 caractères max)

section .data
    message db "1337", 0xA     ; Message à afficher + saut de ligne
    msg_len equ $ - message    ; Calcul automatique de la longueur

section .text
    global _start

_start:
    ; Lecture standard input (read)
    mov rax, 0            ; SYSCALL: read
    mov rdi, 0            ; fd = 0 (stdin)
    mov rsi, buffer       ; buffer où stocker
    mov rdx, 8            ; nombre max de caractères à lire
    syscall

    ; Vérification "42" + fin de chaîne après 2 caractères
    mov al, byte [buffer]
    cmp al, '4'
    jne fin_erreur

    mov al, byte [buffer + 1]
    cmp al, '2'
    jne fin_erreur

    mov al, byte [buffer + 2]
    cmp al, 0xA        ; on vérifie que l'utilisateur a appuyé sur ENTREE (\n)
    jne fin_erreur

    ; C'est exactement "42" (avant retour à la ligne) : on affiche "1337"
    mov rax, 1         ; SYSCALL: write
    mov rdi, 1         ; fd = 1 (stdout)
    mov rsi, message   ; adresse du message
    mov rdx, msg_len   ; longueur à écrire
    syscall

    ; Sortie du programme
    mov rax, 60        ; SYSCALL: exit
    xor rdi, rdi       ; code retour 0 (succès)
    syscall

fin_erreur:
    mov rax, 60
    mov rdi, 1         ; code retour 1 (échec)
    syscall
