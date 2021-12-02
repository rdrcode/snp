;-----------------------------------------------------------------------------
; uint_to_ascii64.asm
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
; Created:       2021-12-02
;
;----------------------------------------------------------------------------


;-----------------------------------------------------------------------------
; Section TEXT
;-----------------------------------------------------------------------------
SECTION .text

        global uint_to_ascii:function

uint_to_ascii:
        ; rdi: char *s
        ; rsi: uint64_t x
        push  rcx
        push  rbx

        mov   ecx,10   ; loop counter
        test  rsi,rsi
        jnz   .loop_start
        mov   byte [rdi+rcx-1],'0'
        jmp   .func_end

.loop_start:
        mov   ebx,10   ; divisor
        mov   rax,rsi  ; ticks
.loop:
        test  rax,rax
        jz    .func_end
        xor   rdx,rdx
        div   rbx
        add   dl,'0'
        mov   [rdi+rcx-1],dl
        dec   rcx
        jnz   .loop

.func_end:
        pop   rbx
        pop   rcx
        ret
