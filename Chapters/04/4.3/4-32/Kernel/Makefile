all: system
    objcopy -I elf64-x86-64 -S -R ".eh_frame" -R ".comment" -O binary system kernel.bin
    
system: head.o main.o
    ld -b elf64-x86-64 -z muldefs -o system head.o main.o DisplayOnScreen.o -T Kernel.lds

head.o: head.S
    gcc -E head.S > head.s
    as --64 -o head.o head.s

main.o: main.c lib.h
    gcc -static -mcmodel=large -fno-builtin -m64 -c main.c -fno-stack-protector

DisplayOnScreen.o: DisplayOnScreen.c lib.h
    gcc -static -mcmodel=large -fno-builtin -m64 -c DisplayOnScreen.c -fno-stack-protector
    
clean:
    rm -rf *.o *.s~ *.s *S~ *.c~ *.h~ system Makefile~ kernel.bin
