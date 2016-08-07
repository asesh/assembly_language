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

    LOCAL dwNumber1:DWORD, dwNumber2:DWORD
    mov dwNumber1, 5h
    mov eax, dwNumber1
    mov dwNumber2, 9h
    mov ebx, dwNumber2
    and eax, ebx
    mov dwNumber1, eax
    print str$(dwNumber1)
    ret

main endp

end start