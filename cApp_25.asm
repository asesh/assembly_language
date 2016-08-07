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

    ;LOCAL bData:BYTE
    mov al, 3h
    mov ebx, 5h
    mul ebx
    ;mov bData, al
    ;print str$(bData)
    print str$(al)
    ret

main endp

end start