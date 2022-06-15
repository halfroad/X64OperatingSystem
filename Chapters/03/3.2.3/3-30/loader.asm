; ============== Test the support or not of long mode

SupportLongMode:

				MOV eax, 0x80000000

				CPUID

				CMP eax, 0x80000001

				SETNB	; Set if Not Below

				JB SupportLongModeDone

				MOV eax, 0x80000001

				CPUID

				BT edx, 29	; Bit Test, influence the CF

				SETC al

SupportLongModeDone:

				MOV eax, al

				RET

; ============================ Not support

NotSupport:

				JMP $
