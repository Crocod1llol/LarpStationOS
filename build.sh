#!/bin/bash

#compile bootloader first
nasm src/boot.asm -f bin -o os.img

#add bytes until it has 1.44 MB
truncate -s 1440k os.img
