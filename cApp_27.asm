.586 ; Set processor type
.model flat, stdcall ; 32-bit memory model
option casemap:none

include asesh.inc

.data

    dwItem0 dd 0
    dwItem1 dd 1
    dwItem2 dd 2
    dwItem3 dd 3
    dwItem4 dd 4
    dwItem5 dd 5
    dwItem6 dd 6
    dwItem7 dd 7
    
    dwArray dd dwItem0, dwItem1, dwItem2, dwItem3, dwItem4, dwItem5
            dd dwItem6, dwItem7

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

    LOCAL dwLoopCount:DWORD
    mov dwLoopCount, 0h
    mov esi, dwArray
    .while dwLoopCount <= 7h
        mov edi, [esi] ; Derefrence esi into edi
        print chr$("Address: ")
        print str$(esi) ; Display the address of the value
        print chr$(9h)
        print chr$("Value: ")
        print str$(edi) ; Display the derefrenced value
        print chr$(0Ah)
        add esi, sizeof DWORD ; Add 4 to esi to get the next array item
        inc dwLoopCount
    .endw
    ret

main endp

end start