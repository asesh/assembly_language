.586
.model flat, stdcall
option casemap:none ; Case sensitive

include asesh.inc

.data
    szWindowTitle db "Asesh", 0h

.code

start:

    push OFFSET szWindowTitle
    call SetConsoleTitle
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

    push eax
    mov eax, 12h
    print str$(eax)
    pop eax
    ret

main endp

end start