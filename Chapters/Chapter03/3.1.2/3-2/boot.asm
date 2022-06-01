; Clear screen

MOV ax, 0600h
MOV bx, 0700h
MOV cx, 0
MOV dx, 0184h

int 10

; Set focus

MOV ax, 0200h
MOV bx, 0000h
MOV dx, 0000h

INT 10h

; Display on screen: Start Booting...

MOV ax, 1301h
MOV bx, 0000h
MOV dx, 0000h
MOV cx, 10

PUSH ax

MOV ax, ds
MOV es, ax

POP ax

MOV bp, StartBootMessage

INT 10h
