extern scanf, printf, exit

section .data
    struc Ticket
        .Destination: resb 50
        .Departure:   resb 50
        .Date:        resb 10
        .Cost:        resb 4
    endstruc

    filename dd './input.txt', 0
    newfilename dd './output.txt', 0
	start_message db "Read from file:", 10, 0
	end_message db "Write to new file:", 10, 0
	output_format dd "%s", 10, 0
	read_ticket db "Destination: %s, departure: %s, date: %s, cost: %s", 10, 0
	read_ticket_2 db "Destination: %s, departure: %s, date: %s, cost: %d", 10, 0
section .bss
	tickets: resb Ticket_size * 3
	buffer: resb 4

section .text
    global main

main:
    mov ebp, esp; for correct debugging
    ; Ticket_size

    push start_message
    push output_format
    call printf
    add esp, 8

    ; Открыть файл для чтения
    mov eax, 5 ; sys_open
    lea ebx, filename
    mov ecx, 0 ; O_RDONLY
    int 80h

    ; Сохранить дескриптор файла
    mov esi, eax

    ; Прочитать данные из файла в структуры
    mov edi, tickets
    mov ecx, 3
read_loop:
    push ecx

    mov eax, 3 ; sys_read
    mov ebx, esi
    lea ecx, [edi]
    mov edx, Ticket_size
    int 0x80

	; Вывод значений полей структуры
    ;mov eax, 4 ; Количество аргументов для printf
    lea eax, [edi + Ticket.Cost] ; Стоимость
    push eax
    lea eax, [edi + Ticket.Date] ; Дата
    push eax
    lea eax, [edi + Ticket.Departure] ; Пункт вылета
    push eax
    lea eax, [edi + Ticket.Destination] ; Пункт назначения
    push eax
    push read_ticket ; Формат строки
    call printf
    add esp, 20 ; Очистка стека

	add edi, Ticket_size

    pop ecx
    loop read_loop
    
    ; Закрыть файл
    mov eax, 6 ; sys_close
    mov ebx, esi
    int 0x80


	push end_message
	push output_format
	call printf
	add esp, 8

    ; Открыть новый файл для записи
    mov eax, 5 ; sys_open
    lea ebx, newfilename
    mov ecx, 101o ; O_WRONLY | O_CREAT
    mov edx, 700o ; rw-rw-rw-
    int 0x80

    ; Сохранить дескриптор нового файла
    mov esi, eax

    ; Изменить стоимость билетов и записать данные в новый файл
    mov edi, tickets
    mov ecx, 3
write_loop:
    push ecx


	lea eax, [edi + Ticket.Cost]
	mov edx, eax
result_atoi:
	xor eax, eax ; zero a "result so far"
.top:
	movzx ecx, byte [edx] ; get a character
	inc edx ; ready for next one
	cmp ecx, '0' ; valid?
	jb .done
	cmp ecx, '9'
	ja .done
	sub ecx, '0' ; "convert" character to number
	imul eax, 10 ; multiply "result so far" by ten
	add eax, ecx ; add in current digit
	jmp .top ; until done
.done:
	add eax, 99

	push eax
	lea eax, [edi + Ticket.Date] ; Дата
    push eax
    lea eax, [edi + Ticket.Departure] ; Пункт вылета
    push eax
    lea eax, [edi + Ticket.Destination] ; Пункт назначения
    push eax
    push read_ticket_2 ; Формат строки
    call printf
    add esp, 20 ; Очистка стека
    	
				
    ; Записать данные в файл
    mov eax, 4 ; sys_write
    mov ebx, esi
    lea ecx, [edi]
    mov edx, Ticket_size
    int 0x80

    add edi, Ticket_size

    pop ecx
    loop write_loop

    ; Закрыть новый файл
    mov eax, 6 ; sys_close
    mov ebx, esi
    int 0x80

    ; Завершить программу
    push 0
    call exit
