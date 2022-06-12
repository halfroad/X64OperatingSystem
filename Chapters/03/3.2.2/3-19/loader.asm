; =====================  Found the name of kernel.bin in root directory struct

FileNameFound:

				MOV ax, RootDirectorySectors

				AND di, 0FFE0h
				ADD di, 01ah

				MOV cx, WORD [es: di]

				PUSH cx

				ADD cx, ax
				ADD cx, SectorBalance

				MOV eax, BaseTemporaryKernelAddress

				MOV es, eax
				MOV bx, OffsetTemporaryKernelFile

				MOV ax, cx

GoOnLoadingFile:

				MOV cl, 1

				CALL ReadOneSector

				POP ax

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

				MOV ax, BaseTemporaryOfKernelAddress

				MOV ds, ax
				MOV esi, OffsetTemporaryOfKernelFile

ReplicateKernel:

				MOV al, BYTE [ds: esi]
				MOV BYTE [fs: edi], al

				INC esi
				INC edi

				LOOP ReplicateKernel

				MOV eax, 0x1000
				MOV ds, eax

				MOV DWORD [OffsetOfKernelFileCount], edi

				POP esi
				POP ds
				POP edi
				POP edi
				POP fs
				POP eax
				POP cx

				CALL GetFATEntry

				JMP GoOnLoadingFile
