.686
.model flat, stdcall
option casemap:none

include std.inc

MAX_PATH EQU 104h

.data

    szTitle db "Asesh", 0h

    szShellCode db 83h, 0ech, 10h, 0a1h, 038h, 60h, 40h, 00h, 33h, 44h, 24h, 10h

.code

start:

    push OFFSET szTitle
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

    mov eax, 0ffffh
    mov ecx, 0cch
    mov eax, ecx
    xor eax, eax
    ret

main endp

end start