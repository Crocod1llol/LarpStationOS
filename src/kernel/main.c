#include "../lib/io.h"

void MainKernel(void) {

    clearScreen();
    putc(0, 5, 'a');

    while (1) {
        asm volatile("hlt");
    }

}
