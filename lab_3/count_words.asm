global main
extern scanf, printf, exit

section .data
    input_message db "Enter the string: ", 0
    output_format dd "%s", 10, 0
    input_format db "%c", 0 ; формат для scanf
    result db "Word count: %d, average word length: %.2f", 10, 0 ; формат для printf
    
section .bss
    character resd 1    
    count     resd 1
    
section .text
  
main:
    mov ebp, esp; for correct debugging

    push input_message
    push output_format
    call printf
    add esp, 8

    ; подготовить регистры для подсчета слов и букв
    xor ecx, ecx ; ecx хранит количество слов
    xor edx, edx ; edx хранит количество букв
    mov al, ' ' ; al хранит символ пробела
    mov ebx, 1 ; ebx хранит флаг, равный 1, если текущий символ не пробел, иначе 0

    ; цикл по символам строки
count_loop:
    push eax
    push ecx
    push edx
    push ebx

    push character
    push input_format
    call scanf
    add esp, 8
    
    pop ebx
    pop edx
    pop ecx
    
    cmp eax, 0
    jl count_done
    pop eax        
                
    mov eax, [character]
    
    cmp eax, 0 ; сравнить символ с нулем
    je count_done ; если ноль, то конец строки, выйти из цикла
    cmp eax, 10
    je count_loop
    cmp eax, ' ' ; сравнить символ с пробелом
    je is_space ; если пробел, то перейти к обработке пробела
    inc edx ; если не пробел, то увеличить количество букв
    test ebx, ebx ; проверить флаг
    jnz count_loop ; если флаг равен 1, то продолжить цикл
    
    cmp edx, 1
    je .skip_inc
    
    inc ecx ; если флаг равен 0, то увеличить количество слов
    
.skip_inc:    
    mov ebx, 1 ; установить флаг в 1
    jmp count_loop ; продолжить 
is_space:
    mov ebx, 0 ; установить флаг в 0
    jmp count_loop ; продолжить цикл

    ; подсчет завершен, вычислить среднюю длину слова
count_done:
    
    cmp edx, 0
    jz .skip_inc
    inc ecx

.skip_inc:        
    test ecx, ecx ; проверить количество слов
    jz print_zero ; если равно 0, то перейти к выводу 0

    mov [count], edx
    fld dword [count]
    mov [count], ecx
    fdiv dword [count]
    
    sub esp, 8
    fstp qword [esp]

    push ecx
            
    push result
    
    call printf ; вызвать printf
    add esp, 16 ; очистить стек
    jmp exit_main ; выйти из программы
    
    
print_zero:
    ; вывести 0 на экран
    push 0 ; положить 0 на стек
    push 0 ; положить 0 на стек
    push result ; положить адрес формата на стек
    call printf ; вызвать printf
    add esp, 12 ; очистить стек
exit_main:
    ; выйти из программы
    push 0 ; положить код возврата на стек
    call exit ; вызвать exit
