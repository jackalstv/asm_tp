section .bss
    buffer resb 8

section .text
    global _start

_start:
    ; Lecture depuis stdin (2 caractères max: chiffre + newline)
    mov rax, 0              ; syscall: read
    mov rdi, 0              ; stdin
    mov rsi, buffer         ; destination
    mov rdx, 8              ; nombre d'octets
    syscall

    ; Conversion ASCII -> nombre
    movzx rax, byte [buffer]
    cmp al, '0'
    jl exit_error
    cmp al, '9'
    jg check_two_digits     ; Peut-être un nombre à 2 chiffres
    
    sub al, '0'             ; Conversion simple (0-9)
    jmp test_prime

check_two_digits:
    ; Vérifier si c'est un nombre à 2 chiffres
    movzx rax, byte [buffer]
    sub al, '0'
    movzx rbx, byte [buffer+1]
    cmp bl, 10              ; newline?
    je test_prime           ; Non, c'était un seul chiffre
    sub bl, '0'
    imul ax, 10
    add al, bl
    
test_prime:
    ; RAX contient maintenant le nombre à tester
    mov r8, rax             ; Sauvegarder le nombre original dans r8
    
    ; Cas spéciaux: 0, 1 ne sont pas premiers
    cmp r8, 2
    jl not_prime
    
    ; 2 est premier
    cmp r8, 2
    je is_prime

    cmp r8,1
    je not_prime
    
    ; Les nombres pairs ne sont pas premiers
    test r8b, 1
    jz not_prime
    
    ; Tester les diviseurs de 3 à sqrt(n)
    mov rbx, 3              ; Diviseur courant
    
loop_divisors:
    ; Si diviseur² > nombre, c'est premier
    mov rax, rbx
    mul rbx                 ; RAX = RBX²
    cmp rax, r8
    jg is_prime
    
    ; Test de divisibilité: nombre % diviseur == 0 ?
    mov rax, r8             ; Nombre à tester
    xor rdx, rdx            ; Clear RDX pour la division
    div rbx                 ; RAX = quotient, RDX = reste
    
    cmp rdx, 0              ; Reste == 0 ?
    je not_prime            ; Oui -> pas premier
    cmp rax,1
    je not_prime 
    
    ; Passer au diviseur suivant (seulement impairs)
    add rbx, 2
    jmp loop_divisors

is_prime:
    ; Code de sortie 0 = premier
    mov rax, 60             ; syscall: exit
    mov rdi, 0              ; code de sortie: 0 (premier)
    syscall

not_prime:
    ; Code de sortie 1 = pas premier
    mov rax, 60             ; syscall: exit
    mov rdi, 1              ; code de sortie: 1 (pas premier)
    syscall

exit_error:
    ; Code de sortie 2 = erreur d'entrée
    mov rax, 60
    mov rdi, 2
    syscall