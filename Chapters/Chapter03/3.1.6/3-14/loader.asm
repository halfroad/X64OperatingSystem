					ORG 10000H

					MOV ax, cs
					MOV ds, ax
					MOV es, ax

					MOV ax, 0x00

					MOV ss, ax
					MOV sp, 0x7c00

; ======= display on screen: Start Loader......

					MOV ax, 1301h
					MOV bx, 000fh
					MOV dx, 0200h		; Row 2
					MOV cx, 12

					PUSH ax

					MOV ax, ds
					MOV es, ax

					POP ax

					MOV bp, StartLoaderMessage

					INT 10h

					JMP $

; ======= display messages

StartLoaderMessage:	DB "Start Loader"
