; Creates a Win32 GUI windows using assembly langauge
; (C) Asesh Shrestha. All rights reserved

.386
.model flat, stdcall
option casemap:none

include std.inc

.data
    szWindowTitle db "WinApp", 0h
    szClassName db "Asesh", 0h

    lpCmdLine_ dd 0h
    hInstance_ dd 0h
    nWindowWidth dd 640
    nWindowHeight dd 480
    hWnd_ dd 0h

; Prototypes
WinMain PROTO :DWORD, :DWORD, :DWORD, :DWORD ; WinMain
WndProc PROTO :DWORD, :DWORD, :DWORD, :DWORD ; Window procedure
stringLength PROTO :DWORD ; Returns the string length

.code

start:

    push ebp
    mov ebp, esp

    ; Get the module handle of the application
    push 0h
    call GetModuleHandle
    mov hInstance_, eax

    push 1h
    push 0h
    push 0h
    push hInstance_
    call WinMain
    leave
    ret

WinMain proc hInstance:DWORD, hPrevInstance:DWORD, wParam:DWORD, lParam:DWORD

    LOCAL wcex:WNDCLASSEX
    LOCAL msg:MSG
    LOCAL rect:RECT

    push sizeof WNDCLASSEX
    lea eax, wcex
    push eax
    call RtlZeroMemory

    mov wcex.cbSize, sizeof WNDCLASSEX
    m2m wcex.hInstance, hInstance
    mov wcex.lpszClassName, offset szClassName
    mov wcex.style, 01h or 03h
    mov wcex.lpfnWndProc, OFFSET WndProc
    mov wcex.hbrBackground, COLOR_BTNFACE + 1
    push 8000h
    push SM_CYICON
    call GetSystemMetrics
    push SM_CXICON
    push eax
    call GetSystemMetrics
    push eax
    push IMAGE_CURSOR
    push IDC_ARROW
    push 0h
    call LoadImage
    mov wcex.hCursor, eax
    lea eax, wcex
    push eax
    call RegisterClassEx
    test eax, eax
    je _exit
    jne _continue

_exit:
    ret

_continue:
    push sizeof RECT
    lea eax, rect
    push eax
    call RtlZeroMemory

    ; Get the work area
    push 0h
    lea eax, rect
    push eax
    push 30h
    call SystemParametersInfo

    push 0h
    push hInstance
    push 0h
    push 0h
    push nWindowHeight
    push nWindowWidth
    push 80000000h
    push 80000000h
    mov eax, WS_CAPTION
    or eax, WS_MINIMIZEBOX
    or eax, WS_SYSMENU
    push eax
    push OFFSET szWindowTitle
    push OFFSET szClassName
    push 0h
    call CreateWindowEx
    test eax, eax
    je _exit
    mov hWnd_, eax
    push 1h
    push hWnd_
    call ShowWindow
    push hWnd_
    call UpdateWindow
    jmp _mainMessageLoop
    
_mainMessageLoop:
    push 0h
    push 0h
    push 0h
    lea eax, msg
    push eax
    call GetMessage
    test eax, eax
    je _exitWinMain
    lea eax, msg
    push eax
    call TranslateMessage
    lea eax, msg
    push eax
    call DispatchMessage
    jmp _mainMessageLoop

_exitWinMain:
    mov eax, msg.wParam
    ret

WinMain endp

WndProc proc hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD

    LOCAL hdc:DWORD
    LOCAL ps:PAINTSTRUCT

    cmp uMsg, WM_PAINT
    je wm_paint
    cmp uMsg, WM_KEYDOWN
    je wm_keydown
    cmp uMsg, WM_DESTROY
    je wm_destroy
    cmp uMsg, WM_CLOSE
    je wm_close
    jmp defaultWinProc ; Jump to default window procedure

wm_paint:
    lea eax, ps
    push eax
    push hWnd
    call BeginPaint
    mov hdc, eax

    lea eax, ps
    push eax
    push hWnd
    call EndPaint
    ret

wm_keydown:
    and wParam, 0FFFFh
    cmp wParam, 1Bh
    je escKey
    ret

escKey:
    push 0h
    push 0h
    push 10h
    push hWnd
    call SendMessage
    ret

wm_close:
    push hWnd
    call DestroyWindow
    ret

wm_destroy:
    push 0h
    call PostQuitMessage
    ret

defaultWinProc:
    push lParam
    push wParam
    push uMsg
    push hWnd
    call DefWindowProc
    ret

    xor eax, eax
    ret

WndProc endp

end start

    
