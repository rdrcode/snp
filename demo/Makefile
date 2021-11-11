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

TARGETS     = demo64

.PHONY: all
all: $(TARGETS)

demo64 : demo64.asm $(INCDIR)/syscall.inc
	$(NASM) $(NASMOPT64) -I$(INCDIR) -l demo64.lst -o demo64.o $<
	$(LD) -o $@ demo64.o

.PHONY: clean
clean:
	rm -f *.o *.lst $(TARGETS)

