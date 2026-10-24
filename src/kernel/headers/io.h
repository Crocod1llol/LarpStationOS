#ifndef IO_H
#define IO_H

#define VGA_ADDR ((volatile unsigned char*)0xB8000)

//general functions

//this reads one byte from an port (ex keyboard) and returns it
unsigned char inb(unsigned short port);

//--------------- VIDEO --------------------

//puts a char is the row/col screen
void putc(int x, int y, char c);

//clears the screen
void clearScreen();

//------------------------KEYBOARD --------------------------

#define KEYBOARD_DATA_ADDR    0x60
#define KEYBOARD_STATUS_ADDR  0x64

extern const char scancode_table[0x3B];

extern const char scancode_table_shift[0x3B];

//tries to read the KEYBOARD_DATA_ADDR after checking KEYBOARD_STATUS_ADDR and return the char
unsigned char readkey();

//function so that its more convenient to transfort scancode into chars
unsigned char scancode_to_char(unsigned char in);

#endif
