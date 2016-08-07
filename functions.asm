.386
.model flat, stdcall
option casemap:none

include std.inc

; Function prototypes
outputString proto :DWORD, :DWORD, :DWORD, :DWORD, :DWORD
stringLength proto :DWORD
charUpper proto :DWORD, :DWORD
charLower proto :DWORD, :DWORD
strtok proto :DWORD, :DWORD

SData struc

    dwNumber dd ?

SData ends

; Unitialized data section
.data?

    szDestString db 104h dup (?)

; Data section
.data
    szWindowTitle db "Aseshsoft ConsoleApp", 0h
    szMessage db "This is a message", 0h

.code

start:

    push ebp
    mov ebp, esp
    push offset szWindowTitle
    call SetConsoleTitle
    call main

mainMessageLoop:
    push 1Bh
    call GetAsyncKeyState
    test eax, eax
    jne exitMainLoop
    push 64h
    call Sleep
    jmp mainMessageLoop

exitMainLoop:
    leave
    xor eax, eax
    ret

main proc

    local hConsoleHandle:DWORD
    push STD_OUTPUT_HANDLE
    call GetStdHandle
    cmp eax, 0h
    je _exit
    mov hConsoleHandle, eax

    ; Set text color to red
    mov eax, 4h
    or eax, 8h
    push eax
    push hConsoleHandle
    call SetConsoleTextAttribute

    push offset szDestString
    push offset szWindowTitle
    call charLower
    print str$(szDestString)    

    ; Close the std output handle
    push hConsoleHandle
    call CloseHandle

_exit:
    ret

main endp

;-----------------------------------------------------
; Name: outputString
; Desc: Output the specified string on the screen
;-----------------------------------------------------
outputString proc hConsoleOutput:DWORD, b:DWORD, d:DWORD, e:DWORD, f:DWORD

    local dwHandle:DWORD ; File handle

    test eax, 0h
    jz _closeHandle
    jnz _return

_closeHandle:
    push dwHandle
    call CloseHandle

_return:
    
    ret

outputString endp

;-----------------------------------------------------
; Name: stringLength
; Desc: Return the string length
;-----------------------------------------------------
stringLength proc dwStringOffset:DWORD

    local dwCharCount:DWORD ; Variable for holding character occurences in a string

    mov dwCharCount, 0h
    mov esi, dwStringOffset ; Move the offset of string argument into esi register
    xor ecx, ecx ; Zero out ecx register

_scanString:
    mov ecx, dwCharCount ; Move the character counter variable into ecx register
    cmp byte ptr [esi + ecx], 0h ; Compute a character to see if it is a null character
    je _final
    jnz _increment
    mov eax, dwCharCount ; Move the result into the eax register
    je _exitLoop

_increment:
    inc esi ; Increment the offset to string
    inc dwCharCount ; Increment the char counter
    jmp _scanString

_final:
    mov eax, dwCharCount
    ret

_exitLoop:
    ret

stringLength endp

;-----------------------------------------------------
; Name: charUpper
; Desc: Conver lower case characters to uppercase
;-----------------------------------------------------
charUpper proc dwStringOffset:DWORD, dwDestStringOffset:DWORD

    cmp byte ptr dwStringOffset, 0h ; Compute to see if it's a null character
    je _exit
    cmp byte ptr dwStringOffset, 41h
    jg _gt_comp1
    jmp _inc_offset

_gt_comp1:

_inc_offset:
    inc dwStringOffset

_exit:
    ret

charUpper endp

;-----------------------------------------------------
; Name: charLower
; Desc: Convert upper case character to lowercase
;-----------------------------------------------------
charLower proc dwStringOffset:DWORD, dwDestStringOffset:DWORD

    xor eax, eax
    xor esi, esi
_compute:
    mov eax, dwStringOffset ; Move a character to the specified register
    cmp byte ptr [eax], 0h ; Compute the first character to see if it's a NULL character
    je _exit ; If it's a null character then exit
    mov esi, eax ; Move the offset into the specified register
    cmp byte ptr [eax], 41h ; Compute with 'A'
    jl _inc_offset ; Increment the offset since it's not an alphabet
    jge _gt_41h ; The input character is either 'A' or greater

_inc_offset:
    inc byte ptr dwStringOffset ; Increment the string offset
    jmp _compute ; Compute the incremented character

_gt_41h:
    cmp byte ptr [eax], 5ah ; Compute the character with 'Z' (5a)
    jg _inc_offset ; Jump if it's greater than 'Z'
    jle _lower_Char ; Jump if less than 5a

_add_hex:
    add esi, 20h
    jmp _inc_offset

_lower_Char:
    add esi, 20h
    jmp _inc_offset

_exit:
    mov [dwDestStringOffset], esi
    xor eax, eax
    
    ret

charLower endp

;-----------------------------------------------------
; Name: strtok
; Desc: Finds a token in a string and returns the
;       remaining string
;-----------------------------------------------------
strtok proc szString:DWORD, szToken:DWORD

    push ebp
    mov ebp, esp

    ; Determine the length of the string
    push offset szString
    call StringLength

    ; Move the number of characters in the string into ecx
    mov ecx, eax

_loop:
    jecxz _loop

    leave
    xor eax, eax
    ret

strtok endp

end start