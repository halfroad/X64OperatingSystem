		org 0x7c00

BaseOfStack	equ 0x7c00

Start:
		MOV ax, cs
		MOV ds, ax
		MOV es, ax
		MOV ss, ax
		MOV sp, BaseOfStack
