		ORG 0x7c00

BaseOfStack		EQU 0x7c00

; Initialize registers

Start:
			MOV ax, cs
			MOV ds, ax
			MOV es, ax
			MOV ss, ax
			MOV sp, BaseOfStack

; INTERRUPT 10h
; INT 10h, subfunction ah = 06h: Scroll the sized window. Clear screen if al = 0

			MOV ax, 0600h	; Clear the screen
			MOV bx, 0700h	; bh specifies the color for the space left
			MOV cx, 0	; ch specifies the column of top-left corner,
				; cl specifies the row of the top-left corner
			MOV dx, 0184h	; dx specifies the column & row of bottom-right

			INT 10h

; INT 10h, subfunction ah = 02h: Set focus. 

			MOV ax, 0200h
			MOV bx, 0000h
			MOV dx, 0000h

			INT 10h

; INT 10h, subfunction ah = 12h: Display on screen

			MOV ax, 1301h	; al, write mode 
			MOV bx, 000fh	; bh, index of page
			MOV dx, 0000h	; dh, the row of cursor; dl, cursor column
			MOV cx, 10	; The length of string

			PUSH ax

			MOV ax, ds
			MOV es, ax	; es: bp, the address of string

			POP ax

			MOV bp, StartBootMessage

			INT 10h

;INT 13, ah = 0: Reset the floppy. dl = 00h, Drive A. dl = 01h, Drive B.
; dl = 80h, 1st hard disk. dl = 81h, 2nd hard disk. 

			XOR ah, ah	; Set zeros
			XOR al, al	; Set zeros

			INT 13h

			JMP $		; Halt

StartBootMessage:	DB "Start Boot"

; Fill out zeros until whole sector
; 510 = 512 - 2. $ = current address (IP), $$ address of Section/Segment
			TIMES 510 - ($ - $$) DB 0

			DW 0xaa55	; Ending placeholder
