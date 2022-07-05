#include <stdarg.h>
#include "printk.h"
#include "lib.h"
#include "linkage.h"

int ColorPrintk(unsigned int FRColor, unsigned int BKColor, const char * fmt,...)
{
	int i, count, line = 0
	
	va_list args;
	va_start(args, fmt);
	
	i = vsprintf(buffer, fmt, args);
	
	va_end(args);
	
	for (count = 0; count < i || line; count ++)
	{
		//// add \n	\b	\t
		if (line < 0)
		{
			count --;
			goto LabelTab;
		}
		
		if ((unsigned char) *(buffer + count) == '\n')
		{
			Position.YPosition ++;
			Position.XPosition = 0;
		}
		else if ((unsigned char) *(buffer + count) == '\b')
		{
			Position.XPostion --;
			
			if (Position.XPosition < 0)
			{
				Position.XPosition = (Position.XResolution / Position.XCharSize - 1) * Position.XCharSize;
				Position.YPosition --;
				
				if (Position.YPosition < 0)
					Position.YPosition = (Position.YPosition / Position.YCharSize -1) * Position.YCharSize;
			}
			
			putchar(Position.FBAddress, Position.XResolution, Position.XPosition * Position.YCharSize, Position.YPosition * Position.YCharSize, FRColor, BKColor, ' ');
		}
	}
}
