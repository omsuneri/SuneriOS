#define VGA_ADDR 0xB8000

void kprint(const char* str) {
    volatile char* vga = (volatile char*)VGA_ADDR;
    while (*str) {
        *vga++ = *str++;
        *vga++ = 0x1F;
    }
}

void kmain() {
    const char *str = "Welcome to SuneriOS !!";
    char *video = (char*)0xb8000;
    for (int i = 0; str[i] != '\0'; i++) {
        video[i * 2] = str[i];
        video[i * 2 + 1] = 0x07;
    }

    while (1);
}
