;----------------------------------------------------------------------------
;  asmtime64.asm - get time of day using gettimeofday system call
;----------------------------------------------------------------------------
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
;
;----------------------------------------------------------------------------

%include "syscall.inc"  ; OS-specific system call macros

;-----------------------------------------------------------------------------
; CONSTANTS
;-----------------------------------------------------------------------------

%define SECS_PER_MIN         60 ; seconds per minute
%define SECS_PER_HOUR        60 * SECS_PER_MIN
%define SECS_PER_DAY         24 * SECS_PER_HOUR
%define DAYS_PER_WEEK         7 ; number of days per week
%define EPOCH_WDAY            4 ; Epoch week day was a Thursday


;-----------------------------------------------------------------------------
; Section DATA
;-----------------------------------------------------------------------------
SECTION .data

; empty


;-----------------------------------------------------------------------------
; Section RODATA
;-----------------------------------------------------------------------------
SECTION .rodata

; empty


;-----------------------------------------------------------------------------
; Section BSS
;-----------------------------------------------------------------------------
SECTION .bss

; timeval structure
timeval:
tv_sec          resq 1
tv_usec         resq 1

secs_today      resd 1
days_epoch      resd 1

; weekday (0 = Sunday, 1 = Monday, etc)
wday            resb 1

hms:
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
%ifidn __OUTPUT_FORMAT__, macho64
        DEFAULT REL
        global start            ; make label available to linker
start:                         ; standard entry point for ld
%else
        DEFAULT ABS
        global _start:function  ; make label available to linker
_start:
%endif
        ;-----------------------------------------------------------
        ; the system call returns the number of seconds since the Unix
        ; Epoch (01.01.1970 00:00:00 UTC).
        ; The first parameter is a pointer to a timeval structure.
        ;-----------------------------------------------------------
        SYSCALL_3 SYS_GETTIMEOFDAY, timeval, 0
        mov     rax, [rel tv_sec]

        ;-----------------------------------------------------------
        ; convert ticks into hours, minutes and seconds of today
        ; rax contains the number of seconds since the Epoche
        ;-----------------------------------------------------------
        xor     rdx,rdx            ; clear upper 64-bit of dividend
        mov     rbx,SECS_PER_DAY   ; load divisor
        div     rbx                ; div rdx:rax by rbx
        ;-----------------------------------------------------------
        ; division result: rdx:rax div rbx => rax * rbx + rdx
        ; - rax contains the number of days since the Epoche
        ; - rdx contains the number of seconds elapsed today
        ;
        ; Note: since the number of seconds elapsed today easily fits
        ; into 32-bit we continue with 32-bit integer arithmetic.
        ;-----------------------------------------------------------
        mov     [rel secs_today],edx

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
        mov     [rel hours],al

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
        mov     [rel minutes],al
        mov     [rel seconds],dl

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

