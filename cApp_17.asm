.486 ; Set processor type
.model flat, stdcall ; 32-bit memory model
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
    mov dwNumber, 1h
    .while dwNumber == 1
        print chr$("This is a message loop", 0Ah)
        .if FUNC(GetAsyncKeyState, VK_ESCAPE)
            ret
        .endif
        push 100
        call Sleep
    .endw
    ret

main endp

end start