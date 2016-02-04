OUTPUT_FORMAT(elf32-little)
OUTPUT_ARCH(mips)

ENTRY(_start)

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
    } > kseg1_mem AT >kseg1_boot_mem

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

/* SFRs */

SFR_BASE = 0xbf800000;

/* Control registers */
OSCCON = 0xbf80f000;
SYSKEY = 0xbf80f230;

/* UARTs */
U1MODE = SFR_BASE + 0x6000;
U1MODECLR = U1MODE + 4;
U1MODESET = U1MODE + 8;
U1MODEINV = U1MODE + 12;
U1STA = SFR_BASE + 0x6010;
U1STACLR = U1STA + 4;
U1STASET = U1STA + 8;
U1STAINV = U1STA + 12;
U1TXREG = SFR_BASE + 0x6020;
U1RXREG = SFR_BASE + 0x6030;
U1BRG = SFR_BASE + 0x6040;
U1BRGCLR = U1BRG + 4;
U1BRGSET = U1BRG + 8;
U1BRGINV = U1BRG + 12;

/* NVM */
NVMCON = 0xbf80f400;
NVMCONCLR = 0xbf80f404;
NVMCONSET = 0xbf80f408;
NVMCONINV = 0xbf80f40c;
NVMKEY = 0xbf80f410;
NVMADDR = 0xbf80f420;
NVMDATA = 0xbf80f430;
NVMSRCADDR = 0xbf80f440;

/* PORTA */
ANSELA = 0xbf886000;
ANSELACLR = ANSELA + 4;
ANSELASET = ANSELA + 8;
ANSELAINV = ANSELA + 12;
TRISA = 0xbf886010;
TRISACLR = TRISA + 4;
TRISASET = TRISA + 8;
TRISAINV = TRISA + 12;
PORTA = 0xbf886020;
LATA = 0xbf886030;
LATACLR = LATA + 4;
LATASET = LATA + 8;
LATAINV = LATA + 12;
ODCA = 0xbf886040;
CNPUA = 0xbf886050;
CNPDA = 0xbf886060;
CNCONA = 0xbf886070;
CNENA = 0xbf886080;
CNSTATA = 0xbf886090;

/* PORTB */
ANSELB = 0xbf886100;
ANSELBCLR = ANSELB + 4;
ANSELBSET = ANSELB + 8;
ANSELBINV = ANSELB + 12;
TRISB = 0xbf886110;
TRISBCLR = TRISB + 4;
TRISBSET = TRISB + 8;
TRISBINV = TRISB + 12;
PORTB = 0xbf886120;
LBTB = 0xbf886130;
LBTBCLR = LBTB + 4;
LBTBSET = LBTB + 8;
LBTBINV = LBTB + 12;
ODCB = 0xbf886140;
CNPUB = 0xbf886150;
CNPDB = 0xbf886160;
CNCONB = 0xbf886170;
CNENB = 0xbf886180;
CNSTBTB = 0xbf886190;

/* PPS */
U1RXR = 0xbf80fa50;
RPB15R = 0xbf80fb68;
