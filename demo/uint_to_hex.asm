;-----------------------------------------------------------------------------
; int_to_hex.asm
;-----------------------------------------------------------------------------
;
; DHBW Ravensburg - Campus Friedrichshafen
;
; Vorlesung Systemnahe Programmierung (SNP)
;
;----------------------------------------------------------------------------
;
; Architecture:  x86-64
; Language:      NASM Assembly Language
;
; Author:        Ralf Reutemann
; Created:       2022-02-16
;
;----------------------------------------------------------------------------


;-----------------------------------------------------------------------------
; Section TEXT
;-----------------------------------------------------------------------------
SECTION .text

extern hex_digits

        global uint_to_hex:function

uint_to_hex:
        ; rdi: char *s
        ; rsi: uint64_t x
        push  rcx
        push  rbx

        mov   ecx,16   ; loop counter
.loop:
        mov   edx,esi
        and   edx,0xf
        mov   dl,[hex_digits+rdx]
        mov   [rdi+rcx-1],dl
        shr   rsi,4
        dec   rcx
        jnz   .loop

        pop   rbx
        pop   rcx
        ret
