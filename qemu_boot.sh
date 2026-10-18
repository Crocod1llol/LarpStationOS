#!/bin/bash

img="os.img"

#use ide (a hard disk bus) or floppy, whichever you want
qemu-system-i386 -drive file=$img,format=raw,if=ide -m 512M 
#i no longer need floppy drive, so ill not use it
#-drive file="./misc_utils/floppy.img",format=raw,if=floppy

