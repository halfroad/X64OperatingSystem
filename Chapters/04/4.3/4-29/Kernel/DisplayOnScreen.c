int SkipToInteger (const char **string)
{
    int i = 0;
    
    while (isDigit (**string))
        i = i * 10 + *((*string) ++) - '0';
    
    return i;
}
