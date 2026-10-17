#!/bin/bash
#this creates a 1.44 MB floppy disk image with fat12

filename="144_floppy.img"

#with strings, use the standard comparison, else for numbers use -ne (not equal)
#but it doesnt work. peak
#if [ $1 = "a" ]; then
    #filename="144_floppy.img"
#fi

dd if=/dev/zero of=./$filename bs=512 count=2880

mkfs.fat -F 12 ./$filename
