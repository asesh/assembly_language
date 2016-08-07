.386
.model flat, stdcall
option casemap:none

include std.inc

.data

    msg db "Asesh"

.data?

    dwTickCount dd ?

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
    xor eax, eax
    ret

main proc

    push ebp
    mov ebp, esp
    mov eax, 0ffffffh
    mov al, byte ptr ds:[40000h]
    leave
    xor eax, eax
    ret

main endp

end start