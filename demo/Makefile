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
NASMOPT64   = -g -f elf64 -F dwarf
LDOPT64     =
CFLAGS      = -Wall -g -std=gnu11 -O2 -fno-inline-small-functions -static
INCDIR      = ../syscall/

TARGETS     = demo

.PHONY: all
all: $(TARGETS)

demo : demo.o uint_to_hex.o hexdigits.o
	$(LD) $(LDOPT64) -o $@ $^

nodelist.o : $(INCDIR)/syscall.inc

uint_to_hex.o : hexdigits.o

%.o : %.asm
	$(NASM) $(NASMOPT64) -I$(INCDIR) -l $(basename $<).lst -o $@ $<

%.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $<

.PHONY: clean
clean:
	rm -f *.o *.lst $(TARGETS)

