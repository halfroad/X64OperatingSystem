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
