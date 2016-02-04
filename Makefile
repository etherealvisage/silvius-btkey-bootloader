PREFIX=mipsel-none-elf-
AS="${PREFIX}as"
CC="${PREFIX}gcc"
LD="${PREFIX}ld"
OBJCOPY="${PREFIX}objcopy"

bootloader.srec: bootloader.elf
	${OBJCOPY} bootloader.elf -O srec bootloader.srec

bootloader.elf: init.o main.o linker.ld
	${LD} -nostdlib init.o main.o -o bootloader.elf -T linker.ld

init.o: init.s
	${AS} -mips32r2 -EL init.s -o init.o

main.o: main.c
	${CC} -Os -msoft-float -EL -march=m4k -nostdlib -c main.c

.PHONY: clean
clean:
	rm -f bootloader.srec bootloader.elf init.o main.o
