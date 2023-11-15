data.elf:     file format elf64-littleriscv


Disassembly of section .text:

00000000000100b0 <start>:
   100b0:	4301                	li	t1,0
   100b2:	4501                	li	a0,0
   100b4:	09000f93          	li	t6,144

00000000000100b8 <image_outer_loop>:
   100b8:	4281                	li	t0,0

00000000000100ba <image_inner_loop>:
   100ba:	4381                	li	t2,0
   100bc:	4e01                	li	t3,0

00000000000100be <matrix_add_block>:
   100be:	00331593          	slli	a1,t1,0x3
   100c2:	00231613          	slli	a2,t1,0x2
   100c6:	95b2                	add	a1,a1,a2
   100c8:	9596                	add	a1,a1,t0
   100ca:	95aa                	add	a1,a1,a0
   100cc:	0005c403          	lbu	s0,0(a1)
   100d0:	0585                	addi	a1,a1,1
   100d2:	0005c483          	lbu	s1,0(a1)
   100d6:	9426                	add	s0,s0,s1
   100d8:	0585                	addi	a1,a1,1
   100da:	0005c483          	lbu	s1,0(a1)
   100de:	9426                	add	s0,s0,s1
   100e0:	05a9                	addi	a1,a1,10
   100e2:	0005c483          	lbu	s1,0(a1)
   100e6:	9426                	add	s0,s0,s1
   100e8:	0585                	addi	a1,a1,1
   100ea:	0005c483          	lbu	s1,0(a1)
   100ee:	048e                	slli	s1,s1,0x3
   100f0:	9426                	add	s0,s0,s1
   100f2:	0585                	addi	a1,a1,1
   100f4:	0005c483          	lbu	s1,0(a1)
   100f8:	9426                	add	s0,s0,s1
   100fa:	05a9                	addi	a1,a1,10
   100fc:	0005c483          	lbu	s1,0(a1)
   10100:	9426                	add	s0,s0,s1
   10102:	0585                	addi	a1,a1,1
   10104:	0005c483          	lbu	s1,0(a1)
   10108:	9426                	add	s0,s0,s1
   1010a:	0585                	addi	a1,a1,1
   1010c:	0005c483          	lbu	s1,0(a1)
   10110:	9426                	add	s0,s0,s1
   10112:	8011                	srli	s0,s0,0x4
   10114:	008f8023          	sb	s0,0(t6)
   10118:	0f85                	addi	t6,t6,1

000000000001011a <matrix_add_block_ends>:
   1011a:	0285                	addi	t0,t0,1
   1011c:	4ea9                	li	t4,10
   1011e:	f9d2cee3          	blt	t0,t4,100ba <image_inner_loop>

0000000000010122 <image_inner_loop_end>:
   10122:	0305                	addi	t1,t1,1
   10124:	4ea9                	li	t4,10
   10126:	f9d349e3          	blt	t1,t4,100b8 <image_outer_loop>

