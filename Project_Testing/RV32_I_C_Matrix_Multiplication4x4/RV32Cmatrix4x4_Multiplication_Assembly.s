data.elf:     file format elf64-littleriscv


Disassembly of section .text:

00000000000100b0 <start>:
   100b0:	4091                	li	ra,4
   100b2:	4e01                	li	t3,0
   100b4:	4e81                	li	t4,0
   100b6:	4f01                	li	t5,0
   100b8:	4281                	li	t0,0
   100ba:	04000313          	li	t1,64
   100be:	08000393          	li	t2,128

00000000000100c2 <outer_loop>:
   100c2:	061e0463          	beq	t3,ra,1012a <exit>
   100c6:	4e81                	li	t4,0

00000000000100c8 <inner_loop>:
   100c8:	041e8e63          	beq	t4,ra,10124 <inner_exit>
   100cc:	00000493          	li	s1,0
   100d0:	4f01                	li	t5,0

00000000000100d2 <matrix_mult>:
   100d2:	021f0d63          	beq	t5,ra,1010c <end_mult>
   100d6:	004e1f93          	slli	t6,t3,0x4
   100da:	002f1413          	slli	s0,t5,0x2
   100de:	9fa2                	add	t6,t6,s0
   100e0:	9f96                	add	t6,t6,t0
   100e2:	000fa903          	lw	s2,0(t6)
   100e6:	004f1f93          	slli	t6,t5,0x4
   100ea:	002e9413          	slli	s0,t4,0x2
   100ee:	9fa2                	add	t6,t6,s0
   100f0:	9f9a                	add	t6,t6,t1
   100f2:	000fa983          	lw	s3,0(t6)
   100f6:	4a01                	li	s4,0

00000000000100f8 <multiplication>:
   100f8:	00098563          	beqz	s3,10102 <end_multiplication>
   100fc:	9a4a                	add	s4,s4,s2
   100fe:	19fd                	addi	s3,s3,-1
   10100:	bfe5                	j	100f8 <multiplication>

0000000000010102 <end_multiplication>:
   10102:	8952                	mv	s2,s4
   10104:	94ca                	add	s1,s1,s2
   10106:	0f05                	addi	t5,t5,1
   10108:	b7e9                	j	100d2 <matrix_mult>
   1010a:	0001                	nop

000000000001010c <end_mult>:
   1010c:	004e1f93          	slli	t6,t3,0x4
   10110:	002e9413          	slli	s0,t4,0x2
   10114:	9fa2                	add	t6,t6,s0
   10116:	9f9e                	add	t6,t6,t2
   10118:	009fa023          	sw	s1,0(t6)
   1011c:	0e85                	addi	t4,t4,1
   1011e:	0411                	addi	s0,s0,4
   10120:	b765                	j	100c8 <inner_loop>
   10122:	0001                	nop

0000000000010124 <inner_exit>:
   10124:	0e05                	addi	t3,t3,1
   10126:	bf71                	j	100c2 <outer_loop>
   10128:	0001                	nop
