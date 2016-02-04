PREFIX=mipsel-none-elf-
AS="${PREFIX}as"
CC="${PREFIX}gcc"
LD="${PREFIX}ld"
OBJCOPY="${PREFIX}objcopy"

bootloader.srec: bootloader.elf Makefile
	${OBJCOPY} bootloader.elf -O srec bootloader.srec

bootloader.elf: init.o main.o linker.ld p32mx250f128b.o
	${LD} -nostdlib init.o main.o p32mx250f128b.o -o bootloader.elf -T linker.ld

p32mx250f128b.o: p32mx250f128b.s
	${AS} -mips32r2 -EL p32mx250f128b.s -o p32mx250f128b.o

init.o: init.s
	${AS} -mips32r2 -EL init.s -o init.o

main.o: main.c pic.h
	${CC} -O1 -msoft-float -EL -march=m4k -nostdlib -c main.c

.PHONY: clean
clean:
	rm -f bootloader.srec bootloader.elf init.o main.o p32mx250f128b.o
