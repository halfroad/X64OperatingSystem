											ORG 10000h

											JMP LabelStart

%include									"fat12.inc"

BaseOfKernelFile							EQU 0x00
OffsetOfKernelFile							EQU 0x100000

BaseTemporaryKernelAddress					EQU 0x00
OffsetTemporaryOfKernelFile					EQU 0x7e00

MemoryStructBufferAddress					EQU 0x7e00


[SECTION GlobalDescriptorTableSection]

LabelGlobalDescriptorTable:					DD 0, 0
LabelDescriptorCode32:						DD 0x0000ffff, 0x00cf9a00
LabelDescriptorData32:						DD 0x0000ffff, 0x00cf9200

GlobalDescriptorTableLength					EQU $ - LabelGlobalDescriptorTable
GlobalDescriptorTablePointer					DW GlobalDescriptorTableLength - 1

											DD LabelGlobalDescriptorTable

SelectorCode32								EQU LabelDescriptorCode32 - LabelGlobalDescriptorTable
SelectorData32								EQU LabelDescriptorData32 - LabelGlobalDescriptorTable


[SECTION GlobalDescriptorTableSection64]

LabelGlobalDescriptorTable64:				DQ 0x0000000000000000
LabelDescriptorCode64:						DQ 0x0020980000000000
LabelDescriptorData64:						DQ 0x0000920000000000

GlobalDescriptorTableLength64				EQU $ - LabelGlobalDescriptorTable64
GlobalDescriptorTablePointer64				DW GlobalDescriptorTableLength64 - 1
											DD LabelGlobalDescriptorTable64

SelectorCode64								EQU LabelDescriptorCode64 - LabelGlobalDescriptorTable64
SelectorData64								EQU LabelDescriptorData64 - LabelGlobalDescriptorTable64

[SECTION .s16]
[BITS 16]																		; 16 bits bitwidth


LabelStart:

											MOV ax, cs
											MOV ds, ax
											MOV es, ax
											MOV ax, 0x00
											MOV ss, ax
											MOV sp, 0x7c00


; ========================================== Display the Start Loader Message on screen

											MOV ax, 1301h						; ah = 13h, subfunction: Display the string on teletype mode. al = 01h, the string only contains the string to be displayed, the cursor position is changed after displaying.
											MOV bx, 000fh						; bh: index of page. bl = property of character
											MOV dx, 0200h						; Coodinate of the start character (row, column) = (dh, dl)
											MOV cx, 12							; Length of string

											PUSH ax

											MOV ax, ds
											MOV es, ax

											POP ax

											MOV bp, StartLoaderMessage			; es: sp, the address of (base: offset) of the string to be displayed

											INT 10h


; ========================================== Open x64 address via A20

											PUSH ax

											IN al, 92h							; Read the byte from port 92h to al
											OR al, 00000010b					; Bit 1 (from 0) sets 1 will open A20, sets 0 will disable A20

											OUT 92h, al

											POP ax

											CLI									; Clear Inerrupt: to forbid Interrupt

											DB 0x66								; Prefix 0x66 for [BITs 16], 0x67 for [BITS 32]

											LGDT [GlobalDescriptorTablePointer]

											MOV eax, cr0						; eax 32 bits address. cr0, Control Register 0
											OR eax, 1							; Enable PE. (31, PG: Page), (30, CD), (29, NW), (28...Reserved...19), (18, AW), (17, Reserved), (16, WP), (15...Reserved...6), (5, NE), (4, ET), (3, TS), (2, EM), (1, MP), (0, PE)
											MOV cr0, eax


											MOV ax, SelectorData32
											MOV fs, ax

											MOV eax, cr0
											AND al, 11111110b
											MOV cr0, eax						; Disbale PE

											STI									; Set Interrupt


; ========================================== Reset Floppy

											XOR ah, ah							; MOV ah, 0h
											XOR dl, dl							; MOV dl, 0h

											INT 13h								; subfunction ah = 0: Reset Floppy


; ========================================== Search the file kernel.bin

											MOV WORD [SectorNumber], StartSectorNumberOfRootDirectory


BeginSearchKernel:

											CMP WORD [RootDirectorySize], 0
											JZ NoKernelFileFoundHandler

											DEC WORD [RootDirectorySize]

											MOV ax, 00h
											MOV es, ax

											MOV bx, 8000h
											MOV ax, [SectorNumber]

											MOV cl, 1

											Call ReadOneSector

											MOV si, KernelFileName
											MOV di, 8000h

											CLD									; Clear Direction Flag(MOV DF, 0). Set Direction Flag, STD.

											MOV dx, 10h


