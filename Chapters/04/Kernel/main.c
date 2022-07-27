void StartKernel(void)
{
	int *address = (int *) 0xffff800000a00000;

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

	while(1)
		;
}
