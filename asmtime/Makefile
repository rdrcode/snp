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
CFLAGS      = -Wall -g -std=gnu99 -O2
INCDIR      = ../syscall/

TARGETS     = asmtime1 asmtime2

.PHONY: all
all: $(TARGETS)

asmtime1 : asmtime1.asm $(INCDIR)/syscall.inc
	$(NASM) $(NASMOPT32) -I$(INCDIR) -l asmtime1.lst -o asmtime1.o $<
	$(LD) -melf_i386 -o $@ asmtime1.o

asmtime2 : asmtime2.asm $(INCDIR)/syscall.inc
	$(NASM) $(NASMOPT64) -I$(INCDIR) -l asmtime2.lst -o asmtime2.o $<
	$(LD) -o $@ asmtime2.o

.PHONY: clean
clean:
	rm -f *.o *.lst $(TARGETS)

