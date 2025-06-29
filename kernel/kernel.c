// C function that will be called when SuneriOS boots
void kernel_main() {
    const char *message = "Welcome to SuneriOS CLI!";

    // VGA video memory starts at address 0xb8000
    char *video_memory = (char *) 0xb8000;

    // Each character on screen takes 2 bytes: character + color
    for (int i = 0; message[i] != '\0'; i++) {
        video_memory[i * 2] = message[i];     // ASCII character
        video_memory[i * 2 + 1] = 0x07;       // Attribute: white text on black bg
    }

    // Stay here forever so OS doesn't "exit"
    while (1) {}
}
