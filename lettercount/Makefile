#=============================================================================
#
# Makefile
#
#-----------------------------------------------------------------------------
#
# DHBW Ravensburg - Campus Friedrichshafen
#
# Vorlesung Systemnahe Programmierung
#
# Author: Ralf Reutemann
# Created: 2021-12-02
#
#=============================================================================

CC          = gcc
LD          = ld
NASM        = nasm
NASMOPT32   = -g -f elf -F dwarf
NASMOPT64   = -g -f elf64 -F dwarf
LDOPT32     = -melf_i386
LDOPT64     =
CFLAGS      = -Wall -g -std=gnu17 -O2
INCDIR      = ../syscall/

OS          := $(shell uname -s)
ARCH        := $(shell uname -m)

TARGETS     = lettercount64 genchartable

# Cross-compile for x86_64 target on Apple M1
ifeq ($(OS)_$(ARCH), Darwin_arm64)
NASMOPT64   = -g -f macho64
LDOPT64     = -macos_version_min 10.15 -arch x86_64 -static
endif

.PHONY: all
all: $(TARGETS)

lettercount64: lettercount64.o asciitable64.o uint_to_ascii64.o
	$(LD) $(LDOPT64) -o $@ $^

lettercount64.o : $(INCDIR)/syscall.inc

asciitable64.o: asciitable.asm asciitable.inc
	$(NASM) $(NASMOPT64) -o $@ $<

asciitable.inc: genchartable
	./genchartable > $@

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
	rm -f *.o *.lst asciitable.inc $(TARGETS)

