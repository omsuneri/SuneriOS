CC = x86_64-elf-gcc
LD = x86_64-elf-ld
CFLAGS = -ffreestanding -O2 -Wall -Wextra
LDFLAGS = -T linker.ld

KERNEL_OBJS = kernel/kernel.o

all: iso/boot/kernel.bin os.iso

# Compile the kernel.c file into an object file
kernel/kernel.o: kernel/kernel.c
	$(CC) $(CFLAGS) -c $< -o $@

# Link the object file into a kernel binary
iso/boot/kernel.bin: $(KERNEL_OBJS)
	$(LD) $(LDFLAGS) $^ -o $@

# Create the bootable ISO using the cross GRUB
os.iso: iso/boot/kernel.bin grub.cfg
	cp grub.cfg iso/boot/grub/
	x86_64-elf-grub-mkrescue -o os.iso iso

# Clean build artifacts
clean:
	rm -f $(KERNEL_OBJS) iso/boot/kernel.bin os.iso
	