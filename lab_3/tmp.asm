section .data
    format_in db "%lf", 0 ; формат ввода для scanf
    format_out db "%lf ", 0 ; формат вывода для printf
    format_nl db 0xA, 0 ; символ новой строки
    prompt_order db "Введите порядок квадратной матрицы: ", 0
    prompt_element db "Введите элемент ", 0
    prompt_element_colon db ": ", 0

section .bss
    order resd 1 ; порядок матрицы
    matrix resq 100 ; матрица (максимальный размер 10x10)

section .text
    extern scanf, printf

global main

main:
    ; Ввод порядка матрицы
    mov eax, 4 ; Системный вызов write
    mov ebx, 1 ; Файловый дескриптор stdout
    mov ecx, prompt_order ; Адрес строки-приглашения
    mov edx, 32 ; Длина строки-приглашения
    int 0x80 ; Прерывание для вывода строки-приглашения

    mov eax, 0
    lea esi, [order]
    lea edi, [format_in]
    call scanf
    ; Проверка на правильность ввода порядка матрицы
    cmp eax, 1
    jne error_exit

    ; Вычисление размера матрицы
    mov eax, [order]
    imul eax, eax, 8 ; каждый элемент матрицы - 8 байт (double)
    mov ecx, eax ; ecx = размер матрицы в байтах

    ; Ввод элементов матрицы
    mov edi, matrix
    mov edx, ecx ; edx = размер матрицы в байтах
    mov esi, 0 ; счетчик

input_loop:
    mov eax, esi
    inc eax
    mov ebx, [order]
    imul eax, ebx
    add eax, esi ; eax = i*(order+1)

    mov eax, esi ; Подготовка параметров для вывода строки-приглашения
    inc eax
    push eax ; Пушим строку в стек для передачи в printf
    mov eax, esi
    inc eax
    mov ebx, [order]
    push ebx ; Пушим строку в стек для передачи в printf
    lea ecx, [prompt_element_colon] ; Пушим символ ":" в стек для передачи в printf
    push ecx
    lea ecx, [prompt_element] ; Адрес строки-приглашения
    push ecx
    call printf ; Вызов printf
    add esp, 16 ; Очистка стека

    mov eax, edi[eax*8] ; адрес элемента
    lea ecx, [format_in]
    push ecx ; push format_in
    push eax ; push address of element
    call scanf
    add esp, 8 ; очистка стека
    inc esi
    cmp esi, ebx
    jl input_loop

    ; Вывод исходной матрицы
    mov edi, matrix
    mov esi, 0 ; счетчик

output_loop:
    mov eax, 4 ; Системный вызов write
    mov ebx, 1 ; Файловый дескриптор stdout
    mov ecx, prompt_element ; Адрес строки-приглашения
    mov edx, 16 ; Длина строки-приглашения
    int 0x80 ; Прерывание для вывода строки-приглашения

    mov eax, esi
    inc eax
    mov ebx, [order]
    imul eax, ebx
    add eax, esi ; eax = i*(order+1)
    movsd xmm0, edi[eax*8] ; загрузка элемента в xmm0
    lea ecx, [format_out]
    push ecx ; push format_out
    mov eax, 1 ; выбор регистра xmm
    call printf
    add esp, 4 ; очистка стека
    inc esi
    cmp esi, ebx
    jl output_loop

    ; Вывод новой строки
    mov eax, format_nl
    call printf

    ; Поворот матрицы на 90 градусов
    mov edi, matrix
    mov esi, 0 ; счетчик

rotate_90:
    mov eax, 4 ; Системный вызов write
    mov ebx, 1 ; Файловый дескриптор stdout
    mov ecx, prompt_element ; Адрес строки-приглашения
    mov edx, 16 ; Длина строки-приглашения
    int 0x80 ; Прерывание для вывода строки-приглашения

    mov eax, esi
    inc eax
    mov ebx, [order]
    imul ebx, ebx
    sub ebx, [order]
    mov ecx, eax
    sub ecx, ebx ; eax - order
    mov edx, [order]
    dec edx
    imul ecx, edx
    add ecx, esi ; ecx = (i-order)*(order-1)+j
    movsd xmm0, edi[ecx*8] ; загрузка элемента в xmm0
    lea ecx, [format_out]
    push ecx ; push format_out
    mov eax, 1 ; выбор регистра xmm
    call printf
    add esp, 4 ; очистка стека
    inc esi
    cmp esi, [order]
    jl rotate_90

    ; Вывод новой строки
    mov eax, format_nl
    call printf

    ; Поворот матрицы на 180 градусов
    mov edi, matrix
    mov esi, 0 ; счетчик

rotate_180:
    mov eax, 4 ; Системный вызов write
    mov ebx, 1 ; Файловый дескриптор stdout
    mov ecx, prompt_element ; Адрес строки-приглашения
    mov edx, 16 ; Длина строки-приглашения
    int 0x80 ; Прерывание для вывода строки-приглашения

    mov eax, esi
    inc eax
    mov ebx, [order]
    imul ebx, ebx
    sub ebx, 1
    sub ebx, esi
    mov edx, ebx
    imul edx, [order]
    add edx, eax ; edx = (order-1-i)*order+j
    movsd xmm0, edi[edx*8] ; загрузка элемента в xmm0
    lea ecx, [format_out]
    push ecx ; push format_out
    mov eax, 1 ; выбор регистра xmm
    call printf
    add esp, 4 ; очистка стека
    inc esi
    cmp esi, [order]
    jl rotate_180

    ; Вывод новой строки
    mov eax, format_nl
    call printf

    ; Поворот матрицы на 270 градусов
    mov edi, matrix
    mov esi, 0 ; счетчик

rotate_270:
    mov eax, 4 ; Системный вызов write
    mov ebx, 1 ; Файловый дескриптор stdout
    mov ecx, prompt_element ; Адрес строки-приглашения
    mov edx, 16 ; Длина строки-приглашения
    int 0x80 ; Прерывание для вывода строки-приглашения

    mov eax, esi
    inc eax
    mov ebx, [order]
    imul ebx, ebx
    sub ebx, [order]
    dec ebx
    sub ebx, esi
    mov ecx, eax
    imul ecx, ebx
    mov edx, [order]
    dec edx
    imul edx, edx
    add ecx, edx
    add ecx, esi ; ecx = (order-i-1)*(order+1)+j
    movsd xmm0, edi[ecx*8] ; загрузка элемента в xmm0
    lea ecx, [format_out]
    push ecx ; push format_out
    mov eax, 1 ; выбор регистра xmm
    call printf
    add esp, 4 ; очистка стека
    inc esi
    cmp esi, [order]
    jl rotate_270

exit:
    mov eax, 0x1 ; Системный вызов exit
    xor ebx, ebx ; Код завершения 0
    int 0x80

error_exit:
    mov eax, 0x1 ; Системный вызов exit
    xor ebx, ebx ; Код завершения 0
    int 0x80
