void PutChar(unsigned int *frameBufferAddress, int honrizontalCharacterSize, int honrizontal, int vertical, unsigned int foregroundColor, unsigned int backgroundColor, unsigned char font)
{
    unsigned int * address = NULL;
    unsigned char * fontPointer = FontAscii[font];
    
    int value = 0;
    
    for (int i = 0; i < 16; i ++)
    {
        address = frameBufferAddress +honrizontalCharacterSize * (vertical + i) + honrizontal;
        value = 0x100;
        
        for (int j = 0; j < 16; j ++)
        {
            value = value >> 1;
            
            if (*fontPointer & value)
                *address = foregroundColor;
            else
                *address = backgroundColor;
        }
        
        fontPointer ++;
    }
}
