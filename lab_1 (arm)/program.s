.global main

.data
    input_string:   .space 100      @ Максимальная длина вводимой строки (100 символов)
    output_string:  .space 100      @ Буфер для вывода строки в верхнем регистре
    word_buffer:    .space 20       @ Буфер для хранения текущего слова
    min_length:     .word 20        @ Минимальная длина слова (начальное значение)
    welcome_msg:    .asciz "This program finds the shortest word and changes all letters in the entered string to capital letters."
    prompt_msg:     .asciz "Enter the string: "
    shortest_msg:   .asciz "Shortest word in the text: "
    uppercase_msg:  .asciz "Uppercase string: "

.text

main:
    @ Вывод приветственного сообщения
    ldr r0, =welcome_msg
    bl puts

    @ Вывод приглашения к вводу
    ldr r0, =prompt_msg
    bl puts

    @ Ввод строки
    ldr r0, =input_string
    bl gets
    
    @ Инициализация переменных
    ldr r2, =min_length
    ldr r2, [r2]
    mov r1, #0          @ Счетчик символов в текущем слове
    mov r3, #0          @ Флаг, чтобы начать новое слово
    mov r4, #0          @ Индекс текущего символа в строке
    mov r5, #0          @ Индекс текущего символа в слове
    
    check_next_char:
    	@ ldrb - загрузка байта из памяти, добавляем к r0 значение из r4
        ldrb r6, [r0, r4]   @ Загрузка следующего символа из строки
        cmp r6, #0          @ Проверка на конец строки
        beq check_word      @ Если конец строки, проверяем последнее слово
    
        cmp r6, #' '        @ Проверка на пробел
        beq check_word      @ Если пробел, проверяем слово
    
        @ Обработка символа внутри слова
        add r1, r1, #1      @ Увеличение счетчика символов в текущем слове
        add r4, r4, #1      @ Увеличение индекса текущего символа в строке
        b check_next_char   @ Переход к следующему символу
    
    check_word:
        cmp r1, #0
        beq next_word       @ Если слово пустое, переходим к следующему
        cmp r1, r2
        bge next_word       @ Если слово не короче минимального, переходим к следующему
    
        @ Сохранение текущего слова как самого короткого
        mov r2, r1          @ Обновление минимальной длины
        ldr r7, =word_buffer
        add r8, r0, r4
        sub r8, r8, r1      @ Находим начало слова
    
	copy_word:
	    subs r5, r1, #1     @ Устанавливаем счетчик для копирования слова
	    b copy_next_char

	copy_next_char:
	    ldrb r9, [r8, r5]   @ Загрузка символа из исходного слова
	    strb r9, [r7, r5]   @ Сохранение символа в буфере
	    subs r5, r5, #1     @ Уменьшение счетчика символов
	    bpl copy_next_char  @ Если счетчик не отрицательный, продолжаем копирование

	    @ Добавление нулевого символа в конец слова
	    mov r9, #0
	    strb r9, [r7, r1]   @ Сохранение нулевого символа после последнего скопированного символа
    
    next_word:
        mov r1, #0          @ Сброс счетчика символов в текущем слове
        cmp r6, #0
        beq done            @ Если это был конец строки, завершаем
        add r4, r4, #1      @ Увеличение индекса текущего символа в строке
        b check_next_char   @ Переход к следующему символу
    
	done:
        @ Вывод сообщения о самом коротком слове
        ldr r0, =shortest_msg
        bl puts
        ldr r0, =word_buffer
        bl puts

        @ Преобразование строки в верхний регистр
        ldr r0, =input_string
        ldr r1, =output_string
        bl to_upper

        @ Вывод сообщения о строке в верхнем регистре
        ldr r0, =uppercase_msg
        bl puts
        ldr r0, =output_string
        bl puts

        @ Завершение программы
        mov r7, #1
        swi 0

	to_upper:
	    @ Преобразование строки в верхний регистр
	    ldrb r2, [r0], #1
	    cmp r2, #0
	    beq done_upper
	    cmp r2, #'a'
	    blt not_lower
	    cmp r2, #'z'
	    bgt not_lower
	    sub r2, r2, #32
	not_lower:
	    strb r2, [r1], #1
	    b to_upper

	done_upper:
	    mov r2, #0
	    strb r2, [r1], #1
	    bx lr
