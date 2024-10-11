format PE console   ;Консольний тип програми

entry Start  ;Точка входу у програму

include 'win32a.inc'  ; Підключення

section '.data' data readable writeable  ; Секція з проініціалізованими даними
    strA db 'Enter A: ', 0  ; з допомогою db оголошуємо дані дефайн байт  strA це мітка яка при компіляції
                             ;замінюється вказівником на дані а вказівник містить адрес на дані у пам'яті
    strB db 'Enter B: ', 0
    strOp db 'Enter operation (+, -, *, /, %): ', 0

    resStr db 'Result: %d', 0
    resMod db '/%d', 0

    spaceStr db ' %d', 0
    emptyStr db '%d', 0

    infinity db 'infinity', 0
    point db ',', 0

    A dd ?  ; Дані з розміром 4 байта
    B dd ?
    C dd ?
    NULL = 0


section '.code' code readable executable ; Секція у якій розміщується мітка старт
                                         ; Для цієї програми виділяється область оперативної пам'яті яка називається стеком
                                         ; відповідно буде використовуватись принцип LIFO
Start:
    ; Введення числа A
    push strA       ; заносимо в стек з допомогою команди push
    call [printf]   ; а функцію викликаємо з допомогою команди call

    push A
    push spaceStr
    call [scanf]

    ; Введення числа B
    push strB
    call [printf]

    push B
    push spaceStr
    call [scanf]

    ; Введення операції
    push strOp
    call [printf]

    call [getch]  ; зчитування операції з клавіатури
    mov dl, al    ; зберігаємо введений символ в dl

    ; Операція додавання
    cmp dl, '+'  ;  cmp порівнює два операнди
    jne notAdd   ;  Якщо не сходиться то переходимо до мітк иnotAdd з допомогою jne
        mov eax, [A] ; В квадратних дужках бо ми звертаємось до даних які зберігаються по адресу а не до адресу
        add eax, [B]

        push eax
        push resStr
        call [printf]

        jmp finish ; Закінчення програми через мітку

notAdd:
    ; Операція віднімання
    cmp dl, '-'
    jne notSub
        mov eax, [A]
        sub eax, [B]

        push eax
        push resStr
        call [printf]

        jmp finish

notSub:
    ; Операція множення
    cmp dl, '*'
    jne notMul
        mov eax, [A]
        imul eax, [B]

        push eax
        push resStr
        call [printf]

        jmp finish

notMul:
    ; Операція ділення по модулю
    cmp dl, '%'
    jne notMod
        mov eax, [A]
        xor edx, edx  ; обнуляємо edx перед діленням
        div dword [B]

        push edx
        push resStr
        call [printf]

        jmp finish

notMod:
    ; Операція ділення
    cmp dl, '/'
    jne notDiv
        mov eax, [A]
        xor edx, edx  ; обнуляємо edx перед діленням

        cmp dword [B], 0
        je divByZero

        div dword [B]

        push eax
        push resStr
        call [printf]

        ;Виведення дробової частини
        push point
        call [printf]

        mov ebx, 0
        lp:
         mov eax, [C]
         mov ecx, [B]
         imul eax, 10

         mov edx, 0
         div ecx
         mov[C],edx

         push eax
         push emptyStr
         call [printf]

         add ebx, 1
         cmp ebx, 3
         jne lp

        jmp finish

    divByZero:
        push infinity
        call [printf]
        jmp finish

notDiv:

finish:
    ; Завершення програми
    call [getch]
    push NULL
    call [ExitProcess]

section '.idata' import data readable

    library kernel32, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll'

    import kernel32,\
           ExitProcess, 'ExitProcess'

    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'
