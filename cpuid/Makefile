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

TARGETS     = cpuid32 cpuid64

.PHONY: all
all: $(TARGETS)

cpuid32 : cpuid32.asm $(INCDIR)/syscall.inc
	$(NASM) $(NASMOPT32) -I$(INCDIR) -l cpuid32.lst -o cpuid32.o $<
	$(LD) -melf_i386 -o $@ cpuid32.o

cpuid64 : cpuid64.asm $(INCDIR)/syscall.inc
	$(NASM) $(NASMOPT64) -I$(INCDIR) -l cpuid64.lst -o cpuid64.o $<
	$(LD) -o $@ cpuid64.o

.PHONY: clean
clean:
	rm -f *.o *.lst $(TARGETS)

