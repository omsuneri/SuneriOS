/* Entry point of the kernel */
ENTRY(kernel_main)

SECTIONS {
    . = 1M;  /* Load kernel at 1MB (0x100000) in memory */

    .text : {
        *(.text)   /* Code section */
    }

    .data : {
        *(.data)   /* Global variables with values */
    }

    .bss : {
        *(.bss)    /* Global variables without initial values */
    }
}
