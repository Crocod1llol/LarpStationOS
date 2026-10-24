#define VGA_ADDR ((volatile unsigned char*)0xB8000)

//puts a char is the row/col screen
void putc(int x, int y, char c);

//clears the screen
void clearScreen();
