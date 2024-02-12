global main

extern scanf 
extern printf
extern exit

section .data
		
		math_message_first   db  "This part calculates Z = (XY - 1)/(X + Y):", 10, 0
		math_message_second  db  "This part calculates Z = X^3 + Y - 1:", 10, 0 
		math_message_third   db  "This part calculates Z = (XY + 1)/X^2:", 10, 0
		math_message_fourth  db  "This part calculates Z = (X + Y)/(X - Y):", 10, 0
		math_message_fifth   db  "This part calculates Z = - 1/X^3 + 3:", 10, 0
		input                db  "%d", 0
		z_message            db  "Result: Z = %d", 10, 0
		enter_message_x      db  "Enter: X = ", 0
		enter_message_format dd  "%s", 10, 0
		enter_message_y      db  "Enter: Y = ", 0
		error_message        db  "Division by zero occurred, exit the program...", 10, 0
		residual_message     db  "Residual: %d/%d", 10, 0
		number               dd  0
															 
																				   
section .bss
		numX            resb     4
		numY            resb     4
		result          resb     4
		residual        resb     4
		divider         resb     4


section .text

main:							   
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

first_exercise:			push math_message_first
						push enter_message_format
						call printf

						mov eax, [numX]
						mov ebx, [numY]
						
						mov ecx, eax
						imul ebx
						dec eax

						add ebx, ecx

						test ebx, ebx

						jz division_by_zero
						
						mov [divider], ebx

						idiv ebx

						mov [residual], edx
				 			
  						mov [result], eax
                        push dword [result]           ; положить на стек число
                        push z_message       		  ; положить на стек адрес строки формата
                        call printf                   ; вызвать printf

                        cmp dword [residual], 0
                        jz second_exercise

                        mov edx, [divider]
                        
						cmp edx, 0
						jl .neg_divider
						jmp end_of_first_exercise

.neg_divider:			neg edx

end_of_first_exercise:  mov [result], edx

                        push dword [result]

                        mov edx, [residual]
                        mov [result], edx

                        push dword [result]

                        push residual_message
                        call printf

second_exercise:        push math_message_second
						push enter_message_format
						call printf

						mov eax, [numX]
						mov ebx, [numY]

						mov ecx, eax

						mul eax
						mul ecx

						add eax, ebx
						dec eax

						mov [result], eax
						push dword [result]
						push z_message
						call printf

third_exercise:			push math_message_third
						push enter_message_format
						call printf

						mov eax, [numX]
						mov ebx, [numY]

						mov ecx, eax
						imul ebx   
						inc eax

						push eax

						mov eax, [numX]
						imul eax

						test eax, eax

						jz division_by_zero
						
						mov [divider], eax

						mov ebx, eax

						pop eax

						cdq

						idiv ebx
						mov [residual], edx
				 			
  						mov [result], eax
                        push dword [result]           ; положить на стек число
                        push z_message       		  ; положить на стек адрес строки формата
                        call printf                   ; вызвать printf

                        cmp dword [residual], 0
                        jz second_exercise

                        mov edx, [divider]
                        mov [result], edx

                        push dword [result]

                        mov edx, [residual]
                        mov [result], edx

                        push dword [result]

                        push residual_message
                        call printf

fourth_exercise:		push math_message_fourth
						push enter_message_format
						call printf

						mov eax, [numX]
						mov ebx, [numY]

						sub eax, ebx

						test eax, eax
						jz division_by_zero

						mov [divider], eax

						mov eax, [numX]
						add eax, ebx

						cdq
						idiv dword [divider]
				
						mov [residual], edx
				 			
  						mov [result], eax
                        push dword [result]           ; положить на стек число
                        push z_message       		  ; положить на стек адрес строки формата
                        call printf                   ; вызвать printf

                        cmp dword [residual], 0
                        jz fifth_exercise

                        mov edx, [divider]
                        
                        cmp edx, 0
                        jl .neg_divider
                        jmp end_of_fourth_exercise

.neg_divider:			neg edx

end_of_fourth_exercise: mov [result], edx

                        push dword [result]

                        mov edx, [residual]
                        mov [result], edx

                        push dword [result]

                        push residual_message
                        call printf

fifth_exercise:			push math_message_fifth
						push enter_message_format
						call printf

						mov eax, [numX]

						mov ecx, eax
						imul eax	
						imul ecx

						test eax, eax
						jz division_by_zero

						mov [divider], eax

						mov ebx, 3
						imul ebx
						dec eax

						idiv dword [divider]

						mov dword [residual], edx
				 			
  						mov [result], eax
                        push dword [result]           ; положить на стек число
                        push z_message       		  ; положить на стек адрес строки формата
                        call printf                   ; вызвать printf
                        	
                        cmp dword [residual], 0
                        jz end_of_program

                        mov edx, [divider]

                        cmp edx, 0
						jl .neg_divider
						jmp end_of_fifth_exercise

.neg_divider:           neg edx

end_of_fifth_exercise:  mov [result], edx

                        push dword [result]

                        mov edx, [residual]
                        mov [result], edx

                        push dword [result]

                        push residual_message
                        call printf

                       	jmp end_of_program
                               

end_of_program:			push 1
                        call exit

division_by_zero:       push error_message
						push enter_message_format
						call printf

						jmp end_of_program
