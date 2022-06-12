[SECTION .s16lib]
[BITS 16]

; =========== display number in al

DisplayAl:

		PUSH ecx
		PUSH edx
		PUSH edi

		MOV edi, [DisplayPosition]
		MOV ah, 0fh
		MOV dl, al

		SHR al, 4

		MOV ecx, 2

.Begin:

		AND al, 0fh

		CMP al, 9
		JA  .Greater

		ADD al, '0'
		JMP .LessEqual

.Greater:

		SUB al, 0ah
		ADD al, 'A'

.LessEqual:

		MOV [gs: edi], ax

		ADD edi, 2

		MOV al, dl

		LOOP .Begin

		MOV [DisplayPosition], edi

		POP edi
		POP edx
		POP ecx

		RET
