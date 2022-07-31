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
