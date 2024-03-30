%include "io.inc"

section .data
    arr dd 1, 0, 1, 1, 0, 0    ; Definir el arreglo.
    n dd 6                  ; Longitud del arreglo.

section .bss
    ; Reserva de espacio para variables si es necesario.

section .text
global CMAIN

CMAIN:
    mov ebp, esp; for correct debugging
    mov edi, arr        ; Primer argumento de 'imprimirSufijoParaPalindromo', la direccion de arr.
    mov esi, [n]        ; Segundo argumento de 'imprimirSufijoParaPalindromo', el tamaño de arr.
    call _imprimirSufijoParaPalindromo

    xor eax, eax
    ret

_esPalindromo:
    mov ecx, esi                  ; copiamos n a ecx.
    dec ecx                       ; fin = n - 1.
    mov ebx, eax                  ; copiamos inicio a ebx (inicio de comparación).
    
    palindromo_loop:
        cmp ebx, ecx                  ; Comparamos inicio con fin.
        jge .esPalindromoRetornoVerdadero ; Si inicio >= fin, es palíndromo.
        mov eax, [edi + ebx*4]        ; Valor en inicio.
        cmp eax, [edi + ecx*4]        ; Valor en fin.
        jne .esPalindromoRetornoFalso
        inc ebx                       ; Incrementamos inicio.
        dec ecx                       ; Decrementamos fin.
        jmp palindromo_loop
    .esPalindromoRetornoFalso:
        mov eax, 0                     ; Retornar falso (0).
        ret
    .esPalindromoRetornoVerdadero:
        mov eax, 1                     ; Retornar verdadero (1).
        ret

_imprimirSufijoParaPalindromo:
    xor ecx, ecx                   ; i = 0.
    
    find_palindromo_prefix_loop:
        cmp ecx, esi                   ; Comparamos i con n.
        je .find_palindromo_prefix_done ; si i == n hemos terminado.
        mov edx, esi                   ; Argumento n para esPalindromo.
        mov eax, ecx                   ; Argumento inicio para esPalindromo.
        push ecx
        call _esPalindromo
        pop ecx
        test eax, eax                  ; Verificamos si esPalindromo retornó verdadero.
        jz .increment_i                ; Si no, incrementamos i y continuamos.
        jmp .find_palindromo_prefix_done ; Si sí, hemos terminado.
        
    .increment_i:
        inc ecx
        jmp find_palindromo_prefix_loop
    
    .find_palindromo_prefix_done:
        dec ecx ; Ajustamos para el índice correcto del último elemento no palíndromo.
        print_prefix:
            cmp ecx, -1 ; Verificamos si hemos terminado con todos los elementos.
            jle .done_printing
            
            PRINT_DEC 4, [arr + ecx*4]
            
            dec ecx ; Mover al siguiente elemento para imprimir.
            jmp print_prefix
            
        .done_printing:
        ret