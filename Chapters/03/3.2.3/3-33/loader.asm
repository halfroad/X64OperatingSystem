; ========= Open PAE

			MOV eax, cr4
			BTS eax, 5
			MOV cr4, eax
