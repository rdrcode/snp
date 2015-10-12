;----------------------------------------------------------------------------
;  asmtime1.asm - get time of day using time system call (32-bit version)
;----------------------------------------------------------------------------
;
; DHBW Ravensburg - Campus Friedrichshafen
;
; Vorlesung Systemnahe Programmierung (SNP)
;
;----------------------------------------------------------------------------
;
; Architecture:  x86-32
; Language:      NASM Assembly Language
;
; Author:        Ralf Reutemann
;
;----------------------------------------------------------------------------

%include "syscall.inc"  ; OS-specific system call macros

;-----------------------------------------------------------------------------
; CONSTANTS
;-----------------------------------------------------------------------------

%define SECS_PER_MIN         60 ; seconds per minute
%define SECS_PER_HOUR        60 * SECS_PER_MIN
%define SECS_PER_DAY         24 * SECS_PER_HOUR


;-----------------------------------------------------------------------------
; Section DATA
;-----------------------------------------------------------------------------
SECTION .data

; empty


;-----------------------------------------------------------------------------
; Section BSS
;-----------------------------------------------------------------------------
SECTION .bss

secs_epoch      resd 1
secs_today      resd 1
hours           resb 1
minutes         resb 1
seconds         resb 1


;-----------------------------------------------------------------------------
; Section TEXT
;-----------------------------------------------------------------------------
SECTION .text

        ;-----------------------------------------------------------
        ; PROGRAM'S START ENTRY
        ;-----------------------------------------------------------
        global _start:function  ; make label available to linker
_start:
        ;-----------------------------------------------------------
        ; the system call returns in register eax the number of seconds
        ; since the Unix Epoch (01.01.1970 00:00:00 UTC).
        ;-----------------------------------------------------------
        SYSCALL_2 SYS_TIME, secs_epoch

        ;-----------------------------------------------------------
        ; convert ticks into hours, minutes and seconds of today
        ; eax contains the number of seconds since the Epoche
        ;-----------------------------------------------------------
        xor     edx,edx            ; clear upper 32-bit of dividend
        mov     ebx,SECS_PER_DAY   ; load divisor
        div     ebx                ; div edx:eax by ebx
        ;-----------------------------------------------------------
        ; division result: edx:eax div ebx => eax * ebx + edx
        ; - eax contains the number of days since the Epoche
        ; - edx contains the number of seconds elapsed today
        ;-----------------------------------------------------------
        mov     [secs_today],edx

        ;-----------------------------------------------------------
        ; calculate the number of hours
        ;-----------------------------------------------------------
        mov     eax,edx            ; seconds elapsed today, from above
        xor     edx,edx            ; clear upper 32-bit of dividend
        mov     ebx,SECS_PER_HOUR  ; load divisor
        div     ebx                ; div edx:eax by ebx
        ;-----------------------------------------------------------
        ; division result: edx:eax div ebx => eax * ebx + edx
        ; - eax contains the number of hours elapsed today
        ; - edx contains the number of seconds of the current hour
        ;-----------------------------------------------------------
        mov     [hours],al

        ;-----------------------------------------------------------
        ; calculate the number of minutes
        ;-----------------------------------------------------------
        mov     eax,edx            ; seconds of current hour, from above
        xor     edx,edx            ; clear upper 32-bit of dividend
        mov     ebx,SECS_PER_MIN   ; load divisor
        div     ebx                ; div edx:eax by ebx
        ;-----------------------------------------------------------
        ; division result: edx:eax div ebx => eax * ebx + edx
        ; - eax contains the number of minutes of the current hour
        ; - edx contains the number of seconds of the current minute
        ;-----------------------------------------------------------
        mov     [minutes],al
        mov     [seconds],dl

        ;-----------------------------------------------------------
        ; create label before program exit for our gdb script
        ;-----------------------------------------------------------
_exit:

        ;-----------------------------------------------------------
        ; call system exit and return to operating system / shell
        ;-----------------------------------------------------------
        SYSCALL_2 SYS_EXIT, 0

        ;-----------------------------------------------------------
        ; END OF PROGRAM
        ;-----------------------------------------------------------

