// ================================= Main Entry

                                    .SECTION	.TEXT

                                    .GLOBL      _start

_start:

                                    MOV         $0x10,                  %ax
                                    MOV         %ax,                    %ds
                                    MOV         %ax,                    %es
                                    MOV         %ax,                    %fs
                                    MOV         %ax,                    %ss
                                    MOV         $0x7e00,                %esp


// ================================= Load GDTR

                                    LGDT GlobalDescriptorTablePointer (%rip)    /* [GlobalDescriptorTablePointer + rip] */


// ================================= Load IDTR

                                    LIDT InterruptDescriptorTablePointer (%rip) /*  [InterruptDescriptorTablePointer + rip] */
                                    
                                    MOV         $0x10,                  %ax
                                    MOV         %ax,                    %ds
                                    MOV         %ax,                    %es
                                    MOV         %ax,                    %fs
                                    MOV         %ax,                    %gs
                                    MOV         %ax,                    %ss
                                    
                                    MOVQ        $0x7e00,                %rsp
                                    
                                    
// ================================= Load cr3

                                    MOVQ        $0x101000,              %rax
                                    MOVQ        %rax,                   %cr3
                                    
                                    MOVQ        SwitchSegment (%rip),   %rax
                                    
                                    PUSHQ       $0x08
                                    PUSHQ       %rax
                                    
                                    LRETQ
                                    
                                    
// ================================= 64-bit mode code


SwitchSegment:

                                    .QUAD       Entry64
                                    
                                    
Entry64:

                                    MOVQ        $0x10,                  %rax
                                    MOVQ        %rax,                   %ds
                                    MOVQ        %rax,                   %es
                                    MOVQ        %rax,                   %gs
                                    MOVQ        %rax,                   %ss
                                    
                                    MOVQ        $0xffff800000007e00,    %rsp        /* rsp address */
                                    
                                    MOVQ        EnterKernel (%rip),     %rax        /* MOVQ address */
                                    
                                    PUSHQ       $0x08
                                    PUSHQ       %rax
                                    
                                    LRETQ


EnterKernel:

                                    .QUAD       StartKernel


// ================================== Initialize Pages

									.ALIGN      8

									.ORG        0x1000
									
__PML4E:

									.QUAD       0x102007
									.FILL       255, 8, 0
									.QUAD       0x102007
									
									.FILL       255, 8, 0
									
									
									.ORG        0x2000
									
									
__PDPTE:

									.QUAD       0x103003
									
									.FILL       511, 8, 0
									
									
									.ORG        0x3000
									

__PDE:

									.QUAD       0x000083
									.QUAD       0x200083
									.QUAD       0x400083
									.QUAD       0x600083
									.QUAD       0x800083
									.QUAD       0xe0000083					/* 0x a00000 */
									.QUAD       0xe0200083
									.QUAD       0xe0400083
									.QUAD       0xe0600083					/* 0x 1000000 */
									.QUAD       0xe0800083
									.QUAD       0xe0a00083
									.QUAD       0xe0c00083
									.QUAD       0xe0e00083
									
									.FILL       499, 8, 0


// ================================== Global Descriptor Table

                                    .SECTION    .data

                                    .GLOBL      GlobalDescriptorTable

GlobalDescriptorTable:

                                    .QUAD       0x0000000000000000              /* 0, NULL Descriptor 00 */
                                    .QUAD       0x0020980000000000              /* 1, KERNEL Code 64-bit Segment 08 */
                                    .QUAD       0x0000920000000000              /* 2, KERNEL Data 64-bit Segment 10 */
                                    .QUAD       0x0020f80000000000              /* 3, USER Code 64-bit Segment 18 */
                                    .QUAD       0x0000f20000000000              /* 4, USER Data 64-bit Segment 20 */
                                    .QUAD       0x00cf9a000000ffff              /* 5, KERNEL Code 32-bit Segment 28 */
                                    .QUAD       0x00cf92000000ffff              /* 6, KERNEL Data 32-bit Segment 30 */
                                    .FILL       10, 8, 0                        /* 8 ~ 9, TAST STATUS SEGMENT (JMP ONE SEGMENT <7>) in Long Mode 128-bit 40 */
                                    
GlobalDescriptorTableEnd:
                                    
GlobalDescriptorTablePointer:
GlobalDescriptorTableLimit:
                                    .WORD       GlobalDescriptorTableEnd - GlobalDescriptorTable - 1
GlobalDescriptorTableBase:
                                    .QUAD       GlobalDescriptorTable


                                    .GLOBL      InterruptDescriptorTable
                                    
                                    
// ================================== Interrupt Descriptor Table
                
InterruptDescriptorTable:

                                    .FILL       512, 8, 0
                                    
InterruptDescriptorTableEnd:

InterruptDescriptorTablePointer:
InterruptDescriptorTableLimit:
                                    .WORD       InterruptDescriptorTableEnd - InterruptDescriptorTable - 1
InterruptDescriptorTableBase:
                                    .QUAD       InterruptDescriptorTable


// ================================== TASK STATUS SEGMENT 64 Table
                
TaskStatusSegment64Table:

                                    .FILL       13, 8, 0
                                    
TaskStatusSegment64TableEnd:

TaskStatusSegment64TablePointer:
TaskStatusSegment64TableLimit:
                                    .WORD       TaskStatusSegment64TableEnd - TaskStatusSegment64Table - 1
TaskStatusSegment64TableBase:
                                    .QUAD       TaskStatusSegment64Table
