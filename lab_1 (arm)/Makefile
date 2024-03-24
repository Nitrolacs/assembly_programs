all:
	arm-linux-gnueabi-as program.s -o program.o
	arm-linux-gnueabi-gcc-10 program.o -o program.elf -static
	qemu-arm ./program.elf
