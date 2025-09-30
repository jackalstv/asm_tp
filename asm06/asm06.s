section .bss
    message resb 20     ; Pour gérer des résultats plus grands

section .text
    global _start

_start:
    mov rdi, [rsp]      ; argc
    cmp rdi, 3
    jne fin_erreur
    
    mov rsi, [rsp+16]   ; argv[1]
    mov rdi, [rsp+24]   ; argv[2]
    
    ; Convertir argv[1] (peut être multi-chiffres ou négatif)
    call atoi
    mov rbx, rax        ; Sauvegarder premier nombre dans rbx
    
    ; Convertir argv[2]
    mov rsi, rdi
    call atoi
    
    ; Addition
    add rax, rbx
    
    ; Convertir le résultat en chaîne et afficher
    mov rdi, rax
    call print_number
    
    ; Sortie propre
    mov rax, 60
    xor rdi, rdi
    syscall

; Fonction atoi: convertir chaîne ASCII -> entier signé
; Entrée: rsi = pointeur sur la chaîne
; Sortie: rax = nombre
atoi:
    xor rax, rax        ; résultat = 0
    xor rcx, rcx        ; signe = positif
    movzx r8, byte [rsi] ; charger premier caractère
    
    ; Vérifier si premier caractère est '-'
    cmp r8, '-'
    jne .loop ; si pas '-', continuer la conversion
    mov rcx, 1          ; signe = négatif
    inc rsi             ; Passer le '-'
    
.loop: ; le label .loop est utilisé pour boucler sur chaque caractère de la chaîne afin de construire le nombre entier
    movzx r8, byte [rsi] ; movzx permet de charger un octet dans un registre plus grand donc ici il met à 0 les bits de poids fort donc r8 contient le caractère courant 
    cmp r8, 0           ; Fin de chaîne?
    je .done ; si fin de chaîne, terminer
    cmp r8, 10          ; Vérifier saut de ligne
    je .done ; si saut de ligne, terminer
    cmp r8, '0'
    jb .done ; si < '0', terminer
    cmp r8, '9' 
    ja .done ; si > '9', terminer
    
    ; rax = rax * 10 + (r8 - '0')
    imul rax, rax, 10 ; imul effectue une multiplication de rax par 10 et stocke le résultat dans rax
    sub r8, '0'
    add rax, r8
    inc rsi
    jmp .loop
    
.done:
    test rcx, rcx       ; Si négatif
    jz .positive ; si pas négatif, sauter
    neg rax             ; Inverser le signe
.positive:
    ret ; ret permet de retourner de la fonction en utilisant l'adresse de retour stockée sur la pile qui est ici l'instruction suivante après l'appel de la fonction

; Fonction print_number: afficher un entier signé
; Entrée: rdi = nombre à afficher
print_number:
    mov rax, rdi
    mov rsi, message
    add rsi, 19         ; 19ème position pour le saut de ligne
    mov byte [rsi], 10  ; Saut de ligne
    dec rsi
    
    ; Gérer le signe
    xor rcx, rcx        ; flag négatif
    test rax, rax
    jns .convert
    neg rax
    mov rcx, 1
    
.convert:
    mov rbx, 10 ; 
.loop:
    xor rdx, rdx
    div rbx             ; rax = quotient, rdx = reste
    add dl, '0'
    mov [rsi], dl
    dec rsi
    test rax, rax
    jnz .loop
    
    ; Ajouter '-' si négatif
    test rcx, rcx
    jz .print
    mov byte [rsi], '-'
    dec rsi
    
.print:
    inc rsi             ; Revenir au début du nombre
    mov rdx, message
    add rdx, 20
    sub rdx, rsi        ; Longueur
    
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