;-----------------------------------------------------------------------------
; toupper32.asm - convert lower case characters to upper case
;-----------------------------------------------------------------------------
;
; DHBW Ravensburg - Campus Friedrichshafen
;
; Vorlesung Systemnahe Programmierung (SNP)
;
; Labor 2 - Kurs TIT13
;
;----------------------------------------------------------------------------
;
; Architecture:  x86-32
; Language:      NASM Assembly Language
;
; Author:        Ralf Reutemann
; Created:       2011-01-20
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
        test    eax,eax         ; check system call return value
        jz      _exit           ; jump to loop exit if end of input is
                                ; reached, i.e. no characters have been
                                ; read (eax == 0)

        ;-----------------------------------------------------------
        ; convert all lower case characters in the string
        ; to upper case, others remain unchanged
        ;
        ; Note: eax contains the number of characters in the string,
        ;       returned by the read system call above
        ;-----------------------------------------------------------
        mov     ebx,buffer      ; load pointer to character buffer
        xor     ecx,ecx         ; set buffer index to zero
next_char:
        mov     dl,[ebx+ecx]    ; load next character from buffer
        cmp     dl,'a'          ; if char < 'a'
        jb      not_lower_case  ;   yes, then not a lower case character
        cmp     dl,'z'          ; if char > 'z'
        ja      not_lower_case  ;   yes, then not a lower case character
        add     dl,'A'-'a'      ; convert to upper case
        mov     [ebx+ecx],dl    ; store converted character back to buffer
not_lower_case:
        inc     ecx             ; increment buffer index
        cmp     ecx,eax         ; check whether all characters are processed
        jne     next_char       ;   no, process next char in buffer

        ;-----------------------------------------------------------
        ; print modified string stored in buffer
        ;-----------------------------------------------------------
        SYSCALL_4 SYS_WRITE, FD_STDOUT, buffer, eax
        jmp     next_string     ; jump back to read next input line

        ;-----------------------------------------------------------
        ; call system exit and return to operating system / shell
        ;-----------------------------------------------------------
_exit:  SYSCALL_2 SYS_EXIT, 0
        ;-----------------------------------------------------------
        ; END OF PROGRAM
        ;-----------------------------------------------------------

