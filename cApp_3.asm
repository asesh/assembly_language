.686
.model flat, stdcall
option casemap:none

include std.inc

ShellCodeSeg segment

    db 55h, 8bh, 0ech, 0c9h, 33h, 0c0h, 0c3h
    szBuffer db 66h

ShellCodeSeg ends

.data
    szTitle db "Asesh", 0h
    szData db "Genius programmer, hacker, 3d modeler, graphics designer and...", 0h

.code

start:

    push ebp
    mov ebp, esp
    push offset szTitle
    call SetConsoleTitle
    call main

mainLoop:
    push 1Bh
    call GetAsyncKeyState
    test eax, eax
    jne exitMainLoop
    push 64h
    call Sleep
    jmp mainLoop

exitMainLoop:
    leave
    ret

main proc

    ret

main endp

end start