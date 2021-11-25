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
CFLAGS      = -Wall -g -std=gnu17 -O2 -fno-inline-small-functions
INCDIR      = ../syscall/

OS          := $(shell uname -s)
ARCH        := $(shell uname -m)

CSRCS       := $(wildcard strtoupper?.c)
COBJS       := $(patsubst %.c,%.o,$(CSRCS))
CPRGS       := $(patsubst %.c,%,$(CSRCS))

TARGETS     = toupper32 toupper64

.SECONDARY: $(COBJS) main.o


# Cross-compile for x86_64 target on Apple M1
ifeq ($(OS)_$(ARCH), Darwin_arm64)
NASMOPT64   = -g -f macho64
LDOPT64     = -macos_version_min 10.15 -arch x86_64 -static
TARGETS     = toupper64
endif

TARGETS     += $(CPRGS)

.PHONY: all
all: $(TARGETS)

strtoupper% : main.o strtoupper%.o
	$(CC) $(CFLAGS) -o $@ $^

toupper32.o : $(INCDIR)/syscall.inc
toupper64.o : $(INCDIR)/syscall.inc

%32.o : %32.asm
	$(NASM) $(NASMOPT32) -I$(INCDIR) -l $(basename $<).lst -o $@ $<

%64.o : %64.asm
	$(NASM) $(NASMOPT64) -I$(INCDIR) -l $(basename $<).lst -o $@ $<

%32 : %32.o
	$(LD) $(LDOPT32) -o $@ $<

%64 : %64.o
	$(LD) $(LDOPT64) -o $@ $<

%.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $<

.PHONY: test
test:
	@rm -f uc.txt
	@tr [a-z] [A-Z] < loremipsum.txt > uc.txt
	@for i in $(TARGETS); do \
		echo -n "Testing" $$i ": " ; \
		./$$i < loremipsum.txt > tmp.txt ; \
		diff --brief uc.txt tmp.txt > /dev/null ; \
		if [ $$? != 0 ]; then \
			echo "FAIL" ; \
		else \
			echo "OK" ; \
		fi ; \
		rm -f tmp.txt ; \
	done
	@rm -f uc.txt


.PHONY: clean
clean:
	rm -f *.o *.lst $(TARGETS)