SearchKernel:

											CMP dx, 0
											JZ MoveToNextSector

											DEC dx
											MOV cx, 11

CompareFileName:

											CMP cx, 0
											JZ FileNameFoundHandler

											DEC cx

											LODSB								; Load String: LODSB, load byte (LODSW: load word) from DS: SI to DS: SI. DF == 0, SI & DI increses; DF == 1 decreases.

											CMP al, byte [es: di]
											JZ CompareNext

											JMP DifferentHandler

CompareNext:
											INC di

											JMP CompareFileName


DifferentHandler:
											AND di, 0ffe0h

											ADD di, 20h

											MOV si, KernelFileName

											JMP SearchKernel


MoveToNextSector:
											ADD WORD [SectorNumber], 1

											JMP BeginSearchKernel


; ========================================== Display on screen: Error: NO KERNERL Found

NoKernelFileFoundHandler:
											MOV ax, 1301h
											MOV bx, 008ch
											MOV dx, 0300h						; Row 3
											MOV cx, 21

											PUSH ax

											MOV ax, ds
											MOV es, ax

											POP ax

											MOV bp, NoKernelFileFoundMessage

											INT 10h

											JMP $

; ========================================== Found the file kernel.bin in root directory

FileNameFoundHandler:
											MOV ax, RootDirectorySectors

											AND di, 0ffe0h
											ADD di, 01ah

											MOV cx, WORD [es: di]

											PUSH cx

											ADD cx, ax
											ADD cx, SectorBalance

											MOV eax, BaseTemporaryKernelAddress	; BaseOfKernelFile
											MOV es, eax

											MOV bx, OffsetTemporaryOfKernelFile	; OffsetOfKernelFile

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

											PUSH cx
											PUSH eax
											PUSH fs
											PUSH edi
											PUSH ds
											PUSH esi

											MOV cx, 200h
											MOV ax, BaseOfKernelFile

											MOV fs, ax
											MOV edi, DWORD [OffsetOfKernelFileCount]

											MOV ax, BaseTemporaryKernelAddress
											MOV ds, ax
											MOV esi, OffsetTemporaryOfKernelFile

ReplicateKernel:				; ----------------------------------

											MOV al, byte [ds: esi]
											MOV byte [fs: edi], al

											INC esi
											INC edi

											LOOP ReplicateKernel

											MOV eax, 0x1000
											MOV ds, eax

											MOV DWORD [OffsetOfKernelFileCount], edi

											POP esi
											POP ds
											POP edi
											POP fs
											POP eax
											POP cx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

											CALL GetFATEntry

											CMP ax, 0fffh
											JZ KernelFileLoadedHandler

											PUSH ax

											MOV dx, RootDirectorySectors

											ADD ax, dx
											ADD ax, SectorBalance

											JMP GoOnLoadingFile

KernelFileLoadedHandler:
											MOV ax, 0b800h
											MOV gs, ax

											MOV ah, 0fh							; (0 - 3) 0000: Black background; (4 - 7) 1111: White font 
											MOV al, 'G'

											MOV [gs:((80 * 0 + 39) * 2)], ax	; Row 0, column 39 on the screen

StopMotors:
											PUSH dx

											MOV dx, 03f2h
											MOV al, 0

											OUT dx, al

											POP dx

; ========================================== Get memory address size type

											MOV ax, 1301h
											MOV bx, 000fh
											MOV dx, 0400h						; Row 4
											MOV cx, 24

											PUSH ax

											MOV ax, ds
											MOV es, ax

											POP ax

											MOV bp, StartGetMemoryStructMessage

											INT 10h

											MOV ebx, 0
											MOV ax, 0x00
											MOV es, ax
											MOV di, MemoryStructBufferAddress

GetMemoryStruct:
											MOV eax, 0x0e820
											MOV ecx, 20
											MOV edx, 0x534d4150

											INT 15h

											JC GetMemoryStructFailedHandler

											ADD di, 20

											CMP ebx, 0
											JNE GetMemoryStruct

											JMP GetMemoryStructSucceededHandler


GetMemoryStructFailedHandler:
											MOV ax, 1301h
											MOV bx, 008ch
											MOV dx, 0500h						; Row 5
											MOV cx, 23

											PUSH ax

											MOV ax, ds
											MOV es, ax

											POP ax

											MOV bp, GetMemoryStructErrorMessage

											INT 10h

											JMP $


GetMemoryStructSucceededHandler:
											MOV ax, 1301h
											MOV bx, 000fh
											MOV dx, 0600h						; Row 6
											MOV cx, 29

											PUSH ax

											MOV ax, ds
											MOV es, ax

											POP ax

											MOV bp, GetMemoryStructSucceededMessage

											INT 10h

