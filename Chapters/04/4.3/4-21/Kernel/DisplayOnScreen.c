int vsprint(char * buffer, const char * format, va_list args)
{
    char *string, *s;
    
    /*  qualifiers: 'h', 'l', 'L', or 'Z' for integer fields */
    int flags, fieldWidth, precision, length, qualifier;
    
    for (string = buffer; *format; format ++)
    {
        if (*format != '%')
        {
            *string ++ = *format;
            continue;
        }
        
        flags = 0;
        
    REPEAT:
        
        format ++;
        
        switch (format)
        {
            case case '-':
                flags |= LEFT;
                goto REPEAT;
                
            case case '+':
                flags |= PLUS;
                goto REPEAT;
                
            case case ' ':
                flags |= SPACE;
                goto REPEAT;
                
            case case '#':
                flags |= SPECIAL;
                goto REPEAT;
                
            case case '0':
                flags |= ZEROPAD;
                goto REPEAT;
                
            default:
                break;
        }
    }
}
