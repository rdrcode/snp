#=============================================================================
#
# Makefile
#
#-----------------------------------------------------------------------------
#
# DHBW Ravensburg - Campus Friedrichshafen
#
# Vorlesung Systemnahe Programmierung / Verteilte Systeme
#
# Author: Ralf Reutemann
#
#=============================================================================

CC          = gcc
LD          = ld
NASM        = nasm
NASMOPT32   = -g -f elf -F dwarf
NASMOPT64   = -g -f elf64 -F dwarf
CFLAGS      = -Wall -g -std=gnu99 -Og
INCDIR      = ../syscall/

TARGETS     = asmtime64

.PHONY: all
all: $(TARGETS)

asmtime32 : asmtime32.asm $(INCDIR)/syscall.inc
	$(NASM) $(NASMOPT32) -I$(INCDIR) -l asmtime32.lst -o asmtime32.o $<
	$(LD) -melf_i386 -o $@ asmtime32.o

asmtime64 : asmtime64.asm $(INCDIR)/syscall.inc
	$(NASM) $(NASMOPT64) -I$(INCDIR) -l asmtime64.lst -o asmtime64.o $<
	$(LD) -o $@ asmtime64.o

.PHONY: clean
clean:
	rm -f *.o *.lst $(TARGETS)

