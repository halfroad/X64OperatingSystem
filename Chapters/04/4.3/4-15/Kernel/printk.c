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
	}
}
