.686
.model flat, stdcall
option casemap:none

include asesh.inc

.data
    szTitle db "Asesh", 0h

.data?
    dwNumb1 dd ?
    
.code

start:

    push offset szTitle
    call SetConsoleTitle
    call main

mainLoop:
    push 01Bh
    call GetAsyncKeyState
    cmp eax, 0h
    jne exitMainLoop
    push 064h
    call Sleep
    jmp mainLoop

exitMainLoop:
    ret

main proc

comment/push ebp
    mov ebp, esp
    sub esp, 0FFh
    mov dword ptr [ebp - 4h], offset szTitle
    mov eax, [ebp - 4h]
    print str$(eax)
    add esp, 0FFh
    mov esp, ebp
    pop ebp /

    comment /local dwNumber1:DWORD, dwNumber2:DWORD, dwNumber3:DWORD
    call GetCurrentThreadId
    print str$(eax)
    print chr$(0Ah)
    call GetCurrentProcessId
    print str$(eax) /


    local dwNumber:DWORD
    lea eax, dwNumber
    mov eax, 5h
    print str$(dwNumber)
    ret

main endp

end start