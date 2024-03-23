.global _start

.data
	filename: .asciz "matrix.bin"
	matrix_values:
			.word 3, 4 	
			.word -22, 9, 17, 10
			.word -10, 5, 43, 99
			.word 55, 3, -10, -16
	
.text
_start:
	# Открываем файл для записи
	la a0, filename
	li a1, 1
	li a7, 1024
	ecall
	mv s6, a0
	
	# Записываем значения в файл
	la a1, matrix_values
	li a2, 56
	li a7, 64
	ecall
	
	# Закрываем файл
	li a7, 57
	ecall
	
	# Выход
	li a7, 10
	ecall

