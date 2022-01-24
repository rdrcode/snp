
SECTION .text

;-------------------------------------------------------------------
; FUNCTION:   dec_to_uint
;
; PURPOSE:    Convert ASCII string to unsigned integer 
;
; PARAMETERS: (via register)
;             RDI - pointer to input ASCII string
;             RSI - pointer to address of first invalid character
;
; RETURN:     RAX - result of conversion, or 0 in case of error
;
;-------------------------------------------------------------------
        global dec_to_uint:function
dec_to_uint:
        push    rbx
        push    r12

        xor     ecx,ecx
        xor     edx,edx
        xor     eax,eax         ; holds converted result
        mov     ebx,10          ; decimal multiplier per input digit

        ; skip leading spaces
.skipspace:
        mov     cl,[rdi]
        cmp     cl,' '
        jne     .checksign
        inc     rdi
        jmp     .skipspace
.checksign:
        ; check +/- sign
        xor     r12,r12         ; clear sign flag
        mov     cl,[rdi]
        cmp     cl,'+'
        je      .skipsign
        cmp     cl,'-'
        jne     .loop
        inc     r12
.skipsign:
        inc     rdi
.loop:
        mov     cl,[rdi]
        test    cl,cl
        jz      .loop_exit
        sub     cl,'0'
        cmp     cl,9
        ja      .func_exit
        mul     ebx
        test    edx,edx
        jnz     .func_exit
        add     eax,ecx
        jc      .func_exit
        inc     rdi
        jmp     .loop
.loop_exit:
        test    r12,r12            ; check sign flag
        jz      .func_exit
        neg     rax                ; negate result if set
.func_exit:
        test    rsi,rsi
        jz      .nullptr
        mov     [rsi],rdi
.nullptr:
        pop     r12
        pop     rbx
        ret
