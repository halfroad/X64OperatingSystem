; ============ Open address A20

	PUSH ax

	IN al, 92h		; Read a byte from port 92h
	OR al, 00000010b	; I/O port 92h: Fast Gate A20, the number 1 (start from 0) = 1 to enable A20

	OUT 92h, al

	POP ax

	CLI			; Disable Interrupt to avoid other  interrupt

	DB 0x66

	LGDT [GdtPtr]		; LGTD m:  Load m to the Load Global Descriptor Table

	MOV eax, cr0		; eax: 32 bits ax register, ax is stored in low 16 bits of eax
				; cr0 - cr4: cr0, Control Register. Bit 0: PE, protected Enable
	OR eax, 1
	MOV cr0, exa

	MOV ax, SelectorData32
	MOV fs, ax
	MOV eax, cr0
	AND al, 11111110b
	MOV cr0, eax

	STI			; Enable Interrupt
