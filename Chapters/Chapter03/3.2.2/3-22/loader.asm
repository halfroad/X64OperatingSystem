; =====================  Get memory address size type

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

			JC GetMemoryStructFail

			ADD di, 20

			CMP ebx, 0

			JNE GetMemoryStruct

			JMP GetMemoryStructSuccess

GetMemoryStructFail:

			MOV bp, GetMemoryStructErrorMessage

			INT 10h

			JMP $

GetMemoryStructSuccess:

			MOV bp, GetMemoryStructSuccessMessage

			INT 10h
