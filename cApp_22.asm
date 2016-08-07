.586 ; Set processor type
.model flat, stdcall ; 32-bit memory model
option casemap:none ; Case sensitive

; Include header and library files
include asesh.inc

addup macro A, B, Sum
    mov eax, A
    add eax, B
    mov Sum, eax
    endm

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

    LOCAL total:DWORD
    addup 3, 4, total
    print str$(total)
    ret

main endp

end start