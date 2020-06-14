OBJECT_FILES=$(shell find . -name "*.o")

all: kernel.bin

start.o:
	@echo "Building start.o"
	@nasm -f elf -o start.o start.asm

kernel.main.o:
	@echo "Building kernel.o"
	@gdc -fno-druntime -m32 -c kernel.main.d -o kernel.main.o -g

kernel.bin: start.o kernel.main.o
	@echo "Linking all"
	@ld -melf_i386 -T linker.ld -o kernel.bin start.o kernel.main.o

run:
	@qemu-system-i386 -kernel kernel.bin

clean:
	@echo "Cleaning " $(OBJECT_FILES)
	@rm -f $(OBJECT_FILES)