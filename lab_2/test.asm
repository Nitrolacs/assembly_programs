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
	numI                   dd  0.0
	Four                   dd  4.0
	One                    dd  1.0

section .bss
	numX				   resd    1      
	numA                   resd    1
	numY1                  resd    1
	numY2                  resd    1
	counter                resd    1

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
		fstp st0         ; очищаем стек
		jbe calculate_y1_less_equal  ; если x <= 4, то переходим к соотв. метке
		fsub dword [numA] ; иначе мы вычитаем a из x
		jmp calculate_y2  ; переходим к вычислению y2

	calculate_y1_less_equal:
		fmul dword [Four] ; умножаем x на 4

	calculate_y2:
		
	sub esp, 8
	fstp qword [esp]

	push output_message_format
	call printf
	add esp, 12

	mov eax, [One]
break_point:	add [numI], eax

	mov ecx, [counter]
	loop loop_start

	push 0
	call exit	
