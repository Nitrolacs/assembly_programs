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
	numI                   dd  1.0

section .bss
	numX				   resd    1      
	numA                   resd    1

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

	sub esp, 8
	fld  dword [numX]
	fadd dword [numI]

	fstp qword [esp]

	push output_message_format
	call printf

	add esp, 12

	push 0
	call exit	
