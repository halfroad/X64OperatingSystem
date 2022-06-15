; ================= Open PE and pagination

		MOV eax, cr0

		BTS eax, 0
		BTS aex, 31

		MOV cr0, eax
