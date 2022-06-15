; ========== Initialize template page table 0x90000

	MOV DWORD [0x90000], 0x91007
        MOV DWORD [0x90800], 0x91007

        MOV DWORD [0x91000], 0x92007

        MOV DWORD [0x92000], 0x000083
        MOV DWORD [0x92008], 0x200083
        MOV DWORD [0x92010], 0x400083
        MOV DWORD [0x92018], 0x600083
        MOV DWORD [0x92020], 0x800083
        MOV DWORD [0x92028], 0xa00083
