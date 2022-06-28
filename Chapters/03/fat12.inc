RootDirectorySectors				EQU 14
SectorNumberOfRootDirectoryStart	EQU 19
SectorNumberOfFAT1Start				EQU 1
SectorBalance						EQU 17

; FAT12 Data Structure
BS_OEMName							DB "MineBoot"
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
BS_BootSig							DB 29h
BS_VolID							DD 0
BS_VolLab							DB "Boot Loader"
BS_FileSysType						DB "FAT12   "
