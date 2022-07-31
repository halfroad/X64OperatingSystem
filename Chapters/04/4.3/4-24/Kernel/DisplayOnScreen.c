/* Qualifer */
qualifier = -1;

if (*format == 'h' || *format == 'l' || *format == 'L' || *format == 'Z')
{
    qualifier = *format;
    format ++;
}
