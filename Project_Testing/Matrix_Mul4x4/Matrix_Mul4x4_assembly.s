.text

start:
  # Matrix multiplication code
  li      x1, 4             # Rows of matrix A (Square Matrices)
  li      t3, 0             # Counter i
  li      t4, 0             # Counter j
  li      t5, 0             # Counter k
  li      t0, 0             # Address of matrix A
  li      t1, 64             # Address of matrix B
  li      t2, 128             # Address of matrix C
  
outer_loop:
  beq     t3, x1, exit      # Check if i = rows of matrix A
  addi x0,x0,0
  li      t4, 0             # Reset j counter
  
inner_loop:
  beq     t4, x1, inner_exit# Check if j = columns of matrix B
  addi x0,x0,0
  mv s1, x0            # Set C[i][j] to zero
  li      t5, 0             # Reset k counter
  
matrix_mult:
  beq     t5, x1, end_mult  # Check if k = columns of matrix A
  addi x0,x0,0
  slli t6,t3,4 # t6 =  16*i
  slli s0,t5,2 # s0 = 4*k
  add t6,t6,s0 # t6 = 16*i + 4*k
  add t6,t6,t0 # base adder of matrix A + offset
  lw    s2 , 0(t6)         # Load A[i][k] into s2
  
  slli t6,t5,4 # t6 =  16*k
  slli s0,t4,2 # s0 = 4*j
  add t6,t6,s0 # t6 = 16*k + 4*j
  add t6,t6,t1 # base adder of matrix B + offset 
  lw     s3, 0(t6)         # Load B[k][j] into s3

  
 # mul  s2, s2, s3        # Multiply A[i][k] and B[k][j]

li s4, 0

multiplication:
    beqz s3, end_multiplication
    add s4,s4,s2
    addi s3,s3,-1
    j multiplication
    
end_multiplication:
mv s2, s4

  
      add  s1, s1, s2        # Add result to C[i][j]
  addi t5,t5,1              # k <= k + 1
  j       matrix_mult
  addi x0,x0,0
  
end_mult:

  slli t6,t3,4 # t6 =  16*i
  slli s0,t4,2 # s0 = 4*j
  add t6,t6,s0 # t6 = 16*i + 4*j
  add t6,t6,t2 # base adder of matrix C + offset 
  sw     s1, 0(t6)         # Store result in C[i][j]
  
  addi    t4, t4, 1         # Increment j counter
  addi s0,s0,4
  j       inner_loop
  addi x0,x0,0
  
inner_exit:
  addi    t3, t3, 1         # Increment i counter
  j       outer_loop
  addi x0,x0,0

exit:

  
.data


A:                          # Matrix A
  .word 1, 2, 3, 4
  .word 5, 6, 7, 8
  .word 9, 10, 11, 12
  .word 13, 14, 15, 16

B:                          # Matrix B
  .word 1, 2, 3, 4
  .word 5, 6, 7, 8
  .word 9, 10, 11, 12
  .word 13, 14, 15, 16

C:                          # Matrix C (Initialized to zeros)
  .space 64
