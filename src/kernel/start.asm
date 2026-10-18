;start.asm in kernel
;the linker now handles the originate address
;org 0x8000
bits 32

global kernel_start_asm
;extern the C func to we can jump to it
extern MainKernel

kernel_start_asm:

    ;idk man just setting up GDT (global descriptor table)
    ;so that we can define mem segments, sizes, addresses, and more stuff idk
    mov ax, 0x10       ; GDT data selector
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ;stack pointer now has a new location yay
    mov esp, 0x90000

    ;bye bye assembly, hello C
    jmp MainKernel
