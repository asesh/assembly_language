.686
.model flat, stdcall
option casemap:none

include asesh.inc

.data
    szWindowTitle db "Asesh", 0h

SData struct

    dwNumber dd ?

SData ends

.code

start:

    push offset szWindowTitle
    call SetConsoleTitle
    push 14h
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

main proc dwNumber1:DWORD

    local dwNumber:DWORD, data:SData
    mov data.dwNumber, 5h
    print str$(data.dwNumber)
    ret

main endp

end start