#include <stdarg.h>
#include "DisplayOnScreen.h"
#include "lib.h"
#include "linkage.h"

int PrintColor(unsigned int foregroundColor, unsigned int backgroundColor, const char * fmt,...)
{
    int i, count, line = 0;

    va_list args;
    va_start(args, fmt);
    
    char buffer[4096] = {0};
    
    i = VSPrint(buffer, fmt, args);

    va_end(args);

    for (count = 0; count < i || line; count ++)
    {
        //// add \n    \b    \t
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
    }
}
