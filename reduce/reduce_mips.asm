main:
  lw $a0, array_length
  la $a1, input_values
  li $a2, 0
  la $a3, add_int
  jal reduce
  j fin

add_int:
  add $v0, $a0, $a1
  jr $ra
  
# reduce over an array, accumulating a result by calling a function on each of its argument alongside the intermediate results.
reduce: # $a0 = array size, $a1 = input array, $a2 = initial value, $a3 = reducer function
  addi $sp, $sp, -16 # make space in the stack
  sw $ra, 0($sp)     # save return address to the stack

  sll $t0, $a0, 2   # v
  add $t0, $a1, $t0 # $t0 = end of the input array, to test when all elements have been reduced
  move $t1, $a1     # $t1 = pointer to the current element being reduced
  move $v0, $a2     # $t2 = (intermediate) result
  move $t3, $a3     # $t3 = function that will reduce the values
reduce_loop:
  beq $t0, $t1, reduce_finish # when input is at its end, finish function

  sw $t0, 4($sp)  # save required registers to the stack
  sw $t1, 8($sp)  # ^
  sw $t3, 12($sp) # ^

  move $a0, $v0   # set $a0 to the current intermediate result
  lw $a1, 0($t1)  # set $a1 to the current input element
  jalr $t3        # call reducer function

  lw $t0, 4($sp)  # restore required registers from stack
  lw $t1, 8($sp)  # ^
  lw $t3, 12($sp) # ^

  addi $t1, $t1, 4 # move input pointer forward 
  j reduce_loop # go back to start of loop

reduce_finish:
  lw $ra, 0($sp)    # restore return address
  addi $sp, $sp, 16 # restore stack pointer to its original value 
  jr $ra            # return

fin:
  
.data
array_length:  .word 10
input_values:  .word 1 2 3 4 5 6 7 8 9 10
