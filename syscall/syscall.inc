;-----------------------------------------------------------------------------
;  syscall.inc - OS-specific system call macros
;-----------------------------------------------------------------------------
;
; DHBW Ravensburg - Campus Friedrichshafen
;
; Vorlesung Systemnahe Programmierung (SNP)
;
;----------------------------------------------------------------------------
;
; Architecture:  x86-32 / x86-64
; Language:      NASM Assembly Language
;
; Author:        Ralf Reutemann
;
;----------------------------------------------------------------------------


%ifndef SYSCALL_INC

    %define SYSCALL_INC


    %define FD_STDIN              0 ; stdin file descriptor
    %define FD_STDOUT             1 ; stdout file descriptor
    %define FD_STDERR             2 ; stderr file descriptor

%ifidn __OUTPUT_FORMAT__, elf

    %define SYS_EXIT              1
    %define SYS_READ              3
    %define SYS_WRITE             4
    %define SYS_TIME             13
    %define SYS_OPEN              5
    %define SYS_CLOSE             6
    %define SYS_GETPID           20
    %define SYS_GETTIMEOFDAY     78
    %define SYS_GETPPID          64


    %macro SYSCALL_1 1
        mov      eax,%1
        int      0x80
    %endmacro

    %macro SYSCALL_2 2
        mov      ebx,%2
        mov      eax,%1
        int      0x80
    %endmacro

    %macro SYSCALL_3 3
        mov      ecx,%3
        mov      ebx,%2
        mov      eax,%1
        int      0x80
    %endmacro

    %macro SYSCALL_4 4
        mov      edx,%4
        mov      ecx,%3
        mov      ebx,%2
        mov      eax,%1
        int      0x80
    %endmacro

%elifidn __OUTPUT_FORMAT__, elf64

    %define SYS_EXIT             60
    %define SYS_READ              0
    %define SYS_WRITE             1
    %define SYS_OPEN              2
    %define SYS_CLOSE             3
    %define SYS_GETPID           39
    %define SYS_GETTIMEOFDAY     96
    %define SYS_GETPPID         110
    %define SYS_TIME            201


    %macro SYSCALL_1 1
        mov      rax,%1
        syscall
    %endmacro

    %macro SYSCALL_2 2
        mov      rdi,%2
        mov      rax,%1
        syscall
    %endmacro

    %macro SYSCALL_3 3
        mov      rsi,%3
        mov      rdi,%2
        mov      rax,%1
        syscall
    %endmacro

    %macro SYSCALL_4 4
        mov      rdx,%4
        mov      rsi,%3
        mov      rdi,%2
        mov      rax,%1
        syscall
    %endmacro

%elifidn __OUTPUT_FORMAT__, macho64

    %define SYS_EXIT           0x2000001
    %define SYS_READ           0x2000003
    %define SYS_WRITE          0x2000004
    %define SYS_GETTIMEOFDAY   0x2000074

    %macro SYSCALL_1 1
        mov      rax,%1
        syscall
    %endmacro

    %macro SYSCALL_2 2
        mov      rdi,%2
        mov      rax,%1
        syscall
    %endmacro

    %macro SYSCALL_3 3
        mov      rsi,%3
        mov      rdi,%2
        mov      rax,%1
        syscall
    %endmacro

    %macro SYSCALL_4 4
        mov      rdx,%4
        mov      rsi,%3
        mov      rdi,%2
        mov      rax,%1
        syscall
    %endmacro

%else

;    print "Unsupported output format!"

%endif  ; __OUTPUT_FORMAT__

%endif  ; SYSCALL_INC

