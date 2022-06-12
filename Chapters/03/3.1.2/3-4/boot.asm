; Message

StartBootMessage:	db "Start Boot"

; Fill zero until whole sector

times	510 - ($ - $$) db 0

DW 0xaa55
