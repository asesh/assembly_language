.386
.model flat, stdcall
option casemap:none

include std.inc

.data

    Shellcode1 db 55h, 89h, 0e5h, 83h, 0ech, 18h, 0c7h, 45h, 0fch, 53h, 8ah, 83h, 7ch, 0c7h, 44h, 24h, 04h,
                    0d0h, 03h, 00h, 00h, 0c7h, 04h, 24h, 01h, 00eh, 00h, 00h, 8bh, 45h, 0fch, 0ffh, 0d0h, 0c9h,
                    33h, 0c0h, 0c3h

    Shellcode2 db 55h, 8bh, 0ech, 68h, 00h, 10h, 00h, 00h, 0b8h, 42h, 24h, 80h, 7ch, 0ffh,
                    0d0h, 0c9h, 33h, 0c0h, 0c3h

    Shellcode3 db 55h, 8bh, 0ech, 68h, 00h, 10h, 00h, 00h, 0e8h, 42h, 24h, 80h, 7ch, 0c9h, 33h, 0c0h, 0c3h

    Shellcode4 db 64h, 0a1h, 24h, 00h, 00h, 00h, 0c3h

    ShellBugExploit db 55h

.code

start:

    call main

mainLoop:
    push 01Bh
    call GetAsyncKeyState
    test eax, eax
    jne exitMainLoop
    push 64h
    call Sleep
    jmp mainLoop

exitMainLoop:
    ret

main proc

    push ebp
    mov ebp, esp
    lea eax, Shellcode4
    call eax
    print str$(eax)
    print chr$(0ah, "Using API: ")
    call GetCurrentThreadId
    print str$(eax)
    leave
    xor eax, eax

    ret

main endp

end start