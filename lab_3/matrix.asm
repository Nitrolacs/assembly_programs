global main

extern scanf, printf, exit

section .data
	order_input_message db "Enter the order of the square matrix M: ", 0
	order_input_format  db "%d", 0
	string_output_format dd "%s", 10, 0
	element_input_message db "Enter element [%d, %d]: ", 0
	element_format      db "%f", 0

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
        
        mov eax, 1
	push 0
	call exit
