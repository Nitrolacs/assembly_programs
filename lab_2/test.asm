section .data
    X dd 0.0
    A dd 0.0
    Y dd 0.0
    Y1 dd 0.0
    Y2 dd 0.0
    Four dd 4.0
    Seven dd 7.0
    Two dd 2.0
    i dd 0
    format db "%f", 0
    format_output db "Y = %f", 10, 0

section .text
    extern printf
    extern scanf
    extern exit
    global main
main:
    ; Ввод X
    push X
    push format
    call scanf
    add esp, 8

    ; Ввод A
    push A
    push format
    call scanf
    add esp, 8

    mov ecx, 10 ; цикл от 0 до 9
    loop_start:
        fld dword [X] ; загрузить X в стек FPU
        fadd dword [i] ; прибавить i к X
        fld dword [Four]
        fcomi st0, st1 ; сравнить X и 4
        jbe calculate_y1_less_equal ; если X <= 4, перейти к calculate_y1_less_equal
        fsub dword [A] ; иначе вычесть A из X
        jmp calculate_y2 ; перейти к calculate_y2
    calculate_y1_less_equal:
        fmul dword [Four] ; умножить X на 4
    calculate_y2:
        fstp dword [Y1] ; сохранить результат в Y1 и очистить стек
        fld dword [X] ; загрузить X в стек FPU
        fild dword [i] ; загрузить i в стек FPU
        faddp st1 ; прибавить i к X
        fistp dword [X] ; сохранить результат в X и очистить стек
        mov eax, dword [X]
        and eax, 1 ; проверить, является ли X нечетным
        jnz y2_is_seven ; если X нечетное, перейти к y2_is_seven
        fdiv dword [Two] ; иначе поделить X на 2
        fadd dword [A] ; прибавить A
        jmp end_y2 ; перейти к end_y2
    y2_is_seven:
        fld dword [Seven] ; загрузить 7 в стек FPU
    end_y2:
        fstp dword [Y2] ; сохранить результат в Y2 и очистить стек
        fld dword [Y1] ; загрузить Y1 в стек FPU
        fadd dword [Y2] ; прибавить Y2
        fstp dword [Y] ; сохранить результат в Y и очистить стек

        ; Вывод Y
        push dword [Y]
        push format_output
        call printf
        add esp, 8

        inc dword [i] ; увеличить i на 1
        loop loop_start

    ; Завершение программы
    push 0
    call exit
