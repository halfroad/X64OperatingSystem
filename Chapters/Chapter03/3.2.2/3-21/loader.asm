KillMotor:

			PUSH dx

			MOV dx, 02f2h
			MOV al, 0

			OUT dx, al

			POP dx
