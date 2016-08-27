; Create a Win32 GUI window using assembly language
; (C) Asesh Shrestha. All rights reserved

.386
.model flat, stdcall
option casemap:none

include asesh.inc

.data
    hInstance dd 0h
    lpCommandLine dd 0h
    szWindowName db "Aseshsoft application", 0h
    szClassName db "Asesh", 0h

; Prototypes
WinMain PROTO :DWORD, :DWORD, :DWORD, :DWORD
WndProc PROTO :DWORD, :DWORD, :DWORD, :DWORD

.code

start:

    push 0h
    call GetModuleHandle
    mov hInstance, eax

    call GetCommandLine
    mov lpCommandLine, eax

    invoke WinMain, hInstance, NULL, lpCommandLine, 1h
    ret

WinMain proc hInst:DWORD, hPrevInstance:DWORD, CommandLine:DWORD, nCmdShow:DWORD

    LOCAL wcex:WNDCLASSEX, hWnd:DWORD, msg:MSG

    invoke RtlZeroMemory, ADDR wcex, sizeof WNDCLASSEX

    mov wcex.cbSize, sizeof WNDCLASSEX
    m2m wcex.hInstance, hInst
    mov wcex.lpszClassName, OFFSET szClassName
    mov wcex.lpfnWndProc, OFFSET WndProc
    mov wcex.style, 1h or 3h
    mov wcex.hbrBackground, (COLOR_BTNFACE + 1)
    invoke LoadCursor, NULL, IDC_ARROW
    mov wcex.hCursor, eax
    invoke RegisterClassEx, ADDR wcex

    .if eax == 0h
        ret
    .endif

    invoke CreateWindowEx, 0h, OFFSET szClassName, OFFSET szWindowName, WS_OVERLAPPEDWINDOW,
                            CW_USEDEFAULT, CW_USEDEFAULT, 640, 480, 0h, 0h, hInst, 0h
    mov hWnd, eax
    .if hWnd == NULL
        ret
    .endif

    invoke ShowWindow, hWnd, 1
    invoke UpdateWindow, hWnd

; Main message loop
mainMessageLoop:
    invoke GetMessage,ADDR msg,NULL,0,0
    cmp eax, 0h
    je exitLoop
    lea eax, msg
    push eax
    call TranslateMessage
    lea eax, msg
    push eax
    call DispatchMessage
    ; invoke TranslateMessage, ADDR msg
    ; invoke DispatchMessage, ADDR msg
    jmp mainMessageLoop

exitLoop:

    return msg.wParam;

WinMain endp

WndProc proc hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD

    LOCAL ps:PAINTSTRUCT, hdc:DWORD

    .if uMsg == WM_PAINT
        invoke BeginPaint, hWnd, ADDR ps
        mov hdc, eax
        invoke EndPaint, hWnd, ADDR ps
        ret
     .elseif uMsg == WM_DESTROY
        invoke PostQuitMessage, 0
        ret
     .elseif uMsg == WM_KEYDOWN
        .if wParam == 1Bh
            invoke SendMessage, hWnd, 10h, 0, 0
            ret
        .endif
        ret
    .endif
    invoke DefWindowProc, hWnd, uMsg, wParam, lParam
    ret

WndProc endp

end start
