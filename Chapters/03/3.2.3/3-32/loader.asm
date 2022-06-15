; =========== Load GDTR

		DB 0x66

		LGDT [GdtPtr64]

		MOV ax, 0x10
		MOV ds, ax
		MOV es, ax
		MOV fs, ax
		MOV gs, ax
		MOV ss, ax

		MOV esp, 7E00h
