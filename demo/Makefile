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
LDOPT32     =
LDOPT64     =
CFLAGS      = -Wall -g -std=gnu99 -Og
INCDIR      = ../syscall/

TARGETS     = asmtime64

.PHONY: all
all: $(TARGETS)

asmtime64.o : $(INCDIR)/syscall.inc

%.o : %.asm
	$(NASM) $(NASMOPT64) -I$(INCDIR) -l $(basename $<).lst -o $@ $<

% : %.o
	$(LD) $(LDOPT64) -o $@ $<

.PHONY: clean
clean:
	rm -f *.o *.lst $(TARGETS)

