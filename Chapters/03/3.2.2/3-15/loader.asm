				ORG 10000h

				JMP Start

%INCLUDE			"fat12.inc"

BaseOfKernelFile		EQU 0x00
OffsetOfKernelFile		EQU 0x100000

BaseTemporaryOfKernelAddress	EQU 0x00
OffsetTemporaryOfKernelFile	EQU 0x7e00

MemoryStructBufferAddress	EQU 0x7e00
