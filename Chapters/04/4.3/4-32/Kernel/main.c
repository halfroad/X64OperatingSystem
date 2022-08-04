#include "lib.h"
#include "DisplayOnScreen.h"

void StartKernel(void)
{
    int *address = (int *) 0xffff800000a00000;
    
    int i;
    
    Position.HorizontalResolution = 1440;
    Position.VerticalResolution = 900;
    
    Position.HorizontalPosition = 0;
    Position.VerticalPosition = 0;
    
    Position.HorizontalCharacterSize = 8;
    Position.VerticalCharacterSize = 8;
    
    Position.FrameBufferAddress = (int *) 0xffff800000a00000;
    Position.FrameBufferLength = Position.HorizontalResolution * Position.VerticalResolution * 4;
    
    for (int i = 0; i < 1440 * 20; i ++)
    {
        *((char *) address + 0) = (char) 0x00;
        *((char *) address + 1) = (char) 0x00;
        *((char *) address + 2) = (char) 0xff;
        *((char *) address + 3) = (char) 0x00;

        address += 1;
    }

    for (int i = 0; i < 1440 * 20; i ++)
    {
        *((char *) address + 0) = (char) 0x00;
        *((char *) address + 1) = (char) 0xff;
        *((char *) address + 2) = (char) 0x00;
        *((char *) address + 3) = (char) 0x00;

        address += 1;
    }

    for (int i = 0; i < 1440 * 20; i ++)
    {
        *((char *) address + 0) = (char) 0xff;
        *((char *) address + 1) = (char) 0x00;
        *((char *) address + 2) = (char) 0x00;
        *((char *) address + 3) = (char) 0x00;

        address += 1;
    }

    for (int i = 0; i < 1440 * 20; i ++)
    {
        *((char *) address + 0) = (char) 0xff;
        *((char *) address + 1) = (char) 0xff;
        *((char *) address + 2) = (char) 0xff;
        *((char *) address + 3) = (char) 0x00;

        address += 1;
    }
    
    PrintColor(YELLOW, BLACK, "Hello\t\t World!\n");

}
