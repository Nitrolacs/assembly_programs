.global _start

.data
	matrix: .space 400
	filename: .asciz "matrix.bin"
	original_matrix_message: .asciz "Original matrix:\n"
	space_between_elements: .asciz "     "
	newline_symbol: .asciz "\n"
	
	man_mix_elements_header_message: .asciz "Search for strings that are ordered in descending or ascending order...\n"
	string_in_ascending_order: .asciz "Line number, sorted in ascending order: "
	string_in_descending_order: .asciz "Line number, sorted in descending order: "
	min_element: .asciz "Min element in this row: "
	max_element: .asciz "Max element in this row: "
	
	man_mix_elements_header_message_2: .asciz "Search for columns that are ordered in descending or ascending order...\n"
	column_in_ascending_order: .asciz "Column number, sorted in ascending order: "
	column_in_descending_order: .asciz "Column number, sorted in descending order: "
	min_element_column: .asciz "Min element in this column: "
	max_element_column: .asciz "Max element in this column: "
	
.text
_start:
	# Открываем файл для чтения
	li a7, 1024
	la a0, filename
	li a1, 0
	ecall
	mv s6, a0
	
	# Считываем всю информацию из файла
	li a7, 63
	li a2, 400
	la a1, matrix
	ecall
	
	# Закрытие файла
	li a7, 57
	mv a0, s6
	ecall
	
	# Количество строк
	lw a3, (a1)
	
	li t1, 4
	add a1, a1, t1
	
	# Количество столбцов
	lw a4, (a1)
	
	#mv a0, a4
	#li a7, 1
	#ecall
	
	la t1, matrix
	addi t1, t1, 8
	li t5, 4
	
	# Счётчик строк
	li a5, 1
	
	la a0, original_matrix_message
	li a7, 4
	ecall

	print_rows_loop:
		
		# Проверяем, напечатаны ли все строки
		bgt a5, a3, end_print
		
		# Счётчик столбцов
		li a6, 1
		
		print_columns_loop:
			
			# Проверяем, напечатаны ли все символы в строке
			bgt a6, a4, end_row
		
			lw s7, (t1)
			mv a0, s7
			li a7, 1
			ecall
			
			la a0, space_between_elements
			li a7, 4
			ecall
			
			add t1, t1, t5
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
		
	max_mix_elements_in_row:
	
		la a0, man_mix_elements_header_message
		li a7, 4
		ecall
		
		la a0, newline_symbol
		li a7, 4
		ecall
		
		la t1, matrix
		addi t1, t1, 8
		li t5, 4
		
		# Счётчик строк
		li a5, 1
		
		li s11, 0
	
		find_rows_loop:
			
			# Проверяем, обработаны ли все строки
			bgt a5, a3, end_find
			
			# Счётчик столбцов
			li a6, 1
			
			columns_loop:
				
				# Проверяем, прошёл ли цикл по всем колонкам
				bgt a6, a4, _end_row
				
				# Если первый элемент в строке.
				li s7, 1
				beq a6, s7, first_element_in_row
				j next_element_in_row
			
				first_element_in_row:
					lw s10, (t1)
					mv s9, s10
					
					j end_columns_loop_first
			
				next_element_in_row:
				
					lw s8, (t1)
					
					bgt s8, s9, greater_element
					blt s8, s9, less_element
					
				greater_element:
					addi s11, s11, 1
					j end_columns_loop_spec
					
				less_element:
					addi s11, s11, -1
				
			end_columns_loop_spec:	
			
				mv s9, s8
				
			end_columns_loop_first:	
				add t1, t1, t5
				addi a6, a6, 1
						
				j columns_loop
				
			_end_row:
				
				mv a0, a4
				li a7, 1
				sub	a0, a0, a7
				
				beq a0, s11, found_increase
				
				neg a0, a0
				beq a0, s11, found_decrease
				
				j end_rows_loop_spec
			
			found_increase:
				la a0, string_in_ascending_order
				li a7, 4
				ecall
				
				mv a0, a5
				li a7, 1
				ecall
				
				la a0, newline_symbol
				li a7, 4
				ecall
				
				la a0, min_element
				li a7, 4
				ecall
				
				mv a0, s10
				li a7, 1
				ecall
				
				la a0, newline_symbol
				li a7, 4
				ecall
				
				la a0, max_element
				li a7, 4
				ecall
				
				mv a0, s9
				li a7, 1
				ecall
				
				la a0, newline_symbol
				li a7, 4
				ecall
				
				la a0, newline_symbol
				li a7, 4
				ecall
				
				j end_rows_loop_spec
				
			found_decrease:
				la a0, string_in_descending_order
				li a7, 4
				ecall
				
				mv a0, a5
				li a7, 1
				ecall
				
				la a0, newline_symbol
				li a7, 4
				ecall
				
				la a0, min_element
				li a7, 4
				ecall
				
				mv a0, s9
				li a7, 1
				ecall
				
				la a0, newline_symbol
				li a7, 4
				ecall
				
				la a0, max_element
				li a7, 4
				ecall
				
				mv a0, s10
				li a7, 1
				ecall
				
				la a0, newline_symbol
				li a7, 4
				ecall
							
				la a0, newline_symbol
				li a7, 4
				ecall		
					
			end_rows_loop_spec:			
				addi a5, a5, 1
				li s11, 0
				j find_rows_loop
		
		end_find:
		
			la a0, newline_symbol
			li a7, 4
			ecall
	
					
	max_mix_elements_in_column:		
		
		la a0, man_mix_elements_header_message_2
		li a7, 4
		ecall
		
		la a0, newline_symbol
		li a7, 4
		ecall
		
		la t1, matrix
		addi t1, t1, 8
		li t5, 0
		
		# Найдём число перехода на новую строку
		li t6, 4
		mul t6, a4, t6
		
		# Счётчик столбцов
		li a5, 1
		
		li s11, 0
	
		find_columns_loop:
			
			# Проверяем, обработаны ли все строки
			bgt a5, a4, _end_find
			
			# Счётчик строк
			li a6, 1
			
			rows_loop:
				
				# Проверяем, прошёл ли цикл по всем строкам
				bgt a6, a3, _end_column
				
				# Если первый элемент в колонке.
				li s7, 1
				beq a6, s7, first_element_in_column
				j next_element_in_column
			
				first_element_in_column:
					lw s10, (t1)
					mv s9, s10
					
					j _end_rows_loop_first
			
				next_element_in_column:
				
					lw s8, (t1)
					
					bgt s8, s9, _greater_element
					blt s8, s9, _less_element
					
				_greater_element:
					addi s11, s11, 1
					j _end_rows_loop_spec
					
				_less_element:
					addi s11, s11, -1
				
			_end_rows_loop_spec:	
			
				mv s9, s8
				
			_end_rows_loop_first:	
				add t1, t1, t6
				addi a6, a6, 1
						
				j rows_loop
				
			_end_column:
				
				mv a0, a3
				li a7, 1
				sub	a0, a0, a7
				
				beq a0, s11, _found_increase
				
				neg a0, a0
				beq a0, s11, _found_decrease
				
				j _end_columns_loop_spec
			
			_found_increase:
				la a0, column_in_ascending_order
				li a7, 4
				ecall
				
				mv a0, a5
				li a7, 1
				ecall
				
				la a0, newline_symbol
				li a7, 4
				ecall
				
				la a0, min_element_column
				li a7, 4
				ecall
				
				mv a0, s10
				li a7, 1
				ecall
				
				la a0, newline_symbol
				li a7, 4
				ecall
				
				la a0, max_element_column
				li a7, 4
				ecall
				
				mv a0, s9
				li a7, 1
				ecall
				
				la a0, newline_symbol
				li a7, 4
				ecall
				
				la a0, newline_symbol
				li a7, 4
				ecall
				
				j _end_columns_loop_spec
				
			_found_decrease:
				la a0, column_in_descending_order
				li a7, 4
				ecall
				
				mv a0, a5
				li a7, 1
				ecall
				
				la a0, newline_symbol
				li a7, 4
				ecall
				
				la a0, min_element_column
				li a7, 4
				ecall
				
				mv a0, s9
				li a7, 1
				ecall
				
				la a0, newline_symbol
				li a7, 4
				ecall
				
				la a0, max_element_column
				li a7, 4
				ecall
				
				mv a0, s10
				li a7, 1
				ecall
				
				la a0, newline_symbol
				li a7, 4
				ecall
							
				la a0, newline_symbol
				li a7, 4
				ecall		
					
			_end_columns_loop_spec:			
				addi a5, a5, 1
				li s11, 0
				
				la t1, matrix
				addi t1, t1, 8
				addi t5, t5, 4
				add t1, t1, t5
				
				j find_columns_loop
		
		_end_find:

	# Выход
	li a7, 10
	ecall
