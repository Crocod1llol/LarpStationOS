;BOOTLOADER ASM file
org 0x7C00

bits 16

jmp _start

;printers a string to print (yes this is true)
;needs si reg (containing a string) param 
printer:
    ;push into stack so we save the original register
    push si

    jmp printer_loop

printer_loop:
    lodsb ;loads the next char in al
    or al, al ; bitwise or so that we can detect is its 0
    jz printer_done ;jumps if 0

    mov ah, 0x0e ;mov bios interupt param
    int 0x10

    jmp printer_loop
    
printer_done:
    pop si
    ret


_start: 
    ;data segments
    ;ok so we cant move 0 directly, so ill just use ax as a value
    mov ax, 0

    mov ds, ax
    mov es, ax

    ;setup stack pointer
    mov ss, ax
    mov sp, 0x7C00

    ;call funny func
    mov si, hi
    call printer

    jmp halt

halt:
    jmp halt


hi: db "akfhkdshfkjshdlfjkahlsjdfhl jashldkfjhl asjkdfhlkj shldfkjshlkjf hasl",0

;return the program size
times 510-($-$$) db 0
;magic signature for bootable disks
dw 0xAA55
