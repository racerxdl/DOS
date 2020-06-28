SOURCES=$(shell find kernel -name "*.d")
OBJECTS = $(SOURCES:%.d=%.o)

LD=ld
NASM=nasm

all: kernel.bin

start.o:
	@echo "Building start.o"
	@$(NASM) -f elf -o start.o start.asm

kernel.main.o:
	@echo "Building kernel.o"
	ldc2 -mtriple i386-linux-gnu --betterC --relocation-model=static --singleobj -g -c kernel.main.d kernel.main.o

%.o: %.d
	@echo "Building $< -> $@"
	ldc2 -mtriple i386-linux-gnu --betterC --relocation-model=static --singleobj -g -c "$<" -of "$@"

kernel.bin: start.o kernel.main.o $(OBJECTS)
	@echo "Linking all $(OBJECTS)"
	@$(LD) -melf_i386 -T linker.ld -o kernel.bin start.o kernel.main.o $(OBJECTS)

run:
	@qemu-system-i386 -kernel kernel.bin

docker:
	@docker run --rm -it -v $(shell pwd):/tmp racerxdl/dosbuild sh -c "make clean && make"

clean:
	@echo "Cleaning " $(OBJECT_FILES)
	@rm -f $(OBJECT_FILES) kernel.main.o kernel.bin start.o
