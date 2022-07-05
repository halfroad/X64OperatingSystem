// ================================== Initialize Pages

									.ALIGN 	8

									.ORG	0x1000
									
__PML4E:

									.QUAD	0x102007
									.FILL	255, 8, 7
									.QUAD	0x102007
									
									.FILL	255, 8, 0
									
									
									.ORG	0x2000
									
									
__PDPTE:

									.QUAD	0x103003
									
									.FILL	511, 8, 0
									
									
									.ORG	0x3000
									

__PDE:

									.QUAD	0x000083
									.QUAD	0x200083
									.QUAD	0x400083
									.QUAD	0x600083
									.QUAD	0x800083
									.QUAD	0xe0000083					/* 0x a00000 */
									.QUAD	0xe0200083
									.QUAD	0xe0400083
									.QUAD	0xe0600083					/* 0x 1000000 */
									.QUAD	0xe0800083
									.QUAD	0xe0a00083
									.QUAD	0xe0c00083
									.QUAD	0xe0e00083
									
									.FILL, 499, 8, 0
