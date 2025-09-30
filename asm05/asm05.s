section .data
    newline db 10            ; caractère '\n'

section .text
    global _start
_start:
    ; Récupère argc (= nb d'arguments) dans rdi, argv dans rsi
    mov rdi, [rsp]           ; argc
    cmp rdi, 2               ; doit être au moins 2 (nom + argument)
    jl erreur

    mov rsi, [rsp+16]        ; argv[1] (adresse du 1er argument utilisateur)
    xor rcx, rcx             ; compteur à 0

count_length:
    mov al, [rsi+rcx]
    cmp al, 0
    je done_count
    inc rcx
    jmp count_length
    
done_count:
    ; Affiche l'argument utilisateur (argv[1])
    mov rax, 1               ; syscall write
    mov rdi, 1               ; fd = stdout
    mov rdx, rcx             ; longueur
    syscall

    ; Ajoute le saut de ligne ('\n')
    mov rax, 1               ; syscall write
    mov rdi, 1               ; fd = stdout
    lea rsi, [rel newline]   ; adresse du caractère '\n'
    mov rdx, 1               ; longueur = 1
    syscall

    ; Quitte proprement
    mov rax, 60              ; syscall exit
    xor rdi, rdi             ; code de retour 0
    syscall

erreur:
    mov rax, 60              ; syscall exit
    mov rdi, 1               ; code erreur 1
    syscall
