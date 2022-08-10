#include <stdarg.h>
#include "Font.h"
#include "linkage.h"

#ifndef __DISPLAYONSCREEN_H__
#define __DISPLAYONSCREEN_H__

#define ZEROPAD 1        /* pad with zero */
#define SIGN    2        /* unsigned/signed long */
#define PLUS    4        /* show plus */
#define SPACE   8        /* space if plus */
#define LEFT    16        /* left justified */
#define SPECIAL 32        /* 0x */
#define SMALL   64        /* use 'abcdef' instead of 'ABCDEF' */

#define WHITE   0x00ffffff        //白
#define BLACK   0x00000000        //黑
#define RED     0x00ff0000        //红
#define ORANGE  0x00ff8000        //橙
#define YELLOW  0x00ffff00        //黄
#define GREEN   0x0000ff00        //绿
#define BLUE    0x000000ff        //蓝
#define INDIGO  0x0000ffff        //靛
#define PURPLE  0x008000ff        //紫

struct
{
    int HorizontalResolution;
    int VerticalResolution;

    int HorizontalPosition;
    int VerticalPosition;

    int HorizontalCharacterSize;
    int VerticalCharacterSize;

    unsigned int * FrameBufferAddress;
    unsigned long FrameBufferLength;

} Position;

int PrintColor(unsigned int foregroundColor, unsigned int backgroundColor, const char * fmt,...);

void PutChar(unsigned int *frameBufferAddress, int honrizontalCharacterSize, int honrizontal, int vertical, unsigned int foregroundColor, unsigned int backgroundColor, unsigned char font);

int VSPrint(char * buffer, const char * format, va_list args);

int SkipToInteger (const char **string);

static char * numberize(char *string, long number, int base, int size, int precision, int type);

#endif
