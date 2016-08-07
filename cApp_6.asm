.686
.model flat, stdcall
option casemap:none

include asesh.inc

threadProc1 proto :DWORD
threadProc2 proto :DWORD

.data
    szWindowTitle db "Asesh", 0h
    szData db "This is a data", 0h

.code

start:

    push offset szWindowTitle
    call SetConsoleTitle
    call main

mainLoop:
    push 01Bh
    call GetAsyncKeyState
    test eax, eax
    jne exitMainLoop
    push 064h
    call Sleep
    jmp mainLoop

exitMainLoop:
    xor eax, eax
    ret

main proc

    local hThread[2]:DWORD, dwThreadId[2]:DWORD
    lea eax, dwThreadId[0]
    push eax
    push 0h
    push 0h
    push threadProc
    push 0h
    push 0h
    call CreateThread
    mov hThread, eax
    test eax, eax
    je _errorThread
    mov hThread, eax
    push 0FFFFFFFFh
    push hThread
    call WaitForSingleObject
    cmp eax, WAIT_OBJECT_0
    je _sfl
    print chr$("The thread did not reach the signaled state", 0Ah)
    push hThread
    call CloseHandle
    ret

_errorThread:
    print chr$("Error creating thread(s)", 0Ah)
    ret
    
_sfl:
    print chr$("The thread reached the signaled state", 0Ah)
    push hThread
    call CloseHandle
    ret

main endp

threadProc proc lpParam:DWORD

    print chr$("This is a messag from the thread", 0Ah)
    ret

threadProc endp

end start