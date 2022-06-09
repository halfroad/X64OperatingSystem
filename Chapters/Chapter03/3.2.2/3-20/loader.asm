FileLoaded:
			MOV ax, 0b800h

			MOV gs, ax
			MOV ah, 0fh		; 0000: black background, 1111: white font

			MOV al, "G"

			MOV [gs: (80 * 0 + 39)  * 2], ax	; Row 0, column 39

