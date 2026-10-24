//this file contains video and keyboard io
#include "headers/larpbool.h"

#define VGA_ADDR ((volatile unsigned char*)0xB8000)

//general functions

//this reads one byte from an port (ex keyboard) and returns it
unsigned char inb(unsigned short port) {
    unsigned char result;

    //read the passed var port and take result
    asm volatile("inb %1, %0" : "=a"(result) : "Nd"(port));
    return result;
}

//-------------- VIDEO ---------------

//puts a char is the row/col screen
void putc(int x, int y, char c) {
    //make the index because its col and row based so yeah
    int index = (y * 80 + x) * 2;

    //put a char into the index and then increment index so we can also put color
    VGA_ADDR[index]     = c;      
    VGA_ADDR[index + 1] = 0x02;   
}

//clears the screen
void clearScreen() {

    //there are 4000 bytes on the text screen grid like idk man just set it all to 0
    for (int i = 0; i < 4000; i++) {
        VGA_ADDR[i] = 0;
    }
}

//------------------------KEYBOARD --------------------------

#define KEYBOARD_DATA_ADDR    0x60
#define KEYBOARD_STATUS_ADDR  0x64

const char scancode_table[0x3B] = {
    [0x02] = '1', [0x03] = '2', [0x04] = '3', [0x05] = '4',
    [0x06] = '5', [0x07] = '6', [0x08] = '7', [0x09] = '8',
    [0x0A] = '9', [0x0B] = '0', [0x0C] = '-', [0x0D] = '=',
    [0x0E] = '\b', [0x0F] = '\t',

    [0x10] = 'q', [0x11] = 'w', [0x12] = 'e', [0x13] = 'r',
    [0x14] = 't', [0x15] = 'y', [0x16] = 'u', [0x17] = 'i',
    [0x18] = 'o', [0x19] = 'p', [0x1A] = '[', [0x1B] = ']',
    [0x1C] = '\n',

    [0x1E] = 'a', [0x1F] = 's', [0x20] = 'd', [0x21] = 'f',
    [0x22] = 'g', [0x23] = 'h', [0x24] = 'j', [0x25] = 'k',
    [0x26] = 'l', [0x27] = ';', [0x28] = '\'', [0x29] = '`',
    [0x2B] = '\\',

    [0x2C] = 'z', [0x2D] = 'x', [0x2E] = 'c', [0x2F] = 'v',
    [0x30] = 'b', [0x31] = 'n', [0x32] = 'm', [0x33] = ',',
    [0x34] = '.', [0x35] = '/', [0x39] = ' ',
};

const char scancode_table_shift[0x3B] = {
    [0x02] = '!', [0x03] = '@', [0x04] = '#', [0x05] = '$',
    [0x06] = '%', [0x07] = '^', [0x08] = '&', [0x09] = '*',
    [0x0A] = '(', [0x0B] = ')', [0x0C] = '_', [0x0D] = '+',
    [0x0E] = '\b', [0x0F] = '\t',

    [0x10] = 'Q', [0x11] = 'W', [0x12] = 'E', [0x13] = 'R',
    [0x14] = 'T', [0x15] = 'Y', [0x16] = 'U', [0x17] = 'I',
    [0x18] = 'O', [0x19] = 'P', [0x1A] = '{', [0x1B] = '}',
    [0x1C] = '\n',

    [0x1E] = 'A', [0x1F] = 'S', [0x20] = 'D', [0x21] = 'F',
    [0x22] = 'G', [0x23] = 'H', [0x24] = 'J', [0x25] = 'K',
    [0x26] = 'L', [0x27] = ':', [0x28] = '"', [0x29] = '~',
    [0x2B] = '|',

    [0x2C] = 'Z', [0x2D] = 'X', [0x2E] = 'C', [0x2F] = 'V',
    [0x30] = 'B', [0x31] = 'N', [0x32] = 'M', [0x33] = '<',
    [0x34] = '>', [0x35] = '?', [0x39] = ' ',
};

//tries to read the KEYBOARD_DATA_ADDR after checking KEYBOARD_STATUS_ADDR and return the char
//NOTICE: returns raw scancode
unsigned char readkey() {

    //check if the keyboard status port in bit 1 is true
    if (inb(KEYBOARD_STATUS_ADDR) & 0x01) {

        //read the scancode that corresponds to a key
        const unsigned char scan_code = inb(KEYBOARD_DATA_ADDR);
        return scan_code;
    }

    //ret 0 if nothing has been pressed
    return 0;
}

//function so that its more convenient to transfort scancode into chars
unsigned char scancode_to_char(unsigned char in) {

    
    const unsigned char ret_val = scancode_table[in];

    return ret_val;
}

//check if shift is down (crazy, right?)
bool isShiftDown() {


    return false;
}
