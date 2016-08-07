.386
.model flat, stdcall
option casemap:none

include std.inc

.const
    dwNumber dd 12h
    szAlphabets db 41h, 42h, 43h, 44h, 45h, 46h, 47h, 48h, 49h, 4Ah, 4Bh
                db 4Ch, 4Dh, 4Eh, 4Fh, 50h, 51h, 52h, 53h, 54h, 55h, 56h
                db 57h, 58h, 59h, 5Ah
                db 61h, 62h, 63h, 64h, 65h, 66h, 67h, 68h, 69h, 6Ah, 6Bh
                db 6Ch, 6Dh, 6Eh, 6Fh, 70h, 71h, 72h, 73h, 74h, 75h, 76h
                db 77h, 78h, 79h, 7Ah
    szWindowTitle db "Asesh", 0h

.code

start:

    push ebp
    mov ebp, esp
    call main

mainLoop:
    push 01Bh
    call GetAsyncKeyState
    test eax, eax
    jne exitMainLoop
    push 064h
    call Sleep
    jmp mainLoop

exitMainLoop:
    leave
    ret

main proc

    push ebp
    mov ebp, esp
    sub esp, 4h
    mov dword ptr [ebp-4h], 2h
    mov eax, 4h
    div dword ptr [ebp - 4h]
    leave
    ret

main endp

end start