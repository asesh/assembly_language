.686 ; Set processor type
.model flat, stdcall ; 32-bit memory model
option casemap:none ; Case sensitive

include std.inc

.data
    szTitle db "Asesh", 0h

    szData db 44, 55, 33, 31, 0h

    dwArray dd 65

; Prototypes
passData PROTO :DWORD

.code

start:

    push offset szTitle
    call SetConsoleTitle
    call main

mainLoop:
    push 1Bh
    call GetAsyncKeyState
    test eax, eax
    jne exitMainLoop
    push 64h
    call Sleep
    jmp mainLoop

exitMainLoop:
    ret

main proc

    call IsDebuggerPresent
    test eax, eax
    jnz _debuggerPresent
    print chr$("Debugger is not present", 0Ah)
    ret

_debuggerPresent:
    print chr$("Debugger is present", 0Ah)

    ret

main endp

passData proc dwArg:DWORD

    local dwNumber:DWORD
    mov dword ptr ss:[ebp-4], 5h
    print str$(dwNumber)
    ret

passData endp

end start