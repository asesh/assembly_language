.386
.model flat, stdcall
option casemap:none

include std.inc

; Macro to add two numbers
addup MACRO A, B, Sum
    mov eax, A ; Move A to eax
    add eax, B ; Add B to eax
    mov Sum, eax ; Move eax to Sum
    ENDM

; Macro to subtract two numbers
subtract Macro A, B, Sum
    mov eax, A
    sub eax, B
    mov Sum, eax
    EndM

.data

    szWindowTitle db "Asesh", 0h

.code

start:

    push offset szWindowTitle
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

    LOCAL dwNumber:DWORD
    print chr$("Subtracting 5 from 12: ")
    subtract 12, 5, dwNumber
    print str$(dwNumber)
    ret

main endp

end start