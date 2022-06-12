; ====== init IDT GDT goto protect mode

	CLI	; Disable interrupt

	DB 0x66

	LGDT [GdtPtr]

;	DB 0x66
;	LIDT [IDT_POINTER]

	MOV eax, cr0
	OR eax, 1
	MOV cr0, eax

	JMP DWORD SelectorCode32: GoToTemporaryProtect
