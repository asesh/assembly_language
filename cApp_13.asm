.686
.model flat, stdcall
option casemap:none

include std.inc

.data
    szString db "Dude do you see this?", 0h

.code

start:

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
    ret

main proc

    local context:CONTEXT
    lea eax, context
    push eax
    call GetThreadContext
    test eax, eax
    jz _errReturn
    print chr$("The API succeeded", 0Ah)
    ret

_errReturn:
    call GetLastError
    push eax
    print chr$("The API failed last error code: ")
    pop eax
    print str$(eax)
    ret

main endp

end start