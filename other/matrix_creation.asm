.data
	new_file: .asciz "new_matrix.bin"
	matrix_rows:
			.word 5
			.word 1, 2, 3, 4, 5
			.word 6, 7, 8, 9, 10
			.word 11, 12, 13, 14, 15
			.word 16, 17, 18, 19, 20
			.word 21, 22, 23, 24, 25

.global _start
		
.text
_start:
	# Открываем файл для записи
	la a0, new_file
	li a1, 1
	li a7, 1024
	ecall
	mv s6, a0
	
	# Записываем значения в файл
	la a1, matrix_rows
	li a2, 120
	li a7, 64
	ecall
	
	# Закрываем файл
	li a7, 57
	ecall
	
	# Выходим из программы
	li a7, 10
	ecall

