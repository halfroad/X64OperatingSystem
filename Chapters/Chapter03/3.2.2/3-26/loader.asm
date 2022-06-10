; ========= temporary IDT

IDT:

	times 0x50	DQ 0

IDT_END:

IDT_POINTER:

			DW IDT_END - IDT - 1
			DD IDT
