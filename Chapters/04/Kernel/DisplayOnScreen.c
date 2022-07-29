#include <stdarg.h>
#include "DisplayOnScreen.h"
#include "lib.h"
#include "linkage.h"

int printColor(unsigned int foregroundColor, unsigned int backgroundColor, const char * fmt,...)
{
	int i, count, line = 0

	va_list args;
	va_start(args, fmt);

	i = vsprintf(buf, fmt, args);

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
        
        if (Position.HorizontalPosition >= Position.HorizontalResolution / Position.HorizontalCharacterSize)
        {
            Position.VerticalPosition ++;
            Position.HorizontalPosition = 0;
        }

        if (Position.VerticalPosition >= Position.VerticalResolution / Position.VerticalCharacterSize)
        {
                Position.VerticalPosition = 0;
        }
	}
    
    return i;
    
}

void putchar(unsigned int *frameBufferAddress, int honrizontalCharacterSize, int honrizontal, int vertical, unsigned int foregroundColor, unsigned int backgroundColor, unsigned char font)
{
    unsigned int * address = NULL;
    unsigned char * fontPointer = FontAscii[font];
    
    int value = 0;
    
    for (int i = 0; i < 16; i ++)
    {
        address = frameBufferAddress +honrizontalCharacterSize * (vertical + i) + honrizontal;
        value = 0x100;
        
        for (int j = 0; j < 16; j ++)
        {
            value = value >> 1;
            
            if (*fontPointer & value)
                *address = foregroundColor;
            else
                *address = backgroundColor;
        }
        
        fontPointer ++;
    }
}