; ========================================== Get SVGA information

											MOV ax, 1301h
											MOV bx, 000fh
											MOV dx, 0800h						; Row 8
											MOV cx, 23

											PUSH ax

											MOV ax, ds
											MOV es, ax

											POP ax

											MOV bp, StartGetSVGAVBEInformationMessage

											INT 10h

											MOV ax, 0x00
											MOV es, ax
											MOV di, 0x8000
											MOV ax, 4f00h

											INT 10h

											CMP ax, 004fh

											JZ .OK

; ========================================== Failed

											MOV ax, 1301h
											MOV bx, 008ch
											MOV dx, 0900h						; Row 9
											MOV cx, 23

											PUSH ax

											MOV ax, ds
											MOV es, ax

											POP ax

											MOV bp, GetSVGAVBEInformationErrorMessage
											
											INT 10h

											JMP $


.OK:
											MOV ax, 1301h
											MOV bx, 000fh
											MOV dx, 0a00h						; Row 10
											MOV cx, 29

											PUSH ax

											MOV ax, ds
											MOV es, ax

											POP ax

											MOV bp, GetSVGAVBEInformationSucceededMessage

											INT 10h


; ========================================== Get SVGA Mode Information

											MOV ax, 1301h
											MOV bx, 000fh
											MOV dx, 0c00h						; Row 12
											MOV cx, 24

											PUSH ax

											MOV ax, ds
											MOV es, ax

											POP ax

											MOV bp, StartGetSVGAModeInformationMessage

											INT 10h


											MOV ax,0x00
											MOV es, ax
											MOV si, 0x800e

											MOV esi, DWORD [es: si]
											MOV edi, 0x8200

SVGAModeInformationAcquiredHandler:
											MOV cx, WORD [es: esi]


; ========================================== Display SVGA Mode Information

											PUSH ax

											MOV ax, 00h
											MOV al, ch

											CALL DisplayAl

											MOV ax, 00h
											MOV al, cl

											CALL DisplayAl

											POP ax


; ======================================================================

											CMP cx, 0ffffh
											JZ SVGAModeInformationFinishedHandler

											MOV ax, 4f01h

											INT 10h

											CMP ax, 004fh

											JNZ SVGAModeInformationFailedHandler

											ADD esi, 2
											ADD edi, 0x100

											JMP SVGAModeInformationAcquiredHandler


SVGAModeInformationFailedHandler:
											MOV ax, 1301h
											MOV bx, 008ch
											MOV dx, 0d00h						; Row 13
											MOV cx, 24

											PUSH ax

											MOV ax, ds
											MOV es, ax

											POP ax

											MOV bp, GetSVGAModeInformationErrorMessage

											INT 10h


SetSVGAModeVESAVBEFailedHandler:
											JMP $


SVGAModeInformationFinishedHandler:
											MOV ax, 1301h
											MOV bx, 000fh
											MOV dx, 0e00h						; Row 14
											MOV cx, 30

											PUSH ax

											MOV ax, ds
											MOV es, ax

											POP ax

											MOV bp, GetSVGAModeInformationSucceededMessage

											INT 10h


; ========================================== Set the SVGA Mode (VESA, VBE)

											MOV ax, 4f02h
											MOV bx, 4180h						; Mode: 0x180 or 0x143

											INT 10h

											CMP ax, 004fh

											JNZ SetSVGAModeVESAVBEFailedHandler


; ========================================== Initialize IDt GDT, and enter Protect Mode

											CLI									; Clear Interrupt

											DB 0x66								; When under NASM [BITS 16], Data Instructive uses 0x66 as prefix, Address Instructive uses 0x67 as prefix
											LGDT [GlobalDescriptorTablePointer]

										;	DB 0x66
										;	LIDT [InterruptDescripberTablePointer]

											MOV eax, cr0
											OR eax, 1
											MOV cr0, eax

											JMP DWORD SelectorCode32: EnterTemporaryProtectMode


[SECTION .s32]
[BITS 32]


EnterTemporaryProtectMode:

; ========================================== Enter temporary Long Mode

											MOV ax, 0x10

											MOV ds, ax
											MOV es, ax
											MOV fs, ax
											MOV ss, ax

											MOV esp, 7e00h

											CALL CheckSupportLongMode

											TEST eax, eax

											JZ NotSupport


