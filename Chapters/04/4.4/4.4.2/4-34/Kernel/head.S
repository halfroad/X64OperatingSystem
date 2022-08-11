SetupTaskStateSegmentDescriptor64:

									LEAQ	TaskStateSegmentDescriptorTable64(%rip),		%rdx		; Find the address and assign to rdx = TaskStateSegmentDescriptorTable64 + rip
									
									XORQ	%rax,											%rax		; Set zeros
									XORQ	%rcx,											%rcx
									
									MOVQ	$0x89,											%rax
									SHLQ	$40,											%rax
									
									MOVL	%edx,											%ecx
									SHRL	$24,											%ecx
									SHLQ	$56,											%rcx
									
									ADDQ	%rcx,											%rax
									XORQ	%rcx,											%rcx
									
									MOVL	%edx,											%ecx
									ANDL	$0xffffff,										%ecx
									
									SHLQ	$16,											%rcx
									ADDQ	%rcx,											%rax
									ADDQ	$103,											%rax
									
									LEAQ	GlobalDescriptorTable(%rip),					%rdi
									
									MOVQ	%rax,											64(%rdi)
									
									SHRQ	$32,											%rdx
									MOVQ	%rdx,											72(%rdi)
									
									MOV		$0x40,											%ax
									LTR		%ax
									
									MOVQ	EnterKernel(%rip),								%rax
									
									PUSHQ	$0x08
									PUSHQ	%rax
									
									LRETQ
									
EnterKernel:

									.QUAD	StartKernel
