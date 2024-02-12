global _start


section .data
		
		math_message         db  "This program calculates Z = (XY - 1)/(X + Y):", 0xa, 0xd
		math_message_len     equ $-math_message
		z_message            db  "Result: Z = "
		z_message_len        equ $-z_message
		enter_message_x      db  "Enter: X = "
		enter_message_x_len  equ $-enter_message_x
		enter_message_y      db  "Enter: Y = "
		enter_message_y_len  equ $-enter_message_y
		numberX 	 	     dd  -2 
		numberY			     dd  4
		buffer               db  '0'         
															 

section .bss
		num             resb     5


section .text
 
		_start:
					   	mov eax, 4
						mov ebx, 1
						mov ecx, math_message
						mov edx, math_message_len

						int 80h	

						mov eax, 4
						mov ebx, 1
						mov ecx, enter_message_x
						mov edx, enter_message_x_len

						int 80h 

						mov eax, 3
						mov ebx, 0
						mov ecx, num
						mov edx, 5
						
						int 80h

						mov ecx, num
						call atoi

						push eax

						mov eax, 4
						mov ebx, 1
						mov ecx, enter_message_y
						mov edx, enter_message_y_len

						int 80h

						mov eax, 3
						mov ebx, 0
						mov ecx, num
						mov edx, 5

						int 80h

						mov ecx, num
						call atoi

						mov ebx, eax
						pop eax



						mov ecx, eax

						imul ebx

						dec eax

						add ebx, ecx

						idiv ebx

						push eax           ; запоминаем eax

						mov eax, 4
						mov ebx, 1
						mov ecx, z_message
						mov edx, z_message_len

						int 80h

						pop eax
				 		
						add al, '0'
						mov [buffer], al

						mov ecx, buffer
						mov edx, 1
						mov ebx, 1         ; стандартный вывод
						mov eax, 4         ; вызов write
											   
  						int 80h

  						mov eax, 1
  						mov ebx, 0

  						int 80h	

atoi:                 
						xor eax, eax
						xor ebx, ebx
						xor edx, edx
						cmp byte [ecx], '-'
						jne positive
						inc ecx
						mov edx, 1

positive:               
						mov bl,  [ecx]
						inc ecx
                        cmp bl, 10 ; проверка на символ новой строки
						je done
						sub bl, '0'
						imul eax, eax, 10
						add eax, ebx
						jmp positive 
done:                   
						test edx, edx
						jz return
						neg eax

return:
						ret
