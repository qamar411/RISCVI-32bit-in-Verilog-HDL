# define MEM_LAST_ADDR 255

.text
addi x1, x0, -5
li x3, 15

li t0,35
add x1, x1, x3
add x2, x1, x1
add t0,x0,x0 
sw  x2, 4(t0)
lw  x6, 4(x0)
sw  x6, 8(x0)
lb  x9, 8(x0)
addi x9, x9, 5
sh  x6, 12(x0)
beq x0, x0, label
label2:
lui x7, 0xdead
auipc x8, 0xbeef
j exit
label:

jal label2
exit:

addi x21, x8, -10
beq x21, x8, exit2
lbu x22, 8(x0)
xor x21, x22, x21


exit2:

li x23, 0xFE23
li x24, 255
slli x24, x24, 2
sw x23, 0(x24)
