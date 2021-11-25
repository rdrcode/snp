;-----------------------------------------------------------------------------
; toupper64.asm - convert lower case characters to upper case
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
; Created:       2021-11-25
;
;----------------------------------------------------------------------------

%include "syscall.inc"  ; OS-specific system call macros

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


;-----------------------------------------------------------------------------
; Section BSS
;-----------------------------------------------------------------------------
SECTION .bss

                align 128
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
        jz      _exit           ; jump to loop exit if end of input is
                                ; reached, i.e. no characters have been
                                ; read (eax == 0)

        ;-----------------------------------------------------------
        ; print modified string stored in buffer
        ;-----------------------------------------------------------
        SYSCALL_4 SYS_WRITE, FD_STDOUT, buffer, rax
        jmp     next_string     ; jump back to read next input line

        ;-----------------------------------------------------------
        ; call system exit and return to operating system / shell
        ;-----------------------------------------------------------
_exit:  SYSCALL_2 SYS_EXIT, 0
        ;-----------------------------------------------------------
        ; END OF PROGRAM
        ;-----------------------------------------------------------

