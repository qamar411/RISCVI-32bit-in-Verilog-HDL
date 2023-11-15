.text
main:

li t0,-1
li t1,-2
li t2,100000
li t3,3

blt t1,t0,label_less_than

j end
label_less_than:
li s0,0xFFFFFFFF
bge t0,t1,bge_label
j end
bge_label:
srai s1,s0,31
bltu t2,t1, bltu_label
j end
bltu_label:
xori s2,s1,0
sw s2, 0(x0)
sltiu a0,t3,0
bgeu t1,t2,bgeu_label
j end
bgeu_label:
ori s3,s2,0
addi t4,t1,5
beq t3,t4,beq_label
j end
beq_label:
lw s4,0(x0)
bne t0,t1,bne_label
j end
bne_label:
and s5,s0,s4
li x23, 0xFE23
li x24, 255
slli x24, x24, 2
sw x23, 0(x24)
end:
.data
