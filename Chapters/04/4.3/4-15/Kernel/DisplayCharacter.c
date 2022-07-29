#include <stdarg.h>
#include "DisplayCharacter.h"
#include "lib.h"
#include "linkage.h"

int PrintColor(unsigned int foregroundColor, unsigned int backgroundColor, const char * fmt,...)
{
	int i, count, line = 0

	va_list args;
	va_start(args, fmt);

	i = vsprintf(buf, fmt, args);

	va_end(args);

	for (count = 0; count < i || line; count ++)
	{
		//// add \n	\b	\t
		if (line > 0)
		{
			count --;
			goto LabelTab;
		}

		if ((unsigned char) *(buffer + count) == '\n')
		{
			Position.HorizontalPosition = 0;
			Position.VerticalPosition ++;
		}
		else if ((unsigned char) *(buffer + count) == '\b')
		{
			Position.HorizontalPosition --;
			
			if (Position.HorizontalPosition < 0)
			{
				Position.HorizontalPosition = (Position.HorizontalResolution / Position.HorizontalCharSize - 1) * Position.HorizontalCharacterSize;
				Position.VerticalPosition --;
				
				if (Position.VerticalPosition < 0)
					Position.VerticalPosition = (Position.VerticalPosition / Position.VerticalCharSize -1) * Position.VerticalCharSize;
			}
			
			putchar(Position.FBAddress, Position.HorizontalResolution, Position.HorizontalPosition * Position.VerticalCharSize, Position.VerticalPosition * Position.VerticalCharSize, foregroundColor, backgroundColor, ' ');
		}
		else if ((unsigned char) *(buffer + count) == '\t')
		{
			line = ((Position.HorizontalPosition + 8) & ~(8 - 1)) - Position.HorizontalPosition;
			
LabelTab:
			line --;
			
			putchar(Position.FrameBufferAddress, Position.HorizontalResolution, Position.HorizontalPosition * Position.HorizontalCharSize, Position.VerticalPosition * Position.VerticalCharSize, foregroundColor, backgroundColor, ' ');
			
			
			Position.HorizontalPosition ++;
		}
		else
		{
			putchar(Position.FrameBufferAddress, Position.HorizontalResolution, Position.HorizontalPosition * Position.HorizontalCharSize, Position.VerticalPosition * Position.VerticalCharSize, foregroundColor, backgroundColor, (unsigned char) *(buffer + count));
			
			Position.HorizontalPosition ++;
		}
	}
}
