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
    mov dwNumber, 0h
    .repeat
        print str$(dwNumber)
        print chr$(0Ah)
        add dwNumber, 1h
    .until dwNumber == 5
    ret

main endp

end start