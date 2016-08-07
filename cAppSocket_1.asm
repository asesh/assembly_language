.686
.model flat, stdcall
option casemap:none

include c:\masm32\include\ws2_32.inc
include c:\masm32\include\wininet.inc
include std.inc
includelib c:\masm32\lib\wininet.lib
includelib c:\masm32\lib\ws2_32.lib 

WSA_FLAG_OVERLAPPED EQU 1h
STD_OUTPUT_HANDLE EQU -0Bh

.data
    _SOCKET dd 0h
    _HANDLE dd 0h
    szWindowTitle db "Aseshsoft Sniper", 0h
    szPacket1 db 55h, 8Bh, 0ECh, 0C9h, 33h, 0C0h, 0C3h, 0h

portScanner proto :DWORD, :DWORD
scanPorts proto :DWORD
cleanup proto :DWORD

.code

start:

    push offset szWindowTitle
    call SetConsoleTitle
    call main

mainMessageLoop:
    push 1Bh
    call GetAsyncKeyState
    cmp eax, 0h
    jne exitMainLoop
    push 64h
    call Sleep
    jmp mainMessageLoop

exitMainLoop:
    push 0h
    call ExitProcess

main proc

    LOCAL wsadata:WSADATA, dwFlags:DWORD
    lea eax, wsadata
    push eax
    push 202h
    call WSAStartup
    mov _HANDLE, eax
    cmp eax, 0h
    jne _exitStartup

comment* push IPPROTO_TCP
    push SOCK_STREAM
    push AF_INET
    call socket*

    push STD_OUTPUT_HANDLE
    call GetStdHandle
    mov _HANDLE, eax
    cmp eax, 0h
    je _exitStartup

    mov eax, 3h
    or eax, 8h
    push eax
    push _HANDLE
    call SetConsoleTextAttribute

    push WSA_FLAG_OVERLAPPED ; Flags
    push 0h ; Group
    push 0h ; Protocol info structure
    push IPPROTO_TCP
    push SOCK_STREAM
    PUSH AF_INET
    call WSASocket
    cmp eax, 0FFFFFFFFh
    mov _SOCKET, eax
    je _exitStartup

_internet:
    push 0h
    lea eax, dwFlags
    push eax
    call InternetGetConnectedState
    cmp eax, 0h
    je _exitinternet
    print chr$("The internet connection was detected", 0Ah)
    push _SOCKET
    call cleanup
    call WSACleanup
    ret

_exitStartup:
    print chr$("Error initializing socket", 0Ah)
    push _HANDLE
    call CloseHandle
    ret

_exitinternet:
    print chr$("Error the internet connection was not detected", 0Ah)
    push _HANDLE
    call CloseHandle
    push _SOCKET
    call cleanup
    call WSACleanup
    ret

main endp

portScanner proc dwInitPortNumber:DWORD, dwMaxPortNumber:DWORD

    ret

portScanner endp

cleanup proc _socket:DWORD

    push _socket
    call closesocket
    ret

cleanup endp

end start