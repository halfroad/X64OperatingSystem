; Reset floppy

XOR ah, ah
XOR dl, dl

INT 13h

jmp $
