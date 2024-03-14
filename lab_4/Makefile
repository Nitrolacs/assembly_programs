all:
	nasm -f elf struct.asm -o struct.o
	gcc -no-pie -m32 -o struct struct.o
	./struct
