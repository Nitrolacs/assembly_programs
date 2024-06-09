.global main

.data
    input_string:   .space 100      @ Максимальная длина вводимой строки (100 символов)
    output_string:  .space 100      @ Буфер для вывода строки в верхнем регистре
    word_count:     .word 0         @ Счетчик слов
    total_length:   .word 0         @ Суммарная длина всех слов
    average_length: .word 0         @ Средняя длина слова
    welcome_msg:    .asciz "This program counts the number of words, calculates the average word length, and changes all letters in the entered string to capital letters."
    prompt_msg:     .asciz "Enter the string: "
    result_msg:     .asciz "Number of words: %d, Average word length: %d\n"
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
    mov r1, #0          @ Счетчик символов в текущем слове
    mov r4, #0          @ Индекс текущего символа в строке
    
    check_next_char:
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
    
        @ Увеличиваем счетчик слов и добавляем длину слова к общей длине
        ldr r2, =word_count
        ldr r3, [r2]
        add r3, r3, #1
        str r3, [r2]
        ldr r2, =total_length
        ldr r3, [r2]
        add r3, r3, r1
        str r3, [r2]
    
    next_word:
        mov r1, #0          @ Сброс счетчика символов в текущем слове
        cmp r6, #0
        beq done            @ Если это был конец строки, завершаем
        add r4, r4, #1      @ Увеличение индекса текущего символа в строке
        b check_next_char   @ Переход к следующему символу
    
	done:
        @ Вычисление средней длины слова
        ldr r1, =word_count
        ldr r1, [r1]            @ Загрузка значения счетчика слов
        ldr r2, =total_length
        ldr r2, [r2]            @ Загрузка суммарной длины всех слов
        cmp r1, #0
        beq no_words            @ Если слов нет, пропускаем деление

        bl divide               @ Вызов функции деления
        ldr r3, =average_length
        str r0, [r3]            @ Сохранение средней длины слова

        @ Вывод результатов
        ldr r0, =result_msg
        ldr r1, =word_count
        ldr r1, [r1]
        ldr r2, =average_length
        ldr r2, [r2]
        bl printf

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

divide:
    @ Функция деления total_length на word_count
    @ r1 - делитель (word_count), r2 - делимое (total_length)
    @ Результат будет в r0
    push {r4-r7, lr}        @ Сохранение регистров
    mov r0, #0              @ Обнуление результата
    mov r3, #0              @ Обнуление счетчика

divide_loop:
    cmp r2, r1              @ Сравнение делимого с делителем
    blt end_divide          @ Если делимое меньше делителя, завершаем деление
    sub r2, r2, r1          @ Вычитание делителя из делимого
    add r0, r0, #1          @ Увеличение результата
    b divide_loop           @ Повторение цикла

end_divide:
    pop {r4-r7, lr}         @ Восстановление регистров
    bx lr                   @ Возврат из функции

no_words:
    mov r0, #0              @ Если слов нет, средняя длина равна 0
    b done_calculation      @ Переход к завершению вычислений

done_calculation:
    @ Здесь r0 содержит среднюю длину слова
    bx lr
