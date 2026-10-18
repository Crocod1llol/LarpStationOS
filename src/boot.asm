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
  
;reads a number of sectors and puts them in mem address 0x8000
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

    mov bx, 0x8000           ;destination
    mov ah, 0x02             ; the target func of int 0x13 to read sectors

    int 0x13
    jc disk_error

    ret
    
disk_error:
    mov si, disk_err_msg
    call printer
    jmp halt

halt:
    jmp halt

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
    mov si, hello
    call printer

    ;start the process to switch to 32 bit mode
    ;yay

    ;load the kernel that is in the disk
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [boot_drive]
    call read_disk_sector

    ;load the Global Descriptor Table
    lgdt [gdt_descriptor]

    ;enable protection
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    ;disable interupt
    cli 

    jmp 0x08:0x8000

hello: db "LarpStationOS: indev build; im trying to use assembly i swear",10, 0

disk_err_msg: db "Reading disk failed",0

boot_drive: db 0

;yes this is copied from somewhere else
gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; GDT size - 1
    dd gdt_start              ; GDT base address

gdt_start:
    dq 0

gdt_code:
    dw 0xFFFF
    dw 0
    db 0
    db 10011010b
    db 11001111b
    db 0

gdt_data:
    dw 0xFFFF
    dw 0
    db 0
    db 10010010b
    db 11001111b
    db 0
gdt_end:

;return the program size
times 510-($-$$) db 0
;magic signature for bootable disks
dw 0xAA55