; ========================================== Initialize temporary Page Table 0x90000

											MOV DWORD [0x90000], 0x91007
											MOV DWORD [0x90800], 0x91007

											MOV DWORD [0x91000], 0x92007

											MOV DWORD [0x92000], 0x000083

											MOV DWORD [0x92008], 0x200083

											MOV DWORD [0x92010], 0x400083

											MOV DWORD [0x92018], 0x600083

											MOV DWORD [0x92020], 0x800083

											MOV DWORD [0x92028], 0xa00083


; ========================================== Load Global Descriptor Table Register

											DB 0x66

											LGDT [GlobalDescriptorTablePointer64]

											MOV ax, 0x10

											MOV ds, ax
											MOV es, ax
											MOV fs, ax
											MOV gs, ax
											MOV ss, ax

											MOV esp, 7e00h

; ========================================== Enable Physical Address Extension （PAE）

											MOV eax, cr4
											BTS eax, 5							; BTS， bit set
											MOV cr4, eax


; ========================================== Load cr3

											MOV eax, 0x90000
											MOV cr3, eax


; ========================================== Enable Long Mode

											MOV ecx, 0c0000080h					; IA32_EFER, Extended Feature Enable Register

											RDMSR								; Read Mode Specific Register

											BTS eax, 8

											WRMSR								; Write Mode Specific Register


; ========================================== Enable PE and Paging

											MOV eax, cr0

											BTS eax, 0
											BTS eax, 31

											MOV cr0, eax

											JMP SelectorCode64: OffsetOfKernelFile


; ========================================== Check the support of Long Mode

CheckSupportLongMode:

											MOV eax, 0x80000000

											CPUID

											CMP eax, 0x80000001

											SETNB al

											JB SupportLongModeDoneHandler

											MOV eax, 0x80000001

											CPUID

											BT edx, 29

											SETC al


SupportLongModeDoneHandler:
											MOVZX eax, al

											RET


; ========================================== Not Support

NotSupport:
											JMP $


; ========================================== Read one sector from Floppy

[SECTION .s16lib]
[BITS 16]


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


; ========================================== Get FAT Entry

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

											JZ LabelEven

											MOV BYTE [Odd], 1


LabelEven:
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

											JNZ LabelEven2

											SHR ax, 4


LabelEven2:
											AND ax, 0fffh

											POP bx
											POP es

											RET


; ========================================== Display number in al

DisplayAl:
											PUSH ecx
											PUSH edx
											PUSH edi

											MOV edi, [DisplayPosition]

											MOV ah, 0fh
											MOV dl, al

											SHR al, 4

											MOV ecx, 2


.Begin:
											AND al, 0fh

											CMP al, 9

											JA .GreaterThan9

											ADD al, '0'

											JMP .LessThanOrEqual9


.GreaterThan9:
											SUB al, 0ah

											ADD al, 'A'


.LessThanOrEqual9:
											MOV [gs: edi], ax

											ADD edi, 2

											MOV al, dl

											LOOP .Begin

											MOV [DisplayPosition], edi

											POP edi
											POP edx
											POP ecx

											RET


; ========================================== Temporary Interrupt Descriptor Table (IDT)

InterruptDescriptorTable:

											TIMES 0x50 DQ 0

InterruptDescriptorTableEnd:


InterruptDescriptorTablePointer:
											DW InterruptDescriptorTableEnd - InterruptDescriptorTable - 1
											DD InterruptDescriptorTable


; ========================================== Temporary Variables

RootDirectorySize					        DW RootDirectorySectors
SectorNumber								DW 0
Odd											DB 0
OffsetOfKernelFileCount						DD OffsetOfKernelFile

DisplayPosition								DD 0



; ========================================== Display Messages

StartLoaderMessage:
											DB "Start Loader"
NoKernelFileFoundMessage:
											DB "Error:No KERNEL Found"
KernelFileName:
											DB "KERNEL  BIN", 0
StartGetMemoryStructMessage:
											DB "Start Get Memory Struct."
GetMemoryStructErrorMessage:
											DB "Get Memory Struct ERROR"
GetMemoryStructSucceededMessage:
											DB "Get Memory Struct SUCCESSFUL!"


StartGetSVGAVBEInformationMessage:
											DB "Stsrt Get SVGA VBE Info"
GetSVGAVBEInformationErrorMessage:
											DB "Get SVGA VBE Info ERROR"
GetSVGAVBEInformationSucceededMessage:
											DB "Get SVGA VBE Info SUCCESSFUL!"


StartGetSVGAModeInformationMessage:
											DB "Start Get SVGA Mode Info"
GetSVGAModeInformationErrorMessage:
											DB "Get SVGA Mode Info ERROR"
GetSVGAModeInformationSucceededMessage:
											DB "Get SVGA Mode Info SUCCESSFUL!"
