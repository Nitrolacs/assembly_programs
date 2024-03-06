all:
	nasm -f elf count_words.asm -o count_words.o
	gcc -no-pie -m32 -o count_words count_words.o
	./count_words
