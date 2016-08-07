.486 ; Set processor type
.model flat, stdcall ; 32-bit memory model
option casemap:none ; Case sensitive

include asesh.inc

.const

    mystring db "Hello can you modify this string?", 0h
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

    LOCAL dwLoop:DWORD
    mov dwLoop, 0h
    .repeat
        print offset mystring
        print chr$(0Ah)
        add dwLoop, 1h
    .until dwLoop == 5
    ret

main endp

end start