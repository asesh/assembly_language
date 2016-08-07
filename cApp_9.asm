.686
.model flat, stdcall
option casemap:none

include std.inc

.data
    szTitle db "Asesh", 0h
    szChatRoomTitle db "Hackers' lounge:1 -- chat", 0h
    szAppTitle1 db "Asesh", 0h

.code

start:

    push offset szTitle
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

    local hThread:DWORD
    local dwProcessId:DWORD, dwBaseAddress:DWORD, dwBytesRead:DWORD, dwThreadId:DWORD
    local context:CONTEXT
    mov dwBaseAddress, 40100Ah
    lea eax, dwProcessId
    push eax
    push offset szChatRoomTitle
    push 0h
    call FindWindow
    cmp eax, 0h
    je _exit
    push eax
    call GetWindowThreadProcessId
    mov dwThreadId, eax
    print chr$("Process id: ")
    print str$(dwProcessId)
    print chr$(" Thread id: ")
    print str$(dwThreadId)
    push dwThreadId
    push 0h
    push THREAD_ALL_ACCESS
    call OpenThread
    cmp eax, 0h
    je _exit
    mov hThread, eax
    mov context.ContextFlags, CONTEXT_FULL
    lea eax, context
    push eax
    push hThread
    call GetThreadContext
    cmp eax, 0h
    je _exit
    mov eax, context.regEip
    push eax
    print chr$(0Ah, "The value of the specified register: ")
    pop eax
    print str$(eax)

_exit:
    push hThread
    call CloseHandle
    ; push hProcess
    ; call CloseHandle
    xor eax, eax
    ret

main endp
    
end start