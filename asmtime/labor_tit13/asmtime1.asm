;----------------------------------------------------------------------------
;  asmtime1.asm - get time of day using time system call
;----------------------------------------------------------------------------
;
; Author: Ralf Reutemann
;
; $Id: asmtime1.asm,v 1.2 2014/11/13 16:36:18 ralf Exp ralf $
;
;----------------------------------------------------------------------------


;-----------------------------------------------------------------------------
; CONSTANTS
;-----------------------------------------------------------------------------

%define SYS_EXIT              1 ; exit system call
%define SYS_TIME             13 ; time system call

%define SECS_PER_MIN         60 ; seconds per minute
%define SECS_PER_HOUR        60 * SECS_PER_MIN
%define SECS_PER_DAY         24 * SECS_PER_HOUR


;-----------------------------------------------------------------------------
; MACROS
;-----------------------------------------------------------------------------

;-----------------------------------------------------------------------------
; SYSCALL1
; invoke system call with one parameter
; C syntax -> syscall(number, param1)
;-----------------------------------------------------------------------------
%macro SYSCALL1 2
        mov     ebx,%2          ; system call parameter #1
        mov     eax,%1          ; system call id
        int     0x80
%endmacro


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
        SYSCALL1 SYS_TIME, secs_epoch

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
        ; call system exit and return to operating system / shell
        ;-----------------------------------------------------------
_exit:  ; create label before program exit for our gdb script
        SYSCALL1 SYS_EXIT, 0
        ;-----------------------------------------------------------
        ; END OF PROGRAM
        ;-----------------------------------------------------------

