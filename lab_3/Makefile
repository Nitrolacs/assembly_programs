all:
	nasm -f elf matrix.asm -o matrix.o
	gcc -no-pie -m32 -o matrix matrix.o
	./matrix
