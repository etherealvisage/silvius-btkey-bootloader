PREFIX=mipsel-none-elf-
MIPS_AS="${PREFIX}as"
MIPS_CC="${PREFIX}gcc"
MIPS_LD="${PREFIX}ld"
MIPS_OBJCOPY="${PREFIX}objcopy"

bootloader.srec: bootloader.elf Makefile
	${MIPS_OBJCOPY} bootloader.elf -O srec bootloader.srec

bootloader.elf: init.o main.o linker.ld p32mx250f128b.o
	${MIPS_LD} -nostdlib init.o main.o p32mx250f128b.o -o bootloader.elf -T linker.ld

p32mx250f128b.o: p32mx250f128b.s
	${MIPS_AS} -mips32r2 -EL p32mx250f128b.s -o p32mx250f128b.o

init.o: init.s
	${MIPS_AS} -mips32r2 -EL init.s -o init.o

main.o: main.c pic.h
	${MIPS_CC} -O1 -msoft-float -EL -march=m4k -nostdlib -c main.c

transfer: transfer.c
	$(CC) transfer.c -o transfer

.PHONY: clean
clean:
	rm -f bootloader.srec bootloader.elf init.o main.o p32mx250f128b.o transfer
