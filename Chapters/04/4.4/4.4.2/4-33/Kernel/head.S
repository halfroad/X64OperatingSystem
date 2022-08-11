
ENTRY64:


;.......

SetupInterruptDescriptorTable:

									LEAQ	IgnoreInit(%rip),				%rdx		; Find the address and assign to rdx = IgnoreInit + rip
									
									MOVQ	$(0x08 << 16),					%rax		; 1 byte,	0x08h: 				0000 1000b
																						; 0x08h << 16: 0000 1000, 0000 0000, 0000 0000b, 0x080000
																				
																						; %rax = 0x080000
																						; %rax = 0x 00 00 00 00 00 08 00 00
																				
																						; 2 bytes,	0x00 08h:			0000 0000, 0000 1000b
																						; 4 bytes,	0x00 00 00 08h:		0000 0000, 0000 0000, 0000 0000, 0000 1000b
									
									MOVW	%dx,							%ax			; ax = dx, MOVW
									
									MOVQ	$(0x8e00 << 32),				%rcx		; 0x8e00h = 1000 1110, 0000 0000b
																						; 0x8e00 << 32 = 1000 1110, 0000 0000, 0000 0000, 0000 0000, 0000 0000, 0000 0000
																						; rcx = 0x8e00 << 32 = 0x 00 00 8e 00 00 00 00 00h = 0000 0000, 0000 0000, 1000 1110, 0000 0000, 0000 0000, 0000 0000, 0000 0000, 0000 0000
									
									ADDQ	%rcx,							%rax
									MOVL	%edx,							%ecx
									SHRL	$16,							%ecx
									SHLQ	$48,							%rcx
									
									ADDQ	%rcx,							%rax
									SHRQ	$32,							%rdx
									LEAQ	InterruptDescriptorTable(%rip),	%rdi
									
									MOV		$356,							%rcx
									
RpsInterruptDescriptorTable:

									MOVQ	%rax,							(%rdi)
									MOVQ	%rdx,							8(%rdi)
									
									ADDQ	$0x10,							%rdi
									
									DEC		%rcx
									
									JNE		RpsInterruptDescriptorTable
									
									
