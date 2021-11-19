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
LDOPT32     = -melf_i386
LDOPT64     =
CFLAGS      = -Wall -g -std=gnu99 -Og
INCDIR      = ../syscall/

OS          := $(shell uname -s)
ARCH        := $(shell uname -m)

TARGETS     = asmtime64

# Cross-compile for x86_64 target on Apple M1
ifeq ($(OS)_$(ARCH), Darwin_arm64)
NASMOPT64   = -g -f macho64
LDOPT64     = -macos_version_min 10.15 -arch x86_64 -static
endif

.PHONY: all
all: $(TARGETS)

asmtime64.o : $(INCDIR)/syscall.inc

%32.o : %32.asm
	$(NASM) $(NASMOPT32) -I$(INCDIR) -l $(basename $<).lst -o $@ $<

%64.o : %64.asm
	$(NASM) $(NASMOPT64) -I$(INCDIR) -l $(basename $<).lst -o $@ $<

%32 : %32.o
	$(LD) $(LDOPT32) -o $@ $<

%64 : %64.o
	$(LD) $(LDOPT64) -o $@ $<

.PHONY: clean
clean:
	rm -f *.o *.lst $(TARGETS)

