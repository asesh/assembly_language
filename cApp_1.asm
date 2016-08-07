.386
.model flat, stdcall
option casemap:none

include std.inc

comment @
The standard Intel notation for addressing memory can look very daunting
to a beginner but it is in fact very compact and simple enough to use
once you know how it works. It is usually referred to as the "complex"
addressing modes. If you understand it properly you can write very compact
and fast code using the technique.

When you have code like,

mov eax, [ebx+ecx*4+32]

The section enclosed in square brackets is broken up in the following
manner.

[Base Address + Index * Scale + Displacement]

Base address
The starting address in memory

Index
A 32 bit register which is the variable for changing the address

Scale
The data size being worked on, it can be 1, 2, 4 or 8

Displacement
An optional additional offset to change the address by.

The example below will show how it works.@

.data
    szTitle db "Asesh", 0h

    ; Initialise 10 DWORD values
    dwItem0 dd 0
    dwItem1 dd 1
    dwItem2 dd 2
    dwItem3 dd 3
    dwItem4 dd 4
    dwItem5 dd 5
    dwItem6 dd 6
    dwItem7 dd 7
    dwItem8 dd 8
    dwItem9 dd 9
      
    ; Put their addresses into an array
    dwArray dd dwItem0, dwItem1, dwItem2, dwItem3, dwItem4
            dd dwItem5, dwItem6, dwItem7, dwItem8, dwItem9

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
    xor eax, eax
    ret

main proc

    local dwCount:DWORD ; loop counter

    push ebx
    push esi
    push edi

    mov dwCount, 0Ah ; Set the number of loop iterations
    mov ebx, dwArray ; Put BASE ADDRESS of array in EBX
    xor esi, esi ; Use ESI as INDEX and set to zero

    print chr$("Index being changed",13,10)

_label2:
    mov edi, [ebx+esi*4]
    print str$(edi)
    print chr$(13,10)
    add esi, 1h ; Each array member is accessed by changing the INDEX
    sub dwCount, 1h
    jnz _label2

    print chr$("Displacement being changed",13,10)

    xor esi, esi

    mov edi, [ebx+esi*4] ; No displacement
    print str$(edi)
    print chr$(13,10)

    mov edi, [ebx+esi*4+4] ; Add displacement of 4 bytes
    print str$(edi)
    print chr$(13,10)

    mov edi, [ebx+esi*4+8] ; Add displacement of 8 bytes
    print str$(edi)
    print chr$(13,10)

    mov edi, [ebx+esi*4+12] ; Added displacement of 12 bytes
    print str$(edi)
    print chr$(13,10)

    pop edi
    pop esi
    pop ebx

    ret

main endp

end start