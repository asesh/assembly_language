.486 ; Set processor type
.model flat, stdcall ; 32-bit memory model
option casemap:none ; Case sensitive

include asesh.inc

.data

    dwArray dd 1h, 2h, 4h, 7h, 9h

.code ; Code section

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

    LOCAL dwLoopCount:DWORD
    mov dwLoopCount, 0h
    ; mov [dwArray + 2h], 0FFh
    add dwArray, 5h
    mov eax, dwArray
    print str$(eax )
    ret

main endp

end start