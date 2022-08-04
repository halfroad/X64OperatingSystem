#include <stdarg.h>
#include "DisplayOnScreen.h"
#include "lib.h"
#include "linkage.h"

#define isDigit(c)  ((c) >= '0' && (c) <= '9')
#define Divide(n,base) ({  \
    int __res;   \
    __asm__("divq %%rcx": "=a" (n), "=d" (__res): "0" (n), "1" (0), "c" (base)); \
    __res; })

extern inline int strlen(char * String);

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
				Position.HorizontalPosition = (Position.HorizontalResolution / Position.HorizontalCharacterSize - 1) * Position.HorizontalCharacterSize;
				Position.VerticalPosition --;
				
				if (Position.VerticalPosition < 0)
					Position.VerticalPosition = (Position.VerticalPosition / Position.VerticalCharacterSize -1) * Position.VerticalCharacterSize;
			}
			
			PutChar(Position.FrameBufferAddress, Position.HorizontalResolution, Position.HorizontalPosition * Position.VerticalCharacterSize, Position.VerticalPosition * Position.VerticalCharacterSize, foregroundColor, backgroundColor, ' ');
		}
		else if ((unsigned char) *(buffer + count) == '\t')
		{
			line = ((Position.HorizontalPosition + 8) & ~(8 - 1)) - Position.HorizontalPosition;
			
LabelTab:
			line --;
			
			PutChar(Position.FrameBufferAddress, Position.HorizontalResolution, Position.HorizontalPosition * Position.HorizontalCharacterSize, Position.VerticalPosition * Position.VerticalCharacterSize, foregroundColor, backgroundColor, ' ');
			
			
			Position.HorizontalPosition ++;
		}
		else
		{
			PutChar(Position.FrameBufferAddress, Position.HorizontalResolution, Position.HorizontalPosition * Position.HorizontalCharacterSize, Position.VerticalPosition * Position.VerticalCharacterSize, foregroundColor, backgroundColor, (unsigned char) *(buffer + count));
			
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

void PutChar(unsigned int *frameBufferAddress, int honrizontalCharacterSize, int honrizontal, int vertical, unsigned int foregroundColor, unsigned int backgroundColor, unsigned char font)
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

int VSPrint(char * buffer, const char * format, va_list args)
{
    char *string, *s;
    
    /*  qualifiers: 'h', 'l', 'L', or 'Z' for integer fields */
    int flags, fieldWidth, precision, length, i, qualifier;
    
    for (string = buffer; *format; format ++)
    {
        if (*format != '%')
        {
            *string ++ = *format;
            continue;
        }
        
        flags = 0;
        
    LabelRepeat:
        
        format ++;
        
        switch (*format)
        {
            case '-':
                flags |= LEFT;
                goto LabelRepeat;
                
            case '+':
                flags |= PLUS;
                goto LabelRepeat;
                
            case ' ':
                flags |= SPACE;
                goto LabelRepeat;
                
            case '#':
                flags |= SPECIAL;
                goto LabelRepeat;
                
            case '0':
                flags |= ZEROPAD;
                goto LabelRepeat;
                
            default:
                break;
        }
        
        /* Field width */
        fieldWidth = -1;
        
        if (isDigit(*format))
            fieldWidth = SkipToInteger(&format);
        else if (*format == '*')
        {
            format ++;
            
            fieldWidth = va_arg(args, int);
            
            if (fieldWidth < 0)
            {
                fieldWidth = - fieldWidth;
                flags |= LEFT;
            }
        }
        
        /* Precision */
        precision = -1;
        
        if (*format == '.')
        {
            format ++;
            
            if (isDigit(*format))
                precision = SkipToInteger(&format);
            else if (*format == '*')
            {
                format ++;
                precision = va_arg(args, int);
            }
            
            if (precision < 0)
                precision = 0;
        }
        
        /* Qualifer */
        qualifier = -1;
        
        if (*format == 'h' || *format == 'l' || *format == 'L' || *format == 'Z')
        {
            qualifier = *format;
            format ++;
        }
        
        switch (*format)
        {
            case 'c':
                
                if (!flags & LEFT)
                {
                    while (--fieldWidth > 0)
                        *string ++ = ' ';
                }
                
                *string ++ = (unsigned char) va_arg(args, int);
                
                while (--fieldWidth > 0)
                    *string ++ = ' ';
                
                break;
                
            case 's':
                
                s = va_arg(args, char *);
                
                if (!s)
                    s = '\0';
                
                length = (int)strlen(s);
                
                if (precision < 0)
                    precision = length;
                else if (length > precision)
                    length = precision;
                
                if (!(flags & LEFT))
                {
                    while (length < fieldWidth --)
                        *string ++ = ' ';
                }
                
                for (i = 0; i < length; i ++)
                    *string ++ = ' ';
                
                while (length < fieldWidth --)
                    *string ++ = ' ';
                
                break;
                
            case 'o':
                
                if (qualifier == 'l')
                    string = numberize(string, va_arg(args, unsigned long), 8, fieldWidth, precision, flags);
                else
                    string = numberize(string, va_arg(args, unsigned int), 8, fieldWidth, precision, flags);
                
                break;
                
            case 'p':
                
                if (fieldWidth == -1)
                {
                    fieldWidth = 2 * sizeof(void *);
                    flags |= ZEROPAD;
                }
                
                string = numberize(string, (unsigned long)va_arg(args, void *), 16, fieldWidth, precision, flags);
                
                break;
                
            case 'x':
                
                flags |= SMALL;
                
            case 'X':
                
                if (qualifier == 'l')
                    string = numberize(string, va_arg(args, unsigned long), 16, fieldWidth, precision, flags);
                else
                    string = numberize(string, va_arg(args, unsigned int), 8, fieldWidth, precision, flags);
                
                break;
                
            case 'd':
            case 'i':
                
                flags |= SIGN;
                
            case 'u':
                
                if (qualifier == 'l')
                    string = numberize(string, va_arg(args, unsigned long), 10, fieldWidth, precision, flags);
                else
                    string = numberize(string, va_arg(args, unsigned int), 10, fieldWidth, precision, flags);
                
            case 'n':
                
                if (qualifier == 'l')
                {
                    long *ip = va_arg(args, long *);
                    *ip = (string - buffer);
                }
                else
                {
                    int *ip = va_arg(args, int *);
                    *ip = (string - buffer);
                }
                
                break;
                
            case '%':
                
                *string ++ = '%';
                
                break;
                
            default:
                
                *string ++ = '%';
                
                if (*format)
                    *string ++ = *format;
                else
                    format --;
                
                break;
        }
    }
    
    *string = '\0';
    
    return string - buffer;
}

int SkipToInteger (const char **string)
{
    int i = 0;
    
    while (isDigit (**string))
        i = i * 10 + *((*string) ++) - '0';
    
    return i;
}

static char * numberize(char *string, long number, int base, int size, int precision, int type)
{
    char character, sign, temporary[50];
    const char *digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    int i;
    
    if (type & SMALL)
        digits = "0123456789abcdefghijklmnopqrstuvwxyz";
    
    if (type & LEFT)
        type &= ~ZEROPAD;
    
    if (base < 2 || base > 36)
        return 0;
    
    character = (type & ZEROPAD) ? '0' : ' ';
    sign = 0;
    
    if (type & SIGN && number < 0)
    {
        sign = '-';
        number = -number;
    }
    else
        sign = (type & PLUS) ? '+' : ((type & SPACE) ? ' ' : 0);
    
    if (sign)
        size --;
    
    if (type & SPECIAL)
    {
        if (base == 16)
            size -= 2;
        else if (base == 8)
            size --;
    }
    
    i = 0;
    
    if (number == 0)
        temporary[i ++] = '0';
    else
        temporary[i ++] = digits[Divide(number, base)];
    
    if (i > precision)
        precision = i;
    
    size -= precision;
    
    if (!(type & (ZEROPAD + LEFT)))
        while (size -- > 0)
            *string ++ = ' ';
    
    if (sign)
        *string ++ = sign;
    
    if (type & SPECIAL)
    {
        if (base == 8)
            *string ++ = '0';
        else if (base == 16)
        {
            *string ++ = '0';
            *string ++ = digits[33];
        }
    }
    
    if (!(type & LEFT))
        while(size -- > 0)
            *string ++ = character;
    
    while (i < precision --)
        *string ++ = '0';
    
    while (i -- > 0)
        *string ++ = temporary[i];
    
    while (size -- > 0)
        *string ++ = ' ';
    
    return string;
}
