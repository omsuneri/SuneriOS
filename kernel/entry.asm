[bits 32]
section .multiboot
align 4
    dd 0x1BADB002              ; Magic number
    dd 0x00                    ; Flags
    dd -(0x1BADB002 + 0x00)    ; Checksum

section .text
global start
extern kmain

start:
start:
    ; Debug: Print 'E' to serial port (if kernel runs)
    mov dx, 0x3F8   ; COM1 serial port
    mov al, 'E'
    out dx, al

    ; Set up stack (16-byte aligned)
    mov esp, stack_top - 16
    
    ; Push Multiboot info
    push ebx                    ; Multiboot info structure
    push eax                    ; Magic number
    
    ; Clear direction flag
    cld
    
    ; Call kernel main
    call kmain
    
    ; Halt if kmain returns
    hlt

section .bss
align 16
stack_bottom:
    resb 16384                  ; 16KB stack
stack_top: