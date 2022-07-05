// ================================== Global Descriptor Table

									.SECTION .data

									.GLOBAL GlobalDescriptorTable

GlobalDescriptorTable:

									.QUAD	0x0000000000000000			/* 0, NULL Descriptor 00 */
									.QUAD	0x0020980000000000			/* 1, KERNEL Code 64-bit Segment 08 */
									.QUAD	0x0000920000000000			/* 2, KERNEL Data 64-bit Segment 10 */
									.QUAD	0x00020f8000000000			/* 3, USER Code 64-bit Segment 18 */
									.QUAD	0x00000f2000000000			/* 4, USER Data 64-bit Segment 20 */
									.QUAD	0x0000000000000000			/* 5, KERNEL Code 32-bit Segment 28 */
									.QUAD	0x00cf9a000000ffff			/* 6, KERNEL Data 32-bit Segment 30 */
									.FILL	0x00cf92000000ffff			/* 8 ~ 9, TAST STATUS SEGMENT (JMP ONE SEGMENT <7>) in Long Mode 128-bit 40 */
									
GlobalDescriptorTableEnd:
									
GlobalDescriptorTablePointer:
GlobalDescriptorTableLimit:			.WORD	GlobalDescriptorTableEnd - GlobalDescriptorTable - 1
GlobalDescriptorTableBase:			.QUAD	GlobalDescriptorTable


									.GLOBAL InterruptDescriptorTable
									
									
// ================================== Interrupt Descriptor Table
				
InterruptDescriptorTable:

									.FILL	512, 8, 0
									
InterruptDescriptorTableEnd:

InterruptDescriptorTablePointer:
InterruptDescriptorTableLimit:		.WORD	InterruptDescriptorTableEnd - InterruptDescriptorTable - 1
InterruptDescriptorTableBase:		.QUAD	InterruptDescriptorTable


// ================================== TASK STATUS SEGMENT 64 Table
				
TaskStatusSegment64Table:

									.FILL	13, 8, 0
									
TaskStatusSegment64TableEnd:

TaskStatusSegment64TablePointer:
TaskStatusSegment64TableLimit:		.WORD	TaskStatusSegment64TableEnd - TaskStatusSegment64Table - 1
TaskStatusSegment64TableBase:		.QUAD	TaskStatusSegment64Table
