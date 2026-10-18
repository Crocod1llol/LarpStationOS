#!/bin/bash

#yes, this build script and linker and all is made by someone else cause i dont wanna build
#thanks for understanding

#compile bootloader first
nasm src/boot.asm -f bin -o boot.bin 

#compile as elf32 so we can use externs and then we will strip the elf part and have the bin
nasm src/kernel/start.asm -f elf32 -o start_kernel.o
gcc -m32 -ffreestanding -fno-pie -fno-pic -fno-stack-protector -fno-builtin -Wl,--section-start=.text=0x8000 -c src/kernel/main.c -o kernel_main.o

#link em using linker.ld config file
ld -m elf_i386 -T linker.ld -o kernel.bin --oformat binary start_kernel.o kernel_main.o

#now link the boot and the rest of the compiled binaries
cat boot.bin kernel.bin > os.img

#del temp files
rm *.bin *.o
