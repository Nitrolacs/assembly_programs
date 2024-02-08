global _start


section .data
		
		math_message      db  "This program calculates Z = (XY - 1)/(X + Y):", 0xa, 0xd
		math_message_len  equ $-math_message
		z_message         db  "Result: Z = "
		z_message_len     equ $-z_message
		numberX 	 	  dd  2 
		numberY			  dd  4
		buffer            db  '0'         
															 

section .text
 
		_start:
					   	mov eax, 4
						mov ebx, 1
						mov ecx, math_message
						mov edx, math_message_len

						int 80h	

	  					xor eax, eax
						xor ebx, ebx

						mov eax, [numberX]
						mov ecx, eax
						mov ebx, [numberY]
						mul ebx

						dec eax

						add ebx, ecx

						div ebx

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