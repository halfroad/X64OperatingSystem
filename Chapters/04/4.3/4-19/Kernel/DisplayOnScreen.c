if (Position.HorizontalPosition >= Position.HorizontalResolution / Position.HorizontalCharacterSize)
{
	Position.VerticalPosition ++;
	Position.HorizontalPosition = 0;
}

if (Position.VerticalPosition >= Position.VerticalResolution / Position.VerticalCharacterSize)
{
        Position.VerticalPosition = 0;
}
