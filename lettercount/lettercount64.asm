;-----------------------------------------------------------------------------
; lettercount64.asm
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

%include "syscall.inc"  ; OS-specific system call macros

extern  asciitable
extern  uint_to_ascii

;-----------------------------------------------------------------------------
; CONSTANTS
;-----------------------------------------------------------------------------

%define BUFFER_SIZE          80 ; max buffer size
%define CHR_LF               10 ; line feed (LF) character
%define CHR_CR               13 ; carriage return (CR) character


;-----------------------------------------------------------------------------
; Section DATA
;-----------------------------------------------------------------------------
SECTION .data

chcnt:      times 7 dq 0
chtotal:    dq 0

outstr:
            db "DIG:   "
.dig        db "             ", CHR_LF
            db "LOW:   "
.low        db "             ", CHR_LF
            db "SPC:   "
.spc        db "             ", CHR_LF
            db "UPP:   "
.upp        db "             ", CHR_LF
            db "PCT:   "
.pct        db "             ", CHR_LF
            db "CTL:   "
.ctl        db "             ", CHR_LF
            db "OTH:   "
.oth        db "             ", CHR_LF
            db "TOTAL: "
.total      db "             ", CHR_LF
outstr_len  equ $-outstr
            db 0

cntstr:
            dq outstr.dig
            dq outstr.low
            dq outstr.spc
            dq outstr.upp
            dq outstr.pct
            dq outstr.ctl
            dq outstr.oth
cntstr_num  equ ($-cntstr)/8


;-----------------------------------------------------------------------------
; Section BSS
;-----------------------------------------------------------------------------
SECTION .bss

buffer          resb BUFFER_SIZE


;-----------------------------------------------------------------------------
; SECTION TEXT
;-----------------------------------------------------------------------------
SECTION .text

        ;-----------------------------------------------------------
        ; PROGRAM'S START ENTRY
        ;-----------------------------------------------------------
        global _start:function  ; make label available to linker
_start:
        nop

next_string:
        ;-----------------------------------------------------------
        ; read string from standard input (usually keyboard)
        ;-----------------------------------------------------------
        SYSCALL_4 SYS_READ, FD_STDIN, buffer, BUFFER_SIZE
        test    rax,rax         ; check system call return value
        jz      finished        ; jump to loop exit if end of input is
                                ; reached, i.e. no characters have been
                                ; read (rax == 0)

        ; rsi: pointer to current character in buffer
        lea     rsi,[buffer]
        mov     ecx,128
next_char:
        movsx   edx,byte [rsi+rax-1]
        test    edx,edx
        cmovs   edx,ecx
        movzx   ebx,byte [asciitable+rdx]
        inc     qword [chcnt+rbx*8]
        dec     rax
        jnz     next_char
        jmp     next_string     ; jump back to read next input line

finished:
        mov     ecx,cntstr_num-1
.loop:
        mov     rdi,[cntstr+rcx*8]
        mov     rsi,[chcnt+rcx*8]
        add     [chtotal],rsi
        call    uint_to_ascii
        dec     ecx
        jns     .loop

        mov     rdi,outstr.total
        mov     rsi,[chtotal]
        call    uint_to_ascii

        ;-----------------------------------------------------------
        ; print output string
        ;-----------------------------------------------------------
        SYSCALL_4 SYS_WRITE, FD_STDOUT, outstr, outstr_len

        ;-----------------------------------------------------------
        ; call system exit and return to operating system / shell
        ;-----------------------------------------------------------
_exit:  SYSCALL_2 SYS_EXIT, 0
        ;-----------------------------------------------------------
        ; END OF PROGRAM
        ;-----------------------------------------------------------
