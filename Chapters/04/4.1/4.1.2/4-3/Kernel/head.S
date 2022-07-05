// ================================= Main Entry

									.SECTION	.TEXT
									
									.GLOBAL		_start
									
_start:

									MOV		$0x10,					%ax
									MOV		%ax,					%ds
									MOV		%ax,					%es
									MOV		%ax,					%fs
									MOV		%ax,					%ss
									MOV		%ax,					%esp	


// ================================= Load GDTR

									LGDT GlobalDescriptorTablePointer (%rip)	; [GlobalDescriptorTablePointer + rip]
									
									
									
// ================================= Load IDTR

									LIDT InterruptDescriptorTablePointer (%rip)	; [InterruptDescriptorTablePointer + rip]
									
									MOV		$0x10,					%ax
									MOV		%ax,					%ds
									MOV		%ax,					%es
									MOV		%ax,					%fs
									MOV		%ax,					%ss
									
									MOVQ	$0x7e00,				%rsp
									
									
// ================================= Load cr3

									MOVQ	$0x101000,				%rax
									MOVQ	%rax,					%cr3
									
									MOVQ	SwitchSegment (%rip),	%rax
									
									PUSHQ	$0x08
									PUSHQ	%rax
									
									LRETQ
									
									
// ================================= 64-bit mode code


SwitchSegment:

									.QUAD	Entry64:
									
									
Entry64:

									MOVQ	0x10,					%rax
									MOVQ	%rax,					%ds
									MOVQ	%rax,					%es
									MOVQ	%rax,					%gs
									MOVQ	%rax,					%ss
									
									MOVQ	$0xffff800000007e00,	%rsp		/* rsp address */
									
									MOVQ	EnterKernel (%rip),		%rax		/* MOVQ address */
									
									PUSHQ	$0x08
									PUSHQ	%rax
									
									LRETQ


EnterKernel:

									.QUAD	StartKernel
