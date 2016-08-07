.686
.model flat, stdcall
option casemap:none

include asesh.inc

MAX_PATH EQU 104h

.data
    szData db "Asesh Shrestha", 0h

threadProc1 proto :DWORD
threadProc2 proto :DWORD
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

    local hThread[2]:DWORD, dwThreadId[2]:DWORD, dwSignalState
    push sizeof hThread
    lea eax, hThread
    push eax
    call RtlZeroMemory
    lea eax, dwThreadId[0]
    push eax
    push 0h
    push 0h
    push offset threadProc1
    push 0h
    push 0h
    call CreateThread
    mov hThread[0], eax
    lea eax, hThread[1]
    push eax
    push 0h
    push 0h
    push offset threadProc2
    push 0h
    push 0h
    call CreateThread
    mov hThread[1], eax
    push 0FFFFFFFFh
    push 1h
    mov eax, [hThread]
    push eax
    push 2
    call WaitForMultipleObjects
    mov dwSignalState, eax
    cmp dwSignalState, WAIT_OBJECT_0
    jne _notSignaled
    print chr$("The threads reached the signaled state", 0Ah)
    mov ecx, 2h

_notSignaled:
    ret

_loop:
    ret

main endp

threadProc1 proc lpParam:DWORD

    print chr$("This is a message from threadProc1", 0Ah)
    ret

threadProc1 endp

threadProc2 proc lpParam:DWORD

    print chr$("This is a message from threadProc2", 0Ah)
    ret

threadProc2 endp

end start