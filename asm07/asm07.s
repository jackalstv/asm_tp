section .bss
    buffer resb 8

section .text
    global _start

_start:
    ; Lecture de 2 caractères depuis stdin
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 2
    syscall

    ; Chargement du premier caractère
    movzx rax, byte [buffer]      ; Premier chiffre
    
    ; Conversion ASCII -> nombre
    sub rax, '0'
    
    ; Validation du premier chiffre (0-9)
    cmp rax, 0
    jl exitError
    cmp rax, 9
    jg exitError
    
    ; Chargement du deuxième caractère
    movzx r8, byte [buffer+1]
    
    ; Vérifier si c'est un retour à la ligne (entrée à 1 chiffre)
    cmp r8, 10                    ; 10 = '\n' en ASCII
    je un_seul_chiffre
    
    ; Conversion ASCII -> nombre
    sub r8, '0'
    
    ; Validation du deuxième chiffre (0-9)
    cmp r8, 0
    jl exitError
    cmp r8, 9
    jg exitError
    
    ; Construction du nombre : n = premier_chiffre * 10 + deuxième_chiffre
    imul rax, 10
    add rax, r8
    jmp continuer_test

un_seul_chiffre:
    ; rax contient déjà le chiffre (0-9)
    ; Pas besoin de calcul supplémentaire

continuer_test:
    mov r10, rax              ; r10 = nombre à tester
    
    ; Cas spéciaux
    cmp r10, 2
    jl Pasnbpremier           ; 0 et 1 ne sont pas premiers
    je fin_nmpremier          ; 2 est premier
    
    ; Test de divisibilité
    mov r8, 2                 ; Diviseur initial

loop_nmpremier:
    mov rax, r10
    xor rdx, rdx              ; Mettre rdx à 0 avant division
    div r8                    ; rax = quotient, rdx = reste
    
    cmp rdx, 0                ; Si reste == 0, le nombre n'est pas premier
    je Pasnbpremier
    
    inc r8                    ; Diviseur suivant
    mov rax, r8
    imul rax, rax             ; rax = r8²
    cmp rax, r10              ; Si r8² > n, n est premier
    jg fin_nmpremier
    
    jmp loop_nmpremier

Pasnbpremier:
    mov rax, 60
    mov rdi, 1                ; Pas premier -> code 1
    syscall

exitError:
    mov rax, 60
    mov rdi, 2                ; Erreur -> code 2
    syscall

fin_nmpremier:
    mov rax, 60
    mov rdi, 0                ; Premier -> code 0
    syscall