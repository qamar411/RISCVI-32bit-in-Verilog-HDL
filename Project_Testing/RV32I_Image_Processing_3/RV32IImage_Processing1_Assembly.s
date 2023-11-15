.text



start:





li t1,0  # j = 0;

li a0,0

li t6,144  # t6 stores the addres of matrix store 



image_outer_loop:

li t0,0   # initialzise i with zero



    image_inner_loop:

    li t2,0

    li t3,0  # initialise k and l with zero



        matrix_add_block:

        slli a1,t1,3

        slli a2,t1,2

        add a1,a1,a2

        add a1,a1,t0   # a1 = 10*j + i (matrix base addr)

        add a1,a1,a0 # a1 = matrix _base + image_base addr,





        lbu s0,0(a1)

        

        addi a1,a1,1

        lbu s1,0(a1)

        add s0,s0,s1

        

        addi a1,a1,1        

        lbu s1,0(a1)    

        add s0,s0,s1

 

        addi a1,a1,10               

        lbu s1,0(a1)

        add s0,s0,s1 

        

        addi a1,a1,1        

        lbu s1,0(a1)

        slli s1, s1,3

        add s0,s0,s1 

        

        addi a1,a1,1          

        lbu s1,0(a1)

        add s0,s0,s1 

        

        addi a1,a1,10        

        lbu s1,0(a1)

        add s0,s0,s1  

        

        addi a1,a1,1                      

        lbu s1,0(a1)

        add s0,s0,s1 

        

        addi a1,a1,1        

        lbu s1,0(a1)

        add s0,s0,s1 

        

        



        srli s0,s0,4    # s0 = (sum of matrix)/16



        sb s0,0(t6)

        addi t6,t6,1

        matrix_add_block_ends:



    addi t0,t0,1    

    li t4,10

    blt t0,t4,image_inner_loop

    image_inner_loop_end:



addi t1,t1,1

li t4,10   

blt t1,t4,image_outer_loop  # if j is less than 9 go back

image_outer_loop_end:

# image inversion

li t3, 100
li t1, 244
addi t0, x0, 243
li t2, 0

loop:

lb a0, 0(t0)
sb a0, 0(t1)
addi t1, t1, 1
addi t0, t0, -1
addi t2, t2, 1

bne t2, t3, loop




exit:



 

.data





A:                          # Matrix A

  .byte    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF

  .byte    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF 

  .byte    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF     

  .byte    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0xFF, 0xFF, 0xFF 

  .byte    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xFF, 0x00, 0xFF, 0xFF, 0xFF, 0xFF 

  .byte    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF 

  .byte    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xFF 

  .byte    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xFF, 0xFF, 0xFF, 0xFF 

  .byte    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xFF, 0xFF, 0xFF, 0xFF 

  .byte    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xFF, 0xFF, 0xFF, 0xFF 

  .byte    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xFF, 0xFF, 0xFF, 0xFF 

  .byte    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF



B:                          # Matrix B

.space 100





C:                          # Matrix C (Initialized to zeros)



