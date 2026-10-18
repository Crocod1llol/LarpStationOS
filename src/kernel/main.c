void MainKernel(void) {

    //for now it just puts the cpu to ZZZZ until i work on the next feature
    while (1) {
        asm volatile("hlt");
    }
}
