section .data
    a db 30     ; Día
    b db 12   ; Mes
    c dw 2004  ; Año

    valid_date_msg db "T", 0xA, 0    ; "T" y salto de línea (new line)
    invalid_date_msg db "F", 0xA, 0  ; "F" y salto de línea (new line)

section .text
    extern printf
    global main

main:
    ; Verificar si el año es bisiesto
    mov ax, [c]
    mov dx, 0
    mov bx, 4
    div bx      ; Dividir el año por 4
    cmp dx, 0   ; Verificar si el residuo es cero
    jnz not_leap_year   ; Si no es cero, no es un año bisiesto

    mov dx, 0
    mov bx, 100
    div bx      ; Dividir el año por 100
    cmp dx, 0   ; Verificar si el residuo es cero
    jnz leap_year   ; Si no es cero, es un año bisiesto

    mov dx, 0
    mov bx, 400
    div bx      ; Dividir el año por 400
    cmp dx, 0   ; Verificar si el residuo es cero
    jz leap_year   ; Si es cero, es un año bisiesto

not_leap_year:
    ; Si no es un año bisiesto, maneja la lógica correspondiente aquí
    ; Por ejemplo, si febrero tiene 28 días en lugar de 29 en años no bisiestos
    cmp byte [b], 2   ; Febrero
    je check_feb_non_leap_year
    jmp check_month_day

check_feb_non_leap_year:
    cmp byte [a], 0   ; Día
    jz print_false
    cmp byte [a], 28  ; Máximo día para febrero en año no bisiesto
    ja print_false
    jmp print_true

leap_year:
    ; Si es bisiesto, verifica si el día y el mes son válidos
    cmp byte [b], 2   ; Febrero
    je check_leap_year_day
    jmp check_month_day

check_leap_year_day:
    cmp byte [a], 0   ; Día
    jz print_false
    cmp byte [a], 29  ; Máximo día para febrero en año bisiesto
    ja print_false

    ; Si es un año bisiesto y febrero, es una fecha válida
    jmp print_true

check_month_day:
    cmp byte [b], 1   ; Enero
    je check_january
    cmp byte [b], 3   ; Marzo
    je check_march
    cmp byte [b], 5   ; Mayo
    je check_month_31_days
    cmp byte [b], 7   ; Julio
    je check_month_31_days
    cmp byte [b], 8   ; Agosto
    je check_month_31_days
    cmp byte [b], 10  ; Octubre
    je check_month_31_days
    cmp byte [b], 12  ; Diciembre
    je check_month_31_days
    cmp byte [b], 4   ; Abril
    je check_month_30_days
    cmp byte [b], 6   ; Junio
    je check_month_30_days
    cmp byte [b], 9   ; Septiembre
    je check_month_31_days
    cmp byte [b], 11  ; Noviembre
    je check_month_30_days
    cmp byte [b], 12  ; Diciembre
    je check_month_31_days

    ; Si el mes no es válido, es una fecha inválida
    jmp print_false

check_january:
    cmp byte [a], 0   ; Día
    jz print_false
    cmp byte [a], 31  ; Máximo día para enero
    ja print_false
    jmp print_true

check_march:
    cmp byte [a], 0   ; Día
    jz print_false
    cmp byte [a], 31  ; Máximo día para marzo
    ja print_false
    jmp print_true

check_month_31_days:
    cmp byte [a], 0   ; Día
    jz print_false
    cmp byte [a], 31  ; Máximo día para meses con 31 días
    ja print_false
    jmp print_true

check_month_30_days:
    cmp byte [a], 0   ; Día
    jz print_false
    cmp byte [a], 30  ; Máximo día para meses con 30 días
    ja print_false
    jmp print_true

print_true:
    ; Imprimir "T"
    push valid_date_msg
    call printf
    add esp, 4
    jmp exit_program

print_false:
    ; Imprimir "F"
    push invalid_date_msg
    call printf
    add esp, 4

exit_program:
    ; Salir del programa
    ret
