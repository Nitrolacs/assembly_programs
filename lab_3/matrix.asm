global main

extern scanf, printf, exit, putchar

section .data
	order_input_message db "Enter the order of the square matrix M: ", 0
        original_matrix_message db "Original matrix:", 10, 0
        matrix_90_message       db "Matrix rotated 90 degrees clockwise:", 10, 0
	order_input_format  db "%d", 0
	string_output_format dd "%s", 10, 0
	element_input_message db "Enter element [%d, %d]: ", 0
	element_format      db "%lf", 0
        element_format_space db "%14.2lf", 0

	tmp_output          db "Size in bytes: %d", 10, 0

section .bss
        element resq 1
	matrix resq 100 ; Матрица (макс размер 10x10)
	order  resd 1   ; Порядок матрицы

section .text

main:
    mov ebp, esp; for correct debugging
	push order_input_message
	push string_output_format
	call printf

	push order
	push order_input_format
	call scanf

	; Вычисление размера матрицы
	mov eax, [order]

	; Вычисляем размер матрицы
	imul eax
	mov ebx, 8
	imul ebx
	mov edx, eax     ; Здесь хранится размер матрицы в байтах

	push edx
	push tmp_output
	call printf

	mov ecx, 1; Счётчик для цикла
        mov edi, [order] ; Порядок матрицы
	mov esi, matrix ; Указатель на начало матрицы

input_elements_loop:
        cmp ecx, edi
        ja print_original_matrix
  
        mov ebx, 1 ; Счётчик столбцов
        
        inner_loop:
            cmp ebx, edi
            ja end_inner ; Если ввели все столбцы, то выходим из цикла
            push ebx
                       push ecx ; Сохраняем счётчик строк
            
            ; Выводим сообщение о вводе элемента
            push element_input_message
            call printf
            add esp, 4

            pop ecx
            pop ebx            
            
            push eax ; Сохраняем значение регистра eax
            push ebx ; Сохраняем значение регистра ebx

                  
            mov eax, ecx
            dec eax
            imul edi
            mov ebx, 8
            imul ebx
            
            pop ebx
            lea esi, [matrix + eax + 8*(ebx-1)]
            
            pop eax ; Восстанавливаем значение регистра eax

            push ecx
            push esi
            push element_format
            call scanf
            add esp, 8

            pop ecx
                        
            inc ebx
            jmp inner_loop

        end_inner:
        inc ecx
        jmp input_elements_loop
                                                                                                             
        
print_original_matrix:

     
    push original_matrix_message
    push string_output_format
    call printf    

    mov ecx, 1 ; Счётчик строк
    mov edi, [order] ; Порядок матрицы
    mov esi, matrix ; Указатель на начало матрицы

    print_rows_loop:
        cmp ecx, edi
        ja end_print ; Если все строки напечатаны, выходим из цикла

        mov ebx, 1 ; Счётчик столбцов

        print_columns_loop:
            cmp ebx, edi
            ja end_row ; Если все столбцы напечатаны, переходим к следующей строке

            push eax ; Сохраняем значение регистра eax
            push ebx ; Сохраняем значение регистра ebx

            mov eax, ecx
            dec eax
            imul edi
            mov ebx, 8
            imul ebx
            
            

            pop ebx
            lea esi, [matrix + eax + 8*(ebx-1)]

            pop eax ; Восстанавливаем значение регистра eax
            
            push ecx

            fld qword [esi] ; Загружаем значение в стек FPU

            sub esp, 8 ; Выделяем место в стеке для числа с плавающей точкой
            fstp qword [esp] ; Сохраняем значение из стека FPU в стек

            push element_format_space
            call printf
            add esp, 12 ; Удаляем format и число с плавающей точкой из стека

            pop ecx

            inc ebx
            jmp print_columns_loop

        end_row:
            push ecx
        
            ; Печатаем новую строку
            push 10 ; ASCII код для новой строки
            call putchar
            add esp, 4
            
            pop ecx
           
            inc ecx
            jmp print_rows_loop
                  
    end_print:
    
print_matrix:
   
    push matrix_90_message
    push string_output_format
    call printf
       
    mov ecx, 1 ; Счётчик колонок
    mov edi, [order] ; Порядок матрицы
    mov esi, matrix ; Указатель на начало матрицы

    _print_columns_loop:
        cmp ecx, edi 
        ja _end_print ; Если все колонки напечатаны, то выходим из цикла

        mov ebx, [order] ; Счётчик строк

        _print_rows_loop:
            cmp ebx, 1
            jb _end_row ; Если все строки напечатаны, переходим к следующему столбцу


            ; Расчет положения элемента в массиве
            push eax ; Сохраняем значение регистра eax
            push ebx ; Сохраняем значение регистра ebx
            push ecx ; Сохраняем значение регистра ecx

            mov eax, ebx
            dec eax
            imul edi
            mov ebx, 8
            imul ebx
            
            lea esi, [matrix + eax + 8*(ecx-1)]
            
            fld qword [esi] ; Загружаем значение в стек FPU

            sub esp, 8 ; Выделяем место в стеке для числа с плавающей точкой
            fstp qword [esp] ; Сохраняем значение из стека FPU в стек

            push element_format_space
            call printf
            add esp, 12 ; Удаляем format и число с плавающей точкой из стека

            pop ecx ; Восстанавливаем значение регистра ecx
            pop ebx ; Восстанавливаем значение регистра ebx
            pop eax ; Восстанавливаем значение регистра eax

            dec ebx
            jmp _print_rows_loop

        _end_row:
            push ecx
        
            ; Печатаем новую строку
            push 10 ; ASCII код для новой строки
            call putchar
            add esp, 4
            
            pop ecx
           
            inc ecx
            jmp _print_columns_loop
                  
    _end_print:
               
    push 0
    call exit

