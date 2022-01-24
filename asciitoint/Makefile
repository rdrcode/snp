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
CFLAGS      = -Wall -g -std=gnu11 -O2 -fno-inline-small-functions

OS          := $(shell uname -s)
ARCH        := $(shell uname -m)

TARGETS     = asciitoint

.SECONDARY: main.o

.PHONY: all
all: $(TARGETS)

asciitoint : main.o asciitoint.o
	$(CC) $(CFLAGS) -o $@ $^

%.o : %.asm
	$(NASM) $(NASMOPT64) -l $(basename $<).lst -o $@ $<

%.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $<

.PHONY: clean
clean:
	rm -f *.o *.lst $(TARGETS)

