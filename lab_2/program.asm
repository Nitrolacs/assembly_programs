global main

extern scanf
extern printf
extern exit

section .data          
	input 	               db  "%f", 0
	enter_message_x        db  "Enter: x = ", 0
	enter_message_a        db  "Enter: a = ", 0
	enter_message_format   dd  "%s", 10, 0
	output_message_format  db  "y = %f", 10, 0
	numI                   dd  0
	Seven                  dd  7.0
	Four                   dd  4.0
	Two                    dd  2.0
	One                    dd  1.0

section .bss
	numX				   resd    1      
	numA                   resd    1
	numY                   resd    1
	numY1                  resd    1
	numY2                  resd    1
	counter                resd    1

; Задание.
; Разработать программу на Ассемблере, реализующую вычисление
; Y для заданных пользователем X и A.
; Выполните упражнение из ниже приведенного списка, выбирая
;  вариант соответственно номеру студента в группе.
; А остается заданной пользователем, Х меняется в цикле как Х+i,
; i меняется от 0 до 9 с шагом 1.
; Программа должна работать с числами с плавающей точкой,
; рекомендуется использовать функции FPU.
; Вариант 8.
; y = y1 + y2; y1 = {4*x, если x<=4; y2 = {7, если x нечетно.
;                   {x-a, если x>4 ; y2 = {x/2+a в остальных случаях.


section .text
	
main:
	push enter_message_x
	push enter_message_format
	call printf

	push numX
	push input
	call scanf

	push enter_message_a
	push enter_message_format
	call printf

	push numA
	push input
	call scanf

	mov ecx, 10 ; цикл от 0 до 9

	loop_start:
		mov [counter], ecx
		
		fld  dword [Four]
		fld  dword [numX]
		fadd dword [numI]
		fcomi st0, st1   ; сравниваем x и 4
		jbe calculate_y1_less_equal  ; если x <= 4, то переходим к соотв. метке
		fsub dword [numA] ; иначе мы вычитаем a из x
		jmp calculate_y2  ; переходим к вычислению y2

	calculate_y1_less_equal:
		fmul dword [Four] ; умножаем x на 4

	calculate_y2:
		fstp dword [numY1]

		;finit
		fld dword [numX]
		fadd dword [numI]
		fistp dword [numX]
		mov eax, dword [numX]
		and eax, 1
		jnz y2_is_seven
		fdiv dword [Two]
		fadd dword [numA]
		jmp end_y2

	y2_is_seven:
		fld dword [Seven]	

	end_y2:
		fstp dword [numY2]
		fld dword [numY1]
		fadd dword [numY2]
		fstp dword [numY]

	fld dword [numY]
		
	sub esp, 8
	fstp qword [esp]

	push output_message_format
	call printf
	add esp, 12

	fld dword [One]
	fadd dword [numI]
	fstp dword [numI]
                
	mov ecx, [counter]
	;loop loop_start

	push 0
	call exit	
