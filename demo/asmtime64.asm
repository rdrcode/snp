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

%define CHR_LF               10 ; line feed (LF) character


;-----------------------------------------------------------------------------
; Section DATA
;-----------------------------------------------------------------------------
SECTION .data

out_str:
            db "___ "
hh_str:     db "__:"
mm_str:     db "__:"
ss_str:     db "__ GMT "
ticks_str:  db "__________"
            db CHR_LF
out_str_len equ $-out_str


;-----------------------------------------------------------------------------
; Section RODATA
;-----------------------------------------------------------------------------
SECTION .rodata
              ; 0   1   2   3   4   5   6
wday_str    db "Thu Fri Sat Sun Mon Tue Wed "

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
        global _start:function  ; make label available to linker
_start:
        ;-----------------------------------------------------------
        ; the system call returns the number of seconds since the Unix
        ; Epoch (01.01.1970 00:00:00 UTC).
        ; The first parameter is a pointer to a timeval structure.
        ;-----------------------------------------------------------
        SYSCALL_3 SYS_GETTIMEOFDAY, timeval, 0
        mov     rax, [tv_sec]

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
        ;-----------------------------------------------------------
        mov     [secs_today],edx

        ; rax: number of days
        xor     edx,edx
        mov     ebx,DAYS_PER_WEEK
        div     ebx
        ; eax: #weeks
        ; edx: day of week
        mov     [wday],dl
        mov     eax,[wday_str+edx*4]
        mov     [out_str],eax

        ;-----------------------------------------------------------
        ; calculate the number of hours
        ;-----------------------------------------------------------
        mov     eax,[secs_today]
        xor     edx,edx            ; clear upper 32-bit of dividend
        mov     ebx,SECS_PER_HOUR  ; load divisor
        div     ebx                ; div edx:eax by ebx
        ;-----------------------------------------------------------
        ; division result: edx:eax div ebx => eax * ebx + edx
        ; - eax contains the number of hours elapsed today
        ; - edx contains the number of seconds of the current hour
        ;-----------------------------------------------------------
        mov     [hours],al

        ;###########################################################
        ;-----------------------------------------------------------
        ; convert decimal hours value into two-digit BCD
        ;-----------------------------------------------------------
        mov     bl,10
        div     bl              ; div ax by bl
        ; al: quotient, ah: remainder
        add     ax,('0'<<8)+'0' ; convert al and ah to BCD digits
        mov     word [hh_str],ax
        ;###########################################################

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

        ;###########################################################
        ;-----------------------------------------------------------
        ; convert decimal minutes value into two-digit BCD
        ;-----------------------------------------------------------
        mov     bl,10
        div     bl              ; div ax by bl
        ; al: quotient, ah: remainder
        add     ax,('0'<<8)+'0' ; convert al and ah to BCD digits
        mov     word [mm_str],ax

        ;-----------------------------------------------------------
        ; convert decimal seconds value into two-digit BCD
        ;-----------------------------------------------------------
        movzx   ax,dl           ; load seconds from above
        div     bl              ; div ax by bl; same divisor as above
        ; al: quotient, ah: remainder
        add     ax,('0'<<8)+'0' ; convert al and ah to BCD digits
        mov     word [ss_str],ax

        ; uint_to_ascii(char *s, uint64_t ticks)
        mov     rdi,ticks_str
        mov     rsi,[tv_sec]
        call    uint_to_ascii

        ;-----------------------------------------------------------
        ; print output string
        ;-----------------------------------------------------------
        SYSCALL_4 SYS_WRITE, FD_STDOUT, out_str, out_str_len
        ;###########################################################

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


uint_to_ascii:
        ; rdi: char *s
        ; rsi: uint64_t ticks

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
        ret

