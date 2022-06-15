; ====================== Enable Long Mode

			MOV ecx, 0c0000080h			; IA32_EFER

			RDMSR

			BTS eax, 8

			WRNSR					; MSR 是CPU 的一组64 位寄存器，可以分别通过RDMSR 和WRMSR 两条指令进行读和写的操作，前提要在ECX 中写入MSR 的地址。MSR 的指令必须执行在level 0 或实模式下.
								;  RDMSR    读模式定义寄存器。对于RDMSR 指令，将会返回相应的MSR 中64bit 信息到(EDX：EAX)寄存器中
         							;  WRMSR    写模式定义寄存器。对于WRMSR 指令，把要写入的信息存入(EDX：EAX)中，执行写指令后，即可将相应的信息存入ECX 指定的MSR 中。
