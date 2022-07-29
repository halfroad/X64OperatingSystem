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
}
