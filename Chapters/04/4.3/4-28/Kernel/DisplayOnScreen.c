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
