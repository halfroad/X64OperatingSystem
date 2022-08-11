IgnoreInit:

									CLD										; Disable Interrupt
									
									PUSHQ	%rax
									PUSHQ	%rbx
									PUSHQ	%rcx
									PUSHQ	%rdx
									PUSHQ	%rbp
									PUSHQ	%rdi
									PUSHQ	%rsi
									
									PUSHQ	%r8
									PUSHQ	%r9
									PUSHQ	%r10
									PUSHQ	%r11
									PUSHQ	%r12
									PUSHQ	%r13
									PUSHQ	%r14
									PUSHQ	%r15
									
									MOVQ	%es,						%rax
									
									PUSHQ	%rax
									
									MOVQ	%ds,						%rax
									
									PUSHQ	%rax
									
									MOVQ	%0x10,						%rax
									MOVQ	%rax,						%ds
									MOVQ	%rax,						%es
									
									LEAQ	InterruptMessage(%rip),		%rax
									
									PUSHQ	%rax
									
									MOVQ	%rax,						%rdx
									MOVQ	$0x00000000,				%rsi		; unsigned int backgroundColor = RSI, second parameter for PrintColor
									MOVQ	$0x00ff0000,				%rdi		; unsigned int foregroundColor = RDI, first parameter for PrintColor
									MOVQ	$0,							%rax
									
									CALLQ	PrintColor								; int PrintColor(unsigned int foregroundColor, unsigned int backgroundColor, const char * fmt,...)
																					; Under X64, in most circumstances, the parameters will be passed via registers (X64 has much more registers). The parameters will be passed in order (Left to right),
																					; RDI, RSI, RDX, RCX, R8, R9. If there are additional parameters, will be passed by memory (stack)
																					; const char * fmt,... is NULL
																					; The Return Value of int PrintColor will be hold by RAX
									
									ADDQ	$0x8,						$rsp
									
Loop:

									JMP		Loop
									
									POPQ	%rax
									MOVQ	%rax,						%ds
									
									POPQ	%rax
									MOVQ	%rax,						%ds
									
									POPQ	%r15
									POPQ	%r14
									POPQ	%r13
									POPQ	%r12
									POPQ	%r11
									POPQ	%r10
									POPQ	%r9
									POPQ	%r8
									
									POPQ	%rsi
									POPQ	%rdi
									POPQ	%rbp
									POPQ	%rdx
									POPQ	%rcx
									POPQ	%rbx
									POPQ	%rax
									
									IRETQ
									
InterruptMessage:

									.asciz	"Unkown interrupt or fault at RIP\n"	; .ascii "Hello world!", "Assembler!", .ascii will place the string one by one in memory, but will not end with \0(NULL) automatically.
																					; .asciz "Unkown interrupt or fault at RIP\n", .asciz behave the similar but will append the \0(NULL) automatically

									
