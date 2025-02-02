format PE console   ;���������� ��� ��������

entry Start  ;����� ����� � ��������

include 'win32a.inc'  ; ϳ���������

section '.data' data readable writeable  ; ������ � ����������������� ������
    strA db 'Enter A: ', 0  ; � ��������� db ��������� ���� ������ ����  strA �� ���� ��� ��� ���������
                             ;���������� ���������� �� ���� � �������� ������ ����� �� ���� � ���'��
    strB db 'Enter B: ', 0
    strOp db 'Enter operation (+, -, *, /, %): ', 0

    resStr db 'Result: %d', 0
    resMod db '/%d', 0

    spaceStr db ' %d', 0
    emptyStr db '%d', 0

    infinity db 'infinity', 0
    point db ',', 0

    A dd ?  ; ���� � ������� 4 �����
    B dd ?
    C dd ?
    NULL = 0


section '.code' code readable executable ; ������ � ��� ���������� ���� �����
                                         ; ��� ���� �������� ���������� ������� ���������� ���'�� ��� ���������� ������
                                         ; �������� ���� ����������������� ������� LIFO
Start:
    ; �������� ����� A
    push strA       ; �������� � ���� � ��������� ������� push
    call [printf]   ; � ������� ��������� � ��������� ������� call

    push A
    push spaceStr
    call [scanf]

    ; �������� ����� B
    push strB
    call [printf]

    push B
    push spaceStr
    call [scanf]

    ; �������� ��������
    push strOp
    call [printf]

    call [getch]  ; ���������� �������� � ���������
    mov dl, al    ; �������� �������� ������ � dl

    ; �������� ���������
    cmp dl, '+'  ;  cmp ������� ��� ��������
    jne notAdd   ;  ���� �� ��������� �� ���������� �� ��� �notAdd � ��������� jne
        mov eax, [A] ; � ���������� ������ �� �� ���������� �� ����� �� ����������� �� ������ � �� �� ������
        add eax, [B]

        push eax
        push resStr
        call [printf]

        jmp finish ; ��������� �������� ����� ����

notAdd:
    ; �������� ���������
    cmp dl, '-'
    jne notSub
        mov eax, [A]
        sub eax, [B]

        push eax
        push resStr
        call [printf]

        jmp finish

notSub:
    ; �������� ��������
    cmp dl, '*'
    jne notMul
        mov eax, [A]
        imul eax, [B]

        push eax
        push resStr
        call [printf]

        jmp finish

notMul:
    ; �������� ������ �� ������
    cmp dl, '%'
    jne notMod
        mov eax, [A]
        xor edx, edx  ; ��������� edx ����� �������
        div dword [B]

        push edx
        push resStr
        call [printf]

        jmp finish

notMod:
    ; �������� ������
    cmp dl, '/'
    jne notDiv
        mov eax, [A]
        xor edx, edx  ; ��������� edx ����� �������

        cmp dword [B], 0
        je divByZero

        div dword [B]

        push eax
        push resStr
        call [printf]

        ;��������� ������� �������
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
    ; ���������� ��������
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
