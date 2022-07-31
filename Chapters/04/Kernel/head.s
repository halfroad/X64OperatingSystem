# 1 "head.S"
# 1 "<built-in>" 1
# 1 "head.S" 2


                                    .SECTION .text

                                    .GLOBL _start

_start:

                                    MOV $0x10, %ax
                                    MOV %ax, %ds
                                    MOV %ax, %es
                                    MOV %ax, %fs
                                    MOV %ax, %ss
                                    MOV $0x7e00, %esp




                                    LGDT GlobalDescriptorTablePointer (%rip)




                                    LIDT InterruptDescriptorTablePointer (%rip)

                                    MOV $0x10, %ax
                                    MOV %ax, %ds
                                    MOV %ax, %es
                                    MOV %ax, %fs
                                    MOV %ax, %gs
                                    MOV %ax, %ss

                                    MOVQ $0x7e00, %rsp




                                    MOVQ $0x101000, %rax
                                    MOVQ %rax, %cr3

                                    MOVQ SwitchSegment (%rip), %rax

                                    PUSHQ $0x08
                                    PUSHQ %rax

                                    LRETQ





SwitchSegment:

                                    .QUAD Entry64


Entry64:

                                    MOVQ $0x10, %rax
                                    MOVQ %rax, %ds
                                    MOVQ %rax, %es
                                    MOVQ %rax, %gs
                                    MOVQ %rax, %ss

                                    MOVQ $0xffff800000007e00, %rsp

                                    MOVQ EnterKernel (%rip), %rax

                                    PUSHQ $0x08
                                    PUSHQ %rax

                                    LRETQ


EnterKernel:

                                    .QUAD StartKernel




         .ALIGN 8

         .ORG 0x1000

__PML4E:

         .QUAD 0x102007
         .FILL 255, 8, 0
         .QUAD 0x102007

         .FILL 255, 8, 0


         .ORG 0x2000


__PDPTE:

         .QUAD 0x103003

         .FILL 511, 8, 0


         .ORG 0x3000


__PDE:

         .QUAD 0x000083
         .QUAD 0x200083
         .QUAD 0x400083
         .QUAD 0x600083
         .QUAD 0x800083
         .QUAD 0xe0000083
         .QUAD 0xe0200083
         .QUAD 0xe0400083
         .QUAD 0xe0600083
         .QUAD 0xe0800083
         .QUAD 0xe0a00083
         .QUAD 0xe0c00083
         .QUAD 0xe0e00083

         .FILL 499, 8, 0




                                    .SECTION .data

                                    .GLOBL GlobalDescriptorTable

GlobalDescriptorTable:

                                    .QUAD 0x0000000000000000
                                    .QUAD 0x0020980000000000
                                    .QUAD 0x0000920000000000
                                    .QUAD 0x0020f80000000000
                                    .QUAD 0x0000f20000000000
                                    .QUAD 0x00cf9a000000ffff
                                    .QUAD 0x00cf92000000ffff
                                    .FILL 10, 8, 0

GlobalDescriptorTableEnd:

GlobalDescriptorTablePointer:
GlobalDescriptorTableLimit:
                                    .WORD GlobalDescriptorTableEnd - GlobalDescriptorTable - 1
GlobalDescriptorTableBase:
                                    .QUAD GlobalDescriptorTable


                                    .GLOBL InterruptDescriptorTable




InterruptDescriptorTable:

                                    .FILL 512, 8, 0

InterruptDescriptorTableEnd:

InterruptDescriptorTablePointer:
InterruptDescriptorTableLimit:
                                    .WORD InterruptDescriptorTableEnd - InterruptDescriptorTable - 1
InterruptDescriptorTableBase:
                                    .QUAD InterruptDescriptorTable




TaskStatusSegment64Table:

                                    .FILL 13, 8, 0

TaskStatusSegment64TableEnd:

TaskStatusSegment64TablePointer:
TaskStatusSegment64TableLimit:
                                    .WORD TaskStatusSegment64TableEnd - TaskStatusSegment64Table - 1
TaskStatusSegment64TableBase:
                                    .QUAD TaskStatusSegment64Table
