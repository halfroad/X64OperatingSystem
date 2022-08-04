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
    }
}
