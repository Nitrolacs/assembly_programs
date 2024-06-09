.data
	matrix: .space 200
	filename: .asciz "new_matrix.bin"
	original_matrix_message: .asciz "Изначальная матрица:\n"
	space_between_elements: .asciz "     "
	newline_symbol: .asciz "\n"
	matrix_rotated_90_degrees_message: "Матрица, повёрнутая на 90 градусов по часовой стрелке:\n"
	matrix_rotated_180_degrees_message: "Матрица, повёрнутая на 180 градусов по часовой стрелке:\n"
	matrix_rotated_270_degrees_message: "Матрица, повёрнутая на 270 градусов по часовой стрелке:\n"

.eqv   int_size   4

.macro    exit
	li a7, 10
	ecall
.end_macro
		
.macro  print  %msg %order %matrix
	la a0, %msg
	mv s5, %order
	mv s6, %matrix
	li a7, 4
	ecall
	
	# Счётчик строк
	li a5, 1
	
	print_rows_loop:
		# Проверяем, напечатали ли мы все строки
		bgt a5, s5, end_print
		
		# Счётчик столбцов
		li a6, 1
		
		print_columns_loop:
			# Проверяем, напечатаны ли все числа в строке
			bgt a6, s5, end_row
			
			lw s7, (s6)
			mv a0, s7
			li a7, 1
			ecall
			
			la a0, space_between_elements
			li a7, 4
			ecall
			
			addi s6, s6, int_size
			addi a6, a6, 1
			
			j print_columns_loop
			
		end_row:
			la a0, newline_symbol
			li a7, 4
			ecall
			
			addi a5, a5, 1
			j print_rows_loop
	
	end_print:
		la a0, newline_symbol
		li a7, 4
		ecall	
			
.end_macro	

.macro  rotate_matrix %order %matrix
	mv s5, %order
	mv a1, %matrix
	
	li t1, 2
	
	div t1, s5, t1
	
	# Внешний цикл for i in range(order // 2):
	
	# Счётчик строк (i)
	li t3, 0
	
	rows_loop_for_rotate:
		beq t3, t1, end_rotate
		
		# Внутренний цикл for j in range(i,  order - i - 1):
		
		# Счётчик столбцов (j)
		mv t4, t3
		
		columns_loop_for_rotate:
			sub t6, s5, t3
			addi t6, t6, -1
			
			beq t4, t6, end_row_for_rotate
			
			#======================================
			# Берём элемент из верхнего левого угла
			# temp = Matrix[i][j]
			
			li s10, int_size
			mul s9, s10, s5
			mul s9, s9, t3
			
			mul s10, s10, t4
			
			add s11, s9, s10
			
			add s11, s11, a1
			
			lw s8, (s11)
			
			#======================================
			# Берём элемент из нижнего левого угла
			# Matrix[i][j] = Matrix[order - 1 - j][i]
			
			sub s0, s5, t4
			addi s0, s0, -1
			
			mul s0, s0, s5
			li s10, int_size
			mul s0, s0, s10
			
			li s9, int_size
			mul s9, s9, t3
			
			add s0, s0, s9
			add s0, s0, a1
			
			lw s4, (s0)
			sw s4, (s11)
			
			#======================================
			# В значение по адресу s0 кладём значение
			# Matrix[order - 1 - j][i] = Matrix[order - 1 - i][order - 1 - j]

			mv s11, s5
			addi s11, s11, -1
			
			sub s10, s11, t3
			
			li t2, int_size
			mul s10, s10, t2
			mul s10, s10, s5
			
			sub s11, s11, t4
			mul s11, s11, t2
			add s10, s10, s11
			add s10, s10, a1
			
			lw s9, (s10)
			sw s9, (s0)
			
			#======================================
			# В значение по адресу s10 кладём значение
			# Matrix[order - 1 - i][order - 1 - j] = Matrix[j][order - 1 - i]
			
			mul s11, t4, s5
			li t2, int_size
			mul s11, s11, t2
			sub t2, s5, t3
			addi t2, t2, -1
			li s0, int_size
			mul t2, t2, s0
			add s11, s11, t2
			add s11, s11, a1
			lw t2, (s11)
			sw t2, (s10) 
			
			#======================================
			# Matrix[j][order - 1 - i] = temp
			
			sw s8, (s11)
			
			#======================================
			
			addi t4, t4, 1
			j columns_loop_for_rotate
			
		end_row_for_rotate:
			addi t3, t3, 1
			j rows_loop_for_rotate	  
		
	end_rotate:	
	

.end_macro	

.text	
.globl main	
		
main:
	# Открываем файл для чтения
	li a7, 1024
	la a0, filename
	li a1, 0
	ecall
	mv s6, a0
	
	# Считываем информацию из файла
	li a7, 63
	li a2, 200
	la a1, matrix
	ecall
	
	# Закрываем файл
	li a7, 57
	mv a0, s6
	ecall
	
	# Считываем порядок матрицы
	lw a3, (a1)
	li t1, int_size
	add a1, a1, t1
	
	print   original_matrix_message a3 a1
	rotate_matrix   a3 a1
	print   matrix_rotated_90_degrees_message a3 a1
	rotate_matrix   a3 a1
	print   matrix_rotated_180_degrees_message a3 a1
	rotate_matrix   a3 a1
	print   matrix_rotated_270_degrees_message a3 a1
			
	# Выход
	exit
	
