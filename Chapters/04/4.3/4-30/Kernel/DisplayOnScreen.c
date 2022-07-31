#define Divide(n, base) ({  \

    int _res;   \
    __asm__("divq %%rcx": "=a" (n), "=d" (__res): "0" (n), "1" (0), "c" (base)); \
    __res;
})

static char * numberize(char *string, long number, int base, int size, int precision, int type)
{
    char character, sign, temperory[50];
    const char *digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    int i;
    
    if (type & SMALL)
        digits = "0123456789abcdefghijklmnopqrstuvwxyz";
    
    if (type & LEFT)
        type &= ~ZEROPAD;
    
    if (base < 2 || base > 36)
        return 0;
    
    c = (type & ZEROPAD) ? '0' : ' ';
    sign = 0;
    
    if (type & SIGN && number < 0)
    {
        sign = '-';
        number = -number;
    }
    else
        sign = (type & PLUS) ? '+' : ((type & SPACE) ? ' ' : 0);
    
    if (sign)
        size --;
    
    if (type & SPECIAL)
    {
        if (base == 16)
            size -= 2;
        else if (base == 8)
            size --;
    }
    
    i = 0;
    
    if (number = 0)
        temporary[i ++] = '0';
    else
        temporary[i ++] = digits[Divide(number, base)];
    
    if (i > precision)
        precision = i;
    
    size -= precision;
    
    if (!(type & (ZEROPAD + LEFT)))
        while (size -- > 0)
            *string ++ = ' ';
    
    if (sign)
        *string ++ = sign;
    
    if (type & SPECIAL)
    {
        if (base == 8)
            *string ++ = '0';
        else if (base == 16)
        {
            *string ++ = '0';
            *string += = digits[33];
        }
    }
    
    if (!(type & LEFT))
        while(size -- > 0)
            *string ++ = c;
    
    while (i < precision --)
        *string ++ = '0';
    
    while (i -- > 0)
        *string ++ = temporary[i];
    
    while (size -- > 0)
        *string ++ = ' ';
    
    return string;
}
