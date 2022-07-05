#include <stdarg.h>
#include "printk.h"
#include "lib.h"
#include "linkage.h"

int ColorPrintk(unsigned int FRColor, unsigned int BKColor, const char * fmt,...)
{
	int i, count, line = 0
	
	va_list args;
	va_start(args, fmt);
	
	i = vsprintf(buf, fmt, args);
	
	va_end(args);
}
