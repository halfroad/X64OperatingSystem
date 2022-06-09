; ===================== Search kernel.bin

			MOV WORD [SectorNumber], SectorNumberOfRootDirectoryStart

	; ....

			JMP SearchInRootDirectoryBegin

; =====================  Display on screen: Error: No KERNERL Found

NoLoaderFound:

			MOV bp, NoLoaderMessage

			INT 10h

			JMP $
