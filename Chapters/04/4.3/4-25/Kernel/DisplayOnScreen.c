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
}
