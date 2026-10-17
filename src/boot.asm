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
  
;reads a number of sectors and puts them in mem address 0x8500

;params: al (amount of sectors to read); ch (the target cylinder); 
;cl (the target sector); dh (the target head);
; dl (the target drive number)
;
;ex of arguments
;mov al, 1                ; read one sector
;mov ch, 0                ; cylinder 0
;mov cl, 2                ; sector 2 (sector numbers start at 1)
;mov dh, 0                ; head 0
;mov dl, [boot_drive]  ; the drive number, its the one that is saved at boot

read_disk_sector:

    mov bx, 0x8500           ;destination
    mov ah, 0x02             ; the target func of int 0x13 to read sectors

    int 0x13
    jc disk_error

    ret
    
disk_error:
    mov si, disk_err_msg
    call printer

_start: 
    ;data segments
    ;so we cant move 0 directly, so ill just use ax as a value
    mov ax, 0

    mov ds, ax
    mov es, ax

    ;setup stack pointer
    mov ss, ax
    mov sp, 0x7C00

    ; save the provided drive number we booted from
    mov [boot_drive], dl     

    ;call funny func
    ;mov si, hello
    ;call printer

    ;setup params
    mov al, 1                
    mov ch, 0                
    mov cl, 2                
    mov dh, 0                
    mov dl, 0x00
    call read_disk_sector

    ;try to print the mem that the previous func put
    mov si, 0x8500
    call printer

    ;then halt
    jmp halt

halt:
    jmp halt


hello: db "LarpStationOS: indev build; im trying to use assembly i swear",0

disk_err_msg: db "Reading disk failed",0

boot_drive: db 0

;return the program size
times 510-($-$$) db 0
;magic signature for bootable disks
dw 0xAA55
