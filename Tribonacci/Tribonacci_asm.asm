%include "io.inc"

section .data
    i dw 6

section .text
global main
main:
    mov ebp, esp; for correct debugging 
    mov eax, 1 ; valor mas actual f(n-1)
    mov ebx, 0 ; valor anterior f(n-2)
    mov edx, 0 ; valor mas anterior f(n-3)
    
    xor ecx, ecx ; inicializa en 0 ecx
    
    movzx ecx, word [i] ; guarda el valor de i en ecx
    ;mov ecx, i 
    
    ; Aqui se definen los casos bases si ecx es 0 o 1 => 0, si ecx es 2=>1
    cmp ecx, 1 ; compara ecx con 1
    jle .base ; si es menor igual que 1
    
    cmp ecx, 2 ; compara ecx con 2
    je .end ;si es igual a 2
    
    ; Si es mayor que 2, es decir no entra en los casos bases
    sub ecx, 2 ; resto 2 para quedarme con la cantidad de veces que debo ejecutar el codigo
    jmp .trib ; entra al bloque de codigo del tribonacci


.base:
    mov eax, 0
    jmp .end

.trib:
    add edx, eax ; sumar edx con eax y guardarlo en edx
    add edx, ebx ; sumar ebx con edx y guardarlo en edx
    
    ; Esto permite dejar el valor de la ultima suma en orden de prioridad y eliminar el valor anterior
    xchg edx, ebx ; intercambiar los valores edx y ebx
    xchg ebx, eax ; intercambiar los valores ebx y eax
    
    ; Decrementar el contador de las veces que debia ejecutar el codigo y comparar con 0
    ; si es 0 ya terminamos y sale hasta .end si aun quedan veces por ejecutar salta nuevamente
    ; al inicio del trib a ejecutar otra vez
    dec ecx
    cmp ecx, 0
    je .end
    
    jmp .trib
    
.end:
    PRINT_DEC 1, eax
    
    xor eax, eax
    ret