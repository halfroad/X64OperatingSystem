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
                
                length = strlen(s);
                
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
}
