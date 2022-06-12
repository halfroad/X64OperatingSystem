; ===== Get FAT Entry

GetFATEntry:

					PUSH es
					PUSH bx
					PUSH ax
					
					MOV ax, 00
					mov es, ax
					
					POP ax
					
					MOV BYTE [Odd], 0
					
					MOV bx, 3
					MUL bx
					MOV bx, 2
					DIV bx
					
					CMP dx, 0
					
					JZ Even
					
					MOV BYTE [Odd], 1
					
Even:

					XOR dx, dx
					
					MOV bx, [BPB_BytesPerSec]
					
					DIV bx
					
					PUSH dx
					
					MOV bx, 8000h
					
					ADD ax, SectorNumberOfFAT1Start
					
					MOV cl, 2
					
					CALL ReadOneSector
					
					POP dx
					
					ADD bx, dx
					
					MOV ax, [es: bx]
					
					CPM BYTE [Odd], 1
					
					JNZ EVEN2
					
					SHR ax, 4
					
Even2:

					AND ax, 0fffh
					
					POP bx,
					POP ex
					
					ret
