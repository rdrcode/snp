;----------------------------------------------------------------------------
; copyij.asm
;----------------------------------------------------------------------------
;
; DHBW Ravensburg - Campus Friedrichshafen
;
; Vorlesung Systemnahe Programmierung (SNP)
;
;----------------------------------------------------------------------------

SECTION .text

;-------------------------------------------------------------------
; FUNCTION:   copy_array
;
; PURPOSE:    Copy a two-dimensional array in row-major oder
;
; PARAMETERS: (via register)
;             RDI - pointer to source array
;             RSI - pointer to destination array
;
; RETURN:     none
;
; C Code:
;
;  for (i = 0; i < NUM_ROWS; i++) {
;      for (j = 0; j < NUM_COLS; j++) {
;          dst->a[i][j] = src->a[i][j];
;      }
;  }
;
;-------------------------------------------------------------------
        global copy_array:function
copy_array:
        ret
