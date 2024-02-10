global main                           

extern scanf 
extern printf
extern exit

section .data
		
		math_message         db  "This program calculates Z = (XY - 1)/(X + Y):", 10, 0
		input                db  "%d", 0
		z_message            db  "Result: Z = %d", 10, 0
		enter_message_x      db  "Enter: X = ", 0
		enter_message_format dd  "%s", 10, 0
		enter_message_y      db  "Enter: Y = "
		enter_message_y_len  equ $-enter_message_y
		number               dd  0
															 
																				   
section .bss
		num             resb     4
		result          resb     4


section .text

main:							   
						push math_message
						push enter_message_format
						call printf

						push enter_message_x
						push enter_message_format
						call printf

						push num
						push input
						call scanf 

						mov eax, num

						push enter_message_y
						push enter_message_format
						call printf

						push num
						push input
						call scanf

						mov ebx, num
						mov ecx, eax
						imul ebx
						dec eax
						add ebx, ecx
						idiv ebx
				 		
  						mov [num], eax
                        push dword [num]           ; положить на стек число
                        push z_message        ; положить на стек адрес строки формата
                        call printf        ; вызвать printf

                        push 1
                        call exit
