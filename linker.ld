OUTPUT_FORMAT(elf32-little)
OUTPUT_ARCH(mips)

ENTRY(_start)

/* Change these to suit. */
RAM_SIZE = 32 * 1024;
FLASH_SIZE = 128 * 1024;

RESET_ADDR = 0xbfc00000;

MEMORY {
    kseg0_program           : ORIGIN = 0x9d000000, LENGTH = FLASH_SIZE
    kseg0_init_mem          : ORIGIN = 0x9fc00000, LENGTH = 0x100
    kseg0_boot_mem          : ORIGIN = 0x9fc00100, LENGTH = 0xaf0
    kseg0_mem               : ORIGIN = 0x80000000, LENGTH = RAM_SIZE

    kseg1_program           : ORIGIN = 0xbd000000, LENGTH = FLASH_SIZE
    kseg1_init_mem          : ORIGIN = 0xbfc00000, LENGTH = 0x100
    kseg1_boot_mem          : ORIGIN = 0xbfc00000, LENGTH = 0xaf0
    kseg1_mem               : ORIGIN = 0xa0000000, LENGTH = RAM_SIZE
    config_mem              : ORIGIN = 0xbfc00bf0, LENGTH = 0x10

    sfrs                    : ORIGIN = 0xbf800000, LENGTH = 0x100000
}

PHDRS {
    code_header PT_LOAD;
    cfg_header PT_LOAD;
}

SECTIONS {
    /* Main code */
    .code RESET_ADDR : {
        *(.reset)
        *(.text)
        *(.rodata)
        *(.rodata.*)
    } > kseg1_boot_mem :code_header

    /* Configuration registers */
    .devcfg3 0xbfc00bf0 : {
        KEEP (*.devcfg3)
    } > config_mem :cfg_header
    .devcfg2 0xbfc00bf4 : {
        KEEP (*.devcfg2)
    } > config_mem :cfg_header
    .devcfg1 0xbfc00bf8 : {
        KEEP (*.devcfg1)
    } > config_mem :cfg_header
    .devcfg0 0xbfc00bfc : {
        KEEP (*.devcfg0)
    } > config_mem :cfg_header

    .data_begin : {
        data_flash_begin = .;
    } > kseg1_boot_mem

    /* Initialized non-constant globals */
    .data : {
        data_ram_begin = .;
        *(.data)
        *(.sdata)
        data_ram_end = .;
    } > kseg1_mem AT >kseg1_boot_mem :code_header

    .data_end : {
        data_flash_end = .;
    } > kseg1_boot_mem

    .bss : {
        bss_ram_begin = .;
        *(.bss)
        *(.sbss)
        bss_ram_end = .;
    } > kseg1_mem

    _gp = 0xa0008000;
    _sp = 0xa0008000; /* TODO: change if RAM size is different */

    /DISCARD/ : {
        *(.reginfo)
        *(.gnu.attributes)
        *(.comment)
        *(.pdr)
        *(.MIPS.abiflags)
    }
}
