
%include "syscall.inc"  ; OS-specific system call macros

;-----------------------------------------------------------------------------
; CONSTANTS
;-----------------------------------------------------------------------------

%define BUFFER_SIZE          80 ; max buffer size
%define CHR_LF               10 ; line feed (LF) character
%define CHR_CR               13 ; carriage return (CR) character
%define CHR_SPC              32 ; space character


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

extern  uint_to_hex


encode:
        mov    rax,0x2020202020202020
        mov    ecx,7

.loop:
        movzx  edx,byte [rdi] ; dl: char
        test   dl,dl
        jz     .exit_loop
        lea    r8d,[rdx-'a']
        cmp    r8d,('z'-'a')
        ja     .no_lower_case
        sub    dl,'a'-'A'
        jmp    .store_char
.no_lower_case:
        lea    r8d,[rdx-'0']
        cmp    r8d,('9'-'0')
        jbe    .store_char
        lea    r8d,[rdx-'A']
        cmp    r8d,('Z'-'A')
        ja     .exit_loop
.store_char:
        mov    al,dl
        rol    rax,8
        inc    rdi
        dec    rcx
        jnz    .loop
.exit_loop:
        ; a
        ; ba
        ;
        ;    1234
        ;       9
        ; 1234567
        mov    dl,7
        sub    dl,cl
        shl    cl,3
        rol    rax,cl
        ;mov    al,dl

        ret


        ;-----------------------------------------------------------
        ; PROGRAM'S START ENTRY
        ;-----------------------------------------------------------
        global _start:function  ; make label available to linker
_start:
        nop

.next_string:
        ;-----------------------------------------------------------
        ; read string from standard input (usually keyboard)
        ;-----------------------------------------------------------
        SYSCALL_4 SYS_READ, FD_STDIN, buffer, BUFFER_SIZE
        test    rax,rax         ; check system call return value
        jz      .exit           ; jump to loop exit if end of input is
                                ; reached, i.e. no characters have been
                                ; read (rax == 0)
        lea     rdi,[buffer]
        mov     byte [rdi+rax],0    ; zero terminate string
        call    encode              ; rdi: char *buffer -> rax: encoded string
        test    rax,rax
        jz      .exit

        mov     [buffer],rax
        mov     dword [buffer+8],0x78302020
        lea     rdi,[buffer+12]
        mov     rsi,rax
        call    uint_to_hex

        mov     byte [buffer+27],CHR_LF

        ; "Hello"
        ;  ^
        ; "Hallo"
        ; "2202211537"
        ; 2202211537
        ;
        ; "  0x"
        ; mov dst,0x20203078
        ; mov dst,0x78302020
        ;
        ; "Hello"
        ; "olleH"

        ;-----------------------------------------------------------
        ; print encoded/decoded input string
        ;-----------------------------------------------------------
        SYSCALL_4 SYS_WRITE, FD_STDOUT, buffer, 28
        jmp     .next_string     ; jump back to read next input line

        ;-----------------------------------------------------------
        ; call system exit and return to operating system / shell
        ;-----------------------------------------------------------
.exit:  SYSCALL_2 SYS_EXIT, 0
        ;-----------------------------------------------------------
        ; END OF PROGRAM
        ;-----------------------------------------------------------

