.686
.model flat, stdcall
option casemap:none

include asesh.inc

.code

start:

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

    LOCAL dwNumber:DWORD
    mov eax, 0CCFFh
    shr eax, 0Ch
    print str$(eax)
    ret

main endp

end start