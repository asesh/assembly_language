.386 ; Set processor type
.model flat, stdcall ; 32-bit memory model
option casemap:none ; Case sensitive

include std.inc

; Data section
.data
    szWindowTitle db "Asesh", 0h
    szSucceeded db "Create file succeeded", 0h
    szFaild db "Create file failed", 0h
    szFileName db "EN_Visual_Studio_Team_System_2008_Team_Suite_x86_x64wow_DVD.01.sdc", 0h

    hFile dd 0h

; Uninitialized data section
.data?
    szBuffer db 9h dup (?)

.code

_start:

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
    push hFile
    call CloseHandle
    ret

main proc

    push 0h
    push 0h
    push OPEN_EXISTING
    push 0h
    mov eax, FILE_SHARE_READ
    or eax, FILE_SHARE_WRITE
    push eax
    mov eax, GENERIC_READ
    or eax, GENERIC_WRITE
    push eax
    push offset szFileName
    call CreateFile
    cmp eax, INVALID_HANDLE_VALUE
    je _errorOpeningFile
    mov hFile, eax
    print chr$("The specified file : ")
    print str$(szFileName)
    print chr$(" has been locked to prevent deleting", 0Ah)
    ret

_errorOpeningFile:
    print chr$("Error opening the specified file", 0Ah)

    ret

main endp

end _start