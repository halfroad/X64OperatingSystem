					ORG 0x7c00

BaseOfStack				EQU 0x7c00
BaseOfLoader				EQU 0x1000
OffsetOfLoader				EQU 0x00

RootDirSectors				EQU 14
SectorNumberOfRootDirectoryStart	EQU 19
SectorNumberOfFAT1Start			EQU 1
SectorBalance				EQU 17

					JMP SHORT Start

					NOP

BS_OEMName				DB "Mine Boot"
BPM_BytesPerSec				DW 512
BPM_SecPerClus				DB 1
BPM_RsvdSecCnt				DW 1
BPMNumFATs				DB 2
BPM_RootEntCnt				DW 224
BPM_TotSec16				DW 2880
BPM_Media				DB 0xF0
BPM_FATSz16				DW  9
BPM_SecPerTrk				DW 18
BPM_NumHeads				DW 2
BPM_HiddSec				DD 0
BPM_TotSec32				DD 0
BS_DrvNum				DB 0
BS_Reserved1				DB 0
BS_BootSig				DB 29h
Bs_VolID				DD 0
BS_VolLab				BD "Boot Loader"
BS_FileSysType				DB "FAT12	"
