.global _start

.data
	enter_message_x: .asciz "Введите: x = "   
	enter_message_a: .asciz "Enter: a = "
	result:          .asciz "Результат: y = "
	newline:         .asciz "\n"

.text
_start:
	# Получение x от пользователя
	li a7, 51
	la a0, enter_message_x
	ecall
	
	# Изначальный x
	mv t1, a0
	
	# Получение a от пользователя
	li a7, 51
	la a0, enter_message_a
	ecall
	
	# a
	mv t2, a0
	
	# Ицициализация счётчика
	mv t0, zero
	
	# Начало цикла.
	loop_start:
		
		# Прибавляем i к x
		mv t3, t1
		add t3, t3, t0
	
	# Расчёт y1
	calculate_y1:
		
		# Проверяем: x > a
		bgt t3, t2, x_more_than_a
		
		# x <= a
		x_less_than_or_equal_to_a:
			
			# y1 = a
			mv a4, t2
			
			j calculate_y2  
		
		# x > a
		x_more_than_a:
		
			li a5, 4
			
			# y1 = x mod 4
			rem a4, t3, a5 
	
	# Расчёт y2		
	calculate_y2:
		
		# x / a
		
		li a7, 3
		mul a6, t2, a7
		
		# x > a * 3
		# Проверяем: x > a * 3
		bgt t3, a6, x_div_a_more_than_3
		
		# x / a <= 3
		x_div_a_less_than_or_equal_to_3:
			
			# y2 = x
			mv a5, t3
			
			j calculate_y
		
		# x / a > 3	
		x_div_a_more_than_3:
			
			# y2 = a * x
			mul a5, t3, t2   
	
	# Расчёт y
	calculate_y:
		
		# y = y1 + y2
		add a6, a4, a5
		
		# Вывод сообщения
		la a0, result
		li a7, 4
		ecall
		
		# Вывод результата
		mv a0, a6
		li a7, 1
		ecall
		
		# Вывод символа перевода строки
		la a0, newline
		li a7, 4
		ecall
		
		# Увеличиваем ш на 1
		addi t0, t0, 1
		
		# Если i меньше 10, то продолжаем цикл
		li a0, 10
		blt t0, a0, loop_start  
	
	end_of_program:
		# Выход из программы.
		li a7, 10
		ecall
