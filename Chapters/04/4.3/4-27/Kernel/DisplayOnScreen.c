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
    
    string = numberize(string, va_arg(args, unsigned long)va_arg(args, void *), 16, fieldWidth, precision, flags);
    
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
