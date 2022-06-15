[SECTION .s32]
[BITS 32]

GoToTemporaryProtect:

; ====================== Go to temporary long mode

				MOV ax, 0x10
				MOV ds, ax
				MOV es, ax
				MOV fs, ax
				MOV ss, ax
				MOV esp, 7e00h

				CALL SupportLongMode

				TEST eax, eax

				JZ NotSupport
