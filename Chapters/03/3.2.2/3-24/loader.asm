; ============ set the SVGA mode (VESA VBE)

	JMP $

	MOV ax, 4f02h
	MOV bx, 4180h		; ======== Mode: 0x180 0r 0x143

	CMP ax, 004fh

	JNZ SetSvgaModeVesaVbeFall
