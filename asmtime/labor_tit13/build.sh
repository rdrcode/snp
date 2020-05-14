#!/bin/bash

if [ "$#" -eq 0 ]; then
    echo "Purpose: Call NASM and Linker for each assembly source file (.asm)"
    echo "Usage: $0 FILE [FILE]..."
    exit 1
fi

for f in "$@"; do
    bname=${f%.*}
    nasm -f elf -o ${bname}.o ${bname}.asm && ld -melf_i386 -o ${bname} ${bname}.o && echo ${bname}": Done!"
done

