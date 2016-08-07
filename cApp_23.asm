.586 ; Set processor type
.model flat, stdcall ; Set memory model
option casemap:none ; Case sensitive

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
    mov dwNumber, 111b
    mov eax, 111b
    test eax, dwNumber
    print str$(eax)
    ret

main endp

end start