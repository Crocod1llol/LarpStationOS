#!/bin/bash

img="os.img"

qemu-system-i386 -drive file=$img,format=raw,if=floppy -m 512M
