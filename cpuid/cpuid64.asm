;-----------------------------------------------------------------------------
;  cpuid64.asm - print cpu vendor and brand information
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
;
;----------------------------------------------------------------------------

%include "syscall.inc"  ; OS-specific system call macros

;-----------------------------------------------------------------------------
; CONSTANTS
;-----------------------------------------------------------------------------

%define CHR_LF               10 ; Line feed (LF) character ASCII code
%define CHR_CR               13 ; Carriage return (CR) character ASCII code


;-------------------------------------------------------------------
; Section DATA
;-------------------------------------------------------------------
SECTION .data

prompt_str          db "CPU vendor/brand is: "
vendor_str          times 12 db " "
type_str            times 3*16 db " "
                    db CHR_LF
prompt_str_len      equ $-prompt_str


;-------------------------------------------------------------------
; Section BSS
;-------------------------------------------------------------------
SECTION .bss

; empty


;-------------------------------------------------------------------
; Section TEXT
;-------------------------------------------------------------------
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
        ;-------------------------------------------------------------------
        ; Using CPUID standard function 0 in order to load a 12-character
        ; string into the EBX, EDX, and ECX registers identifying the
        ; processor vendor
        ;-------------------------------------------------------------------
        xor     eax,eax    ; eax=0: return vendor identification string
        cpuid

        ;-------------------------------------------------------------------
        ; Copy the 12-byte vendor string, 3 registers a 4 bytes, into the
        ; string buffer
        ;-------------------------------------------------------------------
        mov     rdi,vendor_str
        mov     dword [rdi],ebx
        mov     dword [rdi+4],edx
        mov     dword [rdi+8],ecx

        ;-------------------------------------------------------------------
        ; Using CPUID extended function 0x8000002..4 to load the processor 
        ; brand string into the EAX, EBX, ECX, and EDX registers
        ;-------------------------------------------------------------------
        mov     esi,0x80000002
        mov     rdi,type_str
.loop:
        mov     eax,esi
        cpuid

        mov     dword [rdi],eax
        mov     dword [rdi+4],ebx
        mov     dword [rdi+8],ecx
        mov     dword [rdi+12],edx
        inc     esi
        add     rdi,byte 16     ; move pointer by 16 = 4*4 bytes
        cmp     esi,0x80000004  ; has upper extended function been reached?
        jbe     .loop

        ;-----------------------------------------------------------
        ; write() system call
        ;-----------------------------------------------------------
        SYSCALL_4 SYS_WRITE, FD_STDOUT, prompt_str, prompt_str_len

        ;-----------------------------------------------------------
        ; exit() system call
        ;-----------------------------------------------------------
        SYSCALL_2 SYS_EXIT, 0

        ;-----------------------------------------------------------
        ; END OF PROGRAM
        ;-----------------------------------------------------------

