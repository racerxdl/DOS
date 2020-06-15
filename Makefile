OBJECT_FILES=$(shell find . -name "*.o")

all: kernel.bin

start.o:
	@echo "Building start.o"
	@nasm -f elf -o start.o start.asm

kernel.main.o:
	@echo "Building kernel.o"
	ldc2 --nodefaultlib -m32 --betterC --relocation-model=static --singleobj -g -c kernel.main.d kernel.main.o

kernel.bin: start.o kernel.main.o
	@echo "Linking all"
	#@ld -melf_i386 -T linker.ld -o kernel.bin start.o kernel.main.o
	docker run --rm -it -v $(shell pwd):/tmp nolze/binutils-all ld -melf_i386 -T linker.ld -o kernel.bin start.o kernel.main.o

run:
	@qemu-system-i386 -kernel kernel.bin

clean:
	@echo "Cleaning " $(OBJECT_FILES)
	@rm -f $(OBJECT_FILES) kernel.bin