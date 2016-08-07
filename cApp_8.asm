.486
.model flat, stdcall
option casemap:none

include std.inc

.data
    szWindowTitle db "Asesh", 0h
    
    Shellcode1 db 6ah, 08h, 68h, 58h, 0c7h, 80h, 7ch, 0e8h, 96h, 5dh, 0ffh, 0ffh, 83h, 65h, 0fch, 00h, 8bh,
                  4dh, 00ch, 8bh, 55h, 08h, 8ah, 01h, 88h, 02h, 41h, 42h, 84h, 0c0h, 75h, 0f6h, 83h, 4dh, 0fch,
                  0ffh, 8bh, 45h, 08h, 0e8h, 0b6h, 5dh, 0ffh, 0ffh, 0c2h, 08h, 00h

    Shellcode2 db 6ah, 08h, 6ah, 08h, 6ah, 08h, 6ah, 08h, 6ah, 08h, 6ah, 08h, 6ah, 08h, 6ah, 08h

    Shellcode3 db 64h, 0a1h, 08h, 00h, 00h, 00h, 0c3h

    Shellcode4 db 55h, 8bh, 0ech, 0c9h, 33h, 0c0h, 0c3h

.code

start:

    push ebp
    mov ebp, esp
    push offset szWindowTitle
    call SetConsoleTitle
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
    xor eax, eax
    leave
    ret

main proc

    push ebp
    mov ebp, esp
    lea eax, offset Shellcode3
    call eax
    print str$(eax)
    leave
    ret

main endp

end start