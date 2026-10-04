main:
  lw $a0, array_length
  la $a1, input_values
  la $a2, output_values
  la $a3, double
  jal map
  j fin

double: # multiplies the input by 2
  add $v0, $a0, $a0
  jr $ra

# sets output[i] = function(input[i]) for every i from 0 to size(input)
# the output must have at least the same size as the input.
map: # $a0 = array size, $a1 = input array, $a2 = output array, $a3 = function that will map the values
  addi $sp, $sp, -20 # make space in the stack
  sw $ra, 0($sp)     # save return address to the stack

  sll $t0, $a0, 2   # v
  add $t0, $a1, $t0 # $t0 = end of the input array, to test when all elements have been mapped
  move $t1, $a1     # $t1 = pointer to the current element being mapped
  move $t2, $a2     # $t2 = pointer to the current output element
  move $t3, $a3     # $t3 = function that will map the values
map_loop:
  beq $t0, $t1, map_finish # when input is at its end, finish function

  sw $t0, 4($sp)  # save required registers to the stack
  sw $t1, 8($sp)  # ^
  sw $t2, 12($sp) # ^
  sw $t3, 16($sp) # ^

  lw $a0, 0($t1)  # set $a0 to the current input element
  jalr $t3        # call mapper function

  lw $t0, 4($sp)  # restore required registers from stack
  lw $t1, 8($sp)  # ^
  lw $t2, 12($sp) # ^
  lw $t3, 16($sp) # ^

  sw $v0, 0($t2) # set current output element to the result of the function call
  
  addi $t1, $t1, 4 # move input pointer forward 
  addi $t2, $t2, 4 # move output pointer forward
  j map_loop # go back to start of loop

map_finish:
  lw $ra, 0($sp)    # restore return address
  addi $sp, $sp, 20 # restore stack pointer to its original value 
  jr $ra            # return

fin:

.data
array_length:  .word 10
input_values:  .word 1 2 3 4 5 6 7 8 9 10
output_values: .word 0 0 0 0 0 0 0 0 0 0