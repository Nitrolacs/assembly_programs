section .bss
    matrix resb 400 ; Выделяем место под матрицу размером 10x10 (максимум)

section .data
    orderMsg db 'Введите порядок квадратной матрицы M: ', 0
    elemMsg db 'Введите элемент [%d, %d]: ', 0
    newLine db 10, 0
    format db '%f', 0 ; Формат для ввода чисел с плавающей точкой
    matrixOrder dd 0  ; Порядок матрицы

section .text
    extern printf, scanf
    global main

main:
    ; Запрашиваем порядок матрицы
    mov rdi, orderMsg
    call printf

    ; Считываем порядок матрицы
    mov rdi, format
    lea rsi, [matrixOrder]
    call scanf
    movzx rdi, dword [matrixOrder] ; Порядок матрицы в rdi

    ; Ввод элементов матрицы
    mov rsi, matrix ; Указатель на начало матрицы
    xor rax, rax    ; Счетчик строк
input_loop:
    cmp rax, rdi
    jae print_original_matrix   ; Если ввели все строки, переходим к выводу матрицы
    push rax        ; Сохраняем счетчик строк
    xor rbx, rbx    ; Счетчик столбцов
    inner_loop:
        cmp rbx, rdi
        jae end_inner ; Если ввели все столбцы, выходим из внутреннего цикла
        push rbx      ; Сохраняем счетчик столбцов

        ; Выводим сообщение о вводе элемента
        mov rsi, rbx
        mov rdx, rax
        mov rdi, elemMsg
        call printf

        ; Считываем элемент
        lea rsi, [matrix + rax*4*rdi + rbx*4] ; Позиция элемента в матрице
        mov rdi, format
        call scanf

        pop rbx
        inc rbx
        jmp inner_loop
    end_inner:
    pop rax
    inc rax
    jmp input_loop

print_original_matrix:
    ; Выводим изначальную матрицу
    mov r8, 0 ; Счетчик строк
print_outer_loop:
    cmp r8, [matrixOrder]
    jae transpose_matrix ; Если все строки выведены, переходим к транспонированию
    mov r9, 0 ; Счетчик столбцов
print_inner_loop:
    cmp r9, [matrixOrder]
    jae print_row_end ; Если все столбцы строки выведены, переходим к новой строке
    ; Выводим элемент матрицы
    mov rdi, format ; Формат вывода
    lea rsi, [matrix + r8*4*rdi + r9*4] ; Адрес элемента матрицы
    call printf
    inc r9
    jmp print_inner_loop
print_row_end:
    ; Выводим перевод строки после каждой строки матрицы
    mov rdi, newLine
    call printf
    inc r8
    jmp print_outer_loop

; Транспонирование матрицы
transpose_matrix:
    mov r8, 0 ; Счетчик строк
transpose_outer_loop:
    cmp r8, [matrixOrder]
    jae transpose_end
    mov r9, r8 ; Счетчик столбцов
transpose_inner_loop:
    cmp r9, [matrixOrder]
    jae transpose_inner_end
    ; Меняем местами элементы [r8, r9] и [r9, r8]
    mov rax, [matrix + r8*4*rdi + r9*4] ; Элемент [r8, r9]
    mov rbx, [matrix + r9*4*rdi + r8*4] ; Элемент [r9, r8]
    mov [matrix + r8*4*rdi + r9*4], rbx
    mov [matrix + r9*4*rdi + r8*4], rax
    inc r9
    jmp transpose_inner_loop
transpose_inner_end:
    inc r8
    jmp transpose_outer_loop
transpose_end:

; Инвертирование столбцов
invert_columns:
    mov r8, 0 ; Счетчик столбцов
invert_columns_outer_loop:
    cmp r8, [matrixOrder]
    jae invert_columns_end
    mov r9, 0 ; Счетчик для верхнего элемента
    mov r10, [matrixOrder] ; Счетчик для нижнего элемента
    dec r10
invert_columns_inner_loop:
    cmp r9, r10
    jae invert_columns_inner_end
    ; Меняем местами элементы [r9, r8] и [r10, r8]
    mov rax, [matrix + r9*4*rdi + r8*4] ; Элемент [r9, r8]
    mov rbx, [matrix + r10*4*rdi + r8*4] ; Элемент [r10, r8]
    mov [matrix + r9*4*rdi + r8*4], rbx
    mov [matrix + r10*4*rdi + r8*4], rax
    inc r9
    dec r10
    jmp invert_columns_inner_loop
invert_columns_inner_end:
    inc r8
    jmp invert_columns_outer_loop
invert_columns_end:

; Вывод повернутой матрицы
print_matrix:
    mov r8, 0 ; Счетчик строк
_print_outer_loop:
    cmp r8, [matrixOrder]
    jae _print_end ; Если все строки выведены, завершаем функцию
    mov r9, 0 ; Счетчик столбцов
_print_inner_loop:
    cmp r9, [matrixOrder]
    jae _print_row_end ; Если все столбцы строки выведены, переходим к новой строке
    ; Выводим элемент матрицы
    mov rdi, format ; Формат вывода
    lea rsi, [matrix + r8*4*rdi + r9*4] ; Адрес элемента матрицы
    call printf
    inc r9
    jmp _print_inner_loop
_print_row_end:
    ; Выводим перевод строки после каждой строки матрицы
    mov rdi, newLine
    call printf
    inc r8
    jmp _print_outer_loop
_print_end:

    ; Завершение программы
    mov eax, 60       ; syscall номер для exit
    xor edi, edi      ; статус
    syscall
