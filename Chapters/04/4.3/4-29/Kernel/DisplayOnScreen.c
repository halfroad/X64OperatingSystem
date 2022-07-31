int SkipToInteger (const char **string)
{
    int i = 0;
    
    while (isDigit (**String))
        i = i * 10 + *((*string) ++) - '0';
    
    return i;
}
