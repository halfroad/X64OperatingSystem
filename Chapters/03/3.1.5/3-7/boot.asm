; ======= Search loader.bin

				MOV	WORD [SectorNo], SectorNumOfRootDirStart

SearchInRootDirBegin:
				CMP	WORD [RootDirSizeForLoop], 0
				JZ	NoLoaderBin

				DEC	WORD [RootDirSizeForLoop]

				MOV	ax, 00h
				MOV	es, ax
				MOV	bx, 8000h
				MOV	ax, [SectorNo]
				MOV	cl, 1

				CALL	ReadoneSctor

				MOV	si, LoaderFileName
				MOV	di, 8000h

				CLD	; Clear the DF (the direction flag)

				MOV 	dx, 10h

SearchForLoaderBin:
				CMP	dx, 0

				JZ	GoToNextSectorInRootDir

				DEC	dx
				MOV	cx, 11

CompareFileName:
				CMP	cx, 0

				JZ 	FileNameFound

				DEC 	cx

				LODSB	; Load byte from the address of (e)si. The si will be increased when DF = 0; decreased when DF = 1

				CMP	al, BYTE [es: di]

				JZ	GoOn
				JMP 	Different

GoOn:
				INC	di
				JMP	ComparaFileName

Different:
				AND	di, 0ffe0h
				ADD	di, 20h
				MOV	si, LoaderFileName

				JMP	SearchForLoaderBin

GoToNextSectorInRootDir:
				ADD	WORD [SectorNum], 1
				JMP	SearchInRootDirBeigin
