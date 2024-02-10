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
		numX            resb     4
		numY            resb     4
		result          resb     4


section .text

main:							   
						push math_message
						push enter_message_format
						call printf

						push enter_message_x
						push enter_message_format
						call printf

						push numX
						push input
						call scanf 

						push enter_message_y
						push enter_message_format
						call printf

						push numY
						push input
						call scanf

						mov eax, [numX]
						mov ebx, [numY]
						
						mov ecx, eax
						imul ebx
						dec eax
						add ebx, ecx
						idiv ebx
				 		
  						mov [result], eax
                        push dword [result]           ; положить на стек число
                        push z_message        ; положить на стек адрес строки формата
                        call printf        ; вызвать printf

                        push 1
                        call exit
