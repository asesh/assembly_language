.486
.model flat, stdcall
option casemap:none

include std.inc

.data
    hInst dd 0h
    lpCmd dd 0h
    szMbTitle db "Aseshsoft Cleaner", 0h
    szMessage db "Are you sure you want to clean this directory?", 09h, 0h
    szNoOfFilesFound db "No. of files found: ", 0h
    szNoOfFilesDeleted db "No. of files deleted: ", 0h
    szExeExtension db "*.exe", 0h
    szObjExtension db "*.obj", 0h
    dwNoOfFilesFound dd 0h

; Prototypes
WinMain PROTO :DWORD, :DWORD, :DWORD, :DWORD
delObjFiles PROTO :DWORD
delExeFiles PROTO :DWORD
scanAndDeleteFiles PROTO :BYTE

.code

start:

    push ebp
    mov ebp, esp
    push 0h
    call GetModuleHandle
    mov hInst, eax

    call GetCommandLine
    mov lpCmd, eax

    push 1h
    push lpCmd
    push 0h
    push hInst
    call WinMain
    leave
    ret

WinMain proc hInstance:DWORD, hPrevInstance:DWORD, lpCmdLine:DWORD, nCmdShow:DWORD

    LOCAL hThread[2]:DWORD, dwThreadId[2]:DWORD, dwSignalState:DWORD

    mov eax, MB_YESNOCANCEL
    or eax, MB_ICONINFORMATION
    push eax
    push OFFSET szMbTitle
    push OFFSET szMessage
    push 0h
    call MessageBox
    cmp eax, IDYES
    je continueCleaner
    ret

continueCleaner:
    lea eax, dwThreadId[0]
    push eax
    push 0h
    push 0h
    push offset delObjFiles ; function for deleting obj files
    push 0h
    push 0h
    call CreateThread
    mov hThread[0], eax
    lea eax, dwThreadId[1]
    push eax
    push 0h
    push 0h
    push offset delExeFiles ; function for deleting exe files
    push 0h
    push 0h
    call CreateThread
    mov hThread[1], eax

    ; Wait for the threads to terminate
    push 0FFFFFFFFh
    push 1h
    lea eax, hThread
    push eax
    push 2h
    call WaitForMultipleObjects
    mov eax, dwSignalState
    
    cmp dwSignalState, WAIT_OBJECT_0
    push MB_OK or MB_ICONINFORMATION
    ret

exitMainProc:
    ret

WinMain endp

delObjFiles proc lpVoid:DWORD

    push OFFSET szObjExtension
    call scanAndDeleteFiles
    ret

delObjFiles endp

delExeFiles proc lpVoid:DWORD

    push OFFSET szExeExtension
    call scanAndDeleteFiles
    ret

delExeFiles endp

scanAndDeleteFiles proc szExtension:BYTE

    comment* LOCAL hFindFile:DWORD, w32Data:WIN32_FIND_DATA
    lea eax, w32Data
    push eax
    mov eax, dword ptr szExtension
    push eax
    call FindFirstFile
    cmp eax, INVALID_HANDLE_VALUE
    je fileNotFound
    mov hFindFile, eax
    jmp scanLoop

fileNotFound:
    ret

scanLoop:
    lea eax, w32Data
    push eax
    push hFindFile
    call FindNextFile
    call GetLastError
    cmp eax, 12h
    je exitScanLoop
    jmp scanLoop

exitScanLoop:
    push hFindFile
    call CloseHandle*
    ret

scanAndDeleteFiles endp

end start