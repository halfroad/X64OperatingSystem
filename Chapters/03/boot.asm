									ORG 0x7c00

BaseOfStack							EQU 0x7c00
BaseOfLoader						EQU 0x1000
OffsetOfLoader						EQU 0x00

RootDirectorySectors				EQU 14
StartSectorNumberOfRootDirectory	EQU 19
StartSectorNumberOfFAT1				EQU 1
SectorBalance						EQU 17

									JMP SHORT LabelStart

									NOP

BS_OEMName							DB 'MineBoot'
BPB_BytesPerSec						DW 512
BPB_SecPerClus						DB 1
BPB_RsvdSecCnt						DW 1
BPB_NumFATs							DB 2
BPB_RootEntCnt						DW 224
BPB_TotSec16						DW 2880
BPB_Media							DB 0xf0
BPB_FATSz16							DW 9
BPB_SecPerTrk						DW 18
BPB_NumHeads						DW 2
BPB_HiddSec							DD 0
BPB_TotSec32						DD 0
BS_DrvNum							DB 0
BS_Reserved1						DB 0
BS_BootSig							DB 0x29
BS_VolID							DD 0
BS_VolLab							DB 'Boot Loader'
BS_FileSysType						DB 'FAT12   '


LabelStart:

									MOV ax, cs
									MOV ds, ax
									MOV es, ax
									MOV ss, ax
									MOV sp, BaseOfStack	; 0x7c00

; ================================= Clear screen

									MOV ax, 0600h
									MOV bx, 0700h
									MOV cx, 0
									MOV dx, 0184fh

									INT 10h

; ================================= Set focus

									MOV ax, 0200h
									MOV bx, 0000h
									MOV dx, 0000h

									INT 10h

; ================================= Display on screen: Start Booting...

									MOV ax, 1301h
									MOV bx, 000fh
									MOV dx, 0000h
									MOV cx, 10

									PUSH ax

									MOV ax, ds
									MOV es, ax

									POP ax

									MOV bp, StartBootMessage

									INT 10h


; ================================= Reset floppy

									XOR ah, ah
									XOR dl, dl

									INT 13h


; ================================= Search loader.bin

									MOV WORD [SectorNumber], StartSectorNumberOfRootDirectory	; (DW)SectorNumber = 0, StartSectorNumberOfRootDirectory = 19

BeginSearchRootDirectory:

									CMP WORD [RootDirectorySize], 0				; (DW)RootDirectorySize = RootDirectorySectors = 14
									JZ NoLoaderBin

									DEC WORD [RootDirectorySize]

									MOV ax, 00h
									MOV es, ax
									MOV bx, 8000h
									MOV ax, [SectorNumber]						; (DW)SectorNumber = 0
									MOV cl, 1

									CALL ReadOneSector

									MOV si, LoaderFileName						; db	"LOADER BIN",0
									MOV di, 8000h

									CLD	; Clear the DF (the direction flag)

									MOV dx, 10h

SearchLoaderBin:

									CMP dx, 0

									JZ MoveToNextSector

									DEC dx
									MOV cx, 11	; lenght of LoaderFileName

Compare:

									CMP cx, 0

									JZ FileNameFound

									DEC cx

									LODSB	; Load byte from the address of (e)si. The si will be increased when DF = 0; decreased when DF = 1

									CMP al, BYTE [es: di]

									JZ GoOn
									JMP Different

GoOn:

									INC di
									JMP Compare

Different:

									AND di, 0ffe0h
									ADD di, 20h
									MOV si, LoaderFileName

									JMP SearchLoaderBin

MoveToNextSector:

									ADD WORD [SectorNumber], 1
									JMP BeginSearchRootDirectory


; ================================= Display on screen: ERROR: NO LOADER FOUND

NoLoaderBin:

									MOV ax, 1301h
									MOV bx, 008ch
									MOV dx, 0100h
									MOV cx, 21

									PUSH ax,

									MOV ax, ds
									MOV es, ax

									POP ax

									MOV bp, NoLoaderMessage

									INT 10h

									JMP $


; ================================= Found loader.bin name in root directory structure

FileNameFound:

									MOV ax, RootDirectorySectors

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

									CALL GetFATEntry

									CMP ax, 0fffh

									JZ FileLoaded

									PUSH ax

									MOV dx, RootDirectorySectors

									ADD ax, dx
									ADD ax, SectorBalance
									ADD bx, [BPB_BytesPerSec]

									JMP GoOnLoadingFile

FileLoaded:

									JMP BaseOfLoader: OffsetOfLoader


; ================================= Read one sector from floppy


ReadOneSector:

									PUSH bp

									MOV bp, sp
									SUB esp, 2

									MOV BYTE [bp - 2], cl

									PUSH bx

									MOV bl, [BPB_SecPerTrk]
									DIV bl
									INC ah

									MOV cl, ah
									MOV dh, al
									SHR al, 1
									MOV ch, al
									AND dh, 1

									POP bx

									MOV dl, [BS_DrvNum]

GoOnReading:

									MOV ah, 2
									MOV al, BYTE [bp - 2]

									INT 13h

									JC GoOnReading

									ADD esp, 2

									POP bp

									RET

; ================================= Get FAT Entry

GetFATEntry:

									PUSH es
									PUSH bx
									PUSH ax

									MOV ax, 00
									MOV es, ax

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

									ADD ax, StartSectorNumberOfFAT1

									MOV cl, 2

									CALL ReadOneSector

									POP dx

									ADD bx, dx
									MOV ax, [es: bx]

									CMP BYTE [Odd], 1

									JNZ Even2

									SHR ax, 4

Even2:

									AND ax, 0fffh

									POP bx,
									POP es

									RET



; ================================= temporary variables

RootDirectorySize					DW RootDirectorySectors
SectorNumber						DW 0
Odd									DB 0



; ================================= display messages

StartBootMessage:

									DB	"Start Boot"
NoLoaderMessage:

									DB	"ERROR:No Loader Found"
LoaderFileName:

									DB	"LOADER  BIN", 0


; ================================= fill zero until whole sector

TIMES								510 - ($ - $$)	DB 0	; TIMES: Repeat. $ current address, $$ address of current sector/segment

									DW 0xaa55



