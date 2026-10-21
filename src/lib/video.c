#define VGA_ADDR ((volatile unsigned char*)0xB8000)

//puts a char is the row/col screen
void putc(int x, int y, char c) {
    //make the index because its col and row based so yeah
    int index = y * 80 + x;

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
