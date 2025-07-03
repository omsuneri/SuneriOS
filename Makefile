CC = i686-elf-gcc
ASM = nasm
LD = i686-elf-ld
GRUB_MKRESCUE = i686-elf-grub-mkrescue # if you installed that

all: os-image sunerios.iso

os-image: kernel/kernel.bin
	cp $< $@  # Just copy the kernel binary as the final image

sunerios.iso: os-image
	@echo "Creating ISO structure..."
	@mkdir -p iso/boot/grub
	@cp os-image iso/boot/
	@echo 'menuentry "SuneriOS" {' > iso/boot/grub/grub.cfg
	@echo '    set root=(cd)' >> iso/boot/grub/grub.cfg
	@echo '    multiboot /boot/os-image' >> iso/boot/grub/grub.cfg
	@echo '    boot' >> iso/boot/grub/grub.cfg
	@echo '}' >> iso/boot/grub/grub.cfg
	
	@echo "Building ISO with GRUB..."
	i686-elf-grub-mkrescue -o sunerios.iso iso  # Use THIS instead of xorriso directly
	
boot/boot.bin: boot/boot.asm
	$(ASM) -f bin $< -o $@

kernel/kernel.bin: kernel/entry.o kernel/main.o
	$(LD) -T linker.ld -o $@ $^ -nmagic -z max-page-size=0x1000
	@if command -v grub-file >/dev/null; then \
		grub-file --is-x86-multiboot $@ || (echo "Not Multiboot compliant!"; exit 1); \
	else \
		echo "Warning: grub-file not found, skipping Multiboot verification"; \
	fi

kernel/entry.o: kernel/entry.asm
	$(ASM) -f elf32 $< -o $@

kernel/main.o: kernel/main.c
	$(CC) -c $< -o $@ -ffreestanding -nostdlib -O1 -Wall

run: os-image
	qemu-system-x86_64 -drive format=raw,file=os-image -display curses

run-iso: sunerios.iso
	qemu-system-x86_64 -cdrom sunerios.iso -display curses

clean:
	rm -rf boot/boot.bin kernel/kernel.bin os-image kernel/*.o iso sunerios.iso

.PHONY: all clean run run-iso