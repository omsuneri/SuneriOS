ENTRY(start)
OUTPUT_FORMAT(elf32-i386)

SECTIONS {
    . = 0x100000;
    
    .text ALIGN(4K) : {
        *(.multiboot)
        *(.text)
    } :exec
    
    .rodata ALIGN(4K) : {
        *(.rodata*)
    } :ro
    
    .data ALIGN(4K) : {
        *(.data)
    } :data
    
    .bss ALIGN(4K) : {
        *(COMMON)
        *(.bss)
        . = ALIGN(16);
        *(.stack)
    } :bss
    
    /DISCARD/ : {
        *(.note*)
        *(.comment)
    }
}

PHDRS {
    exec PT_LOAD FLAGS(5);  /* R-X */
    ro PT_LOAD FLAGS(4);    /* R-- */
    data PT_LOAD FLAGS(6);  /* RW- */
    bss PT_LOAD FLAGS(6);   /* RW- */
}