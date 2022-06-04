; ====== Display on screen: ERROR: NO LOADER FOUND

NoLoaderBin:
			MOV	ax, 1301h
			MOV	bx, 008ch
			MOV	dx, 0100h
			MOV	cx, 21

			PUSH	ax,

			MOV	ax, ds
			MOV	es, ax

			POP	ax

			MOV 	bp, NoLoaderMessage

			INT	10h

			JMP	$
