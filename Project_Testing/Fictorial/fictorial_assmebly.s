.data
n: .word 5     # The number for which factorial is to be calculated
result: .word 1

.text
main:
li a0, 4
call fact

mv s0, a1
li a0, 5
call fact
mv s1, a1

li a0, 3
call fact
mv s2, a1

li a0, 6
call fact
mv s3, a1





j end




fact:
    li a1, 1         # Initialize a1 to 1 (the factorial result)
    li t0, 1         # Initialize a counter (t0) to 1

loop:
    beq a0, zero, factend   # If n == 0, exit the loop
    
    
 mv t1,t0
 mv a2,x0

multiplication:
    beqz t1, end_multiplication
    add a2,a2,a1
    addi t1,t1,-1
    j multiplication
end_multiplication:
    
    addi t0, t0, 1      # Increment counter
    addi a0, a0, -1       # Decrement n
    mv a1, a2
    j loop
    
factend:    
    ret
    
    
    
    
    
    

end:
    #sw a1, result    # Store the result in memory

    # End program
