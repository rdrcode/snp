;-------------------------------------------------------------------
; Section DATA
;-------------------------------------------------------------------
SECTION .rodata

global hex_digits:data
global hex_digits_uc:data
global hex_digits_lc:data

align 8
hex_digits_uc:
hex_digits:    db "0123456789ABCDEF +-"

align 8
hex_digits_lc: db "0123456789abcdef +-"

