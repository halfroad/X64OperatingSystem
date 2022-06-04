; ======== Read one sector from floppy

ReadOneSector:		PUSH	bp

			MOV	bp, sp
			SUB 	esp, 2

			MOV	BYTE [bp - 2], cl

			PUSH	bx

			MOV	bl, [BPM_SecPerTrk]
			DIV	bl
			INC	ah

			MOV	cl, ah
			MOV	dh, al
			SHR	al, 1
			MOV	ch, al
			AND	dh, 1

			POP	bx

			MOV	dl, [BS_DrvNum]

GoOnReading:		MOV 	ah, 2
			MOV	al, BYTE [bp - 2]

			INT 	13h

			JC	GoOnReading

			ADD	esp, 2

			POP	bp

			RET
