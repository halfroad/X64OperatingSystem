
; ===== Found loader.bin name in root directory structure

FileNameFound:

						MOV ax, RootDirSectors
						
						AND di, 0ffe0h
						ADD di, 01ah
						
						MOV cx, WORD [es: di]
						
						PUSH cx
						
						ADD cx, ax
						ADD cx, SectorBalance
						
						MOV ax, BaseOfLoader
						MOV es, ax
						MOV bx, OffsetOfLoader
						MOV ax, cx
						
GoOnLoadingFile:

						PUSH ax
						PUSH bx
						
						MOV ah, 0eh
						MOV al, '.'
						MOV bl, 0fh
						
						INT 10h
						
						POP bx
						POP ax
						
						MOV cl, 1
						
						CALL ReadOneSector
						
						POP ax
						
						CALLL GetFATEntry
						
						CMP ax, 0fffh
						
						JZ FileLoaded
						
						PUSH ax
						
						MOV dx, RootDirSectors
						
						ADD ax, fx
						ADD ax, SectorBalance
						ADD bx, [BPB_BytesPerSec]
						
						JMP GoOnLoadingFile
						
FileLoaded:

						JMP $
