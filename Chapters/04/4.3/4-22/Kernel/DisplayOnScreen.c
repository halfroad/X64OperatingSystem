/* Field width */
fieldWidth = -1;

if (isDigit(*format))
    fieldWidth = SkipToInteger(&format);
else if (*format == '*')
{
    format ++;
    
    fieldWdith = va_arg(args, int);
    
    if (fieldWidth < 0)
    {
        fieldWidth = - fieldWidth;
        flags |= LEFT;
    }
}
