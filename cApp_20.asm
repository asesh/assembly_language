.486 ; Set processor type
.model flat, stdcall ; 32-bit memory model
option casemap:none ; Case sensitive

MYNUMBER EQU 10h

include asesh.inc

.data
    dwNumber dd 100h
    mystring db "Hello I am Asesh"

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

    print str$(dwNumber)
    ret

main endp

end start