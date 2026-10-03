.text
main:
  # lui $sp, 0x10ff # init sp
  la $a0, array_length
  lw $a0, 0($a0)
  la $a1, array_values
  jal merge_sort
  j fin
  
  
merge_sort: # $a0 = size, $a1 = array pointer
  sll $a0, $a0, 1 # use auxiliary merge sort subroutine that accepts $a0 as size * 2,
                  # to save some sll operations
   
merge_sort_impl: # $a0 = size * 2, $a1 = array pointer
  li $t1, 4                          # check if size < 2 
  slt $t0, $a0, $t1                  # ^
  bne $t0, $zero, merge_sort_finish  # ^ if so, the array is already sorted; return.

  addi $sp, $sp, -24 # push arguments and return address to the stack, to prepare for recursive calls
  sw $ra, 20($sp)    # ^ make space for three extra elements at 8(Ssp), 4($sp) and 0($sp) for later
  sw $a1, 16($sp)    # ^
  sw $a0, 12($sp)    # ^

  andi $t0, $a0, 2  # handle odd number of elements
  sub $a0, $a0, $t0 # ^ make array size even. If it was odd, the left out element will be included in the other half of the array
  sw $a0, 8($sp)    # ^ push even array size to the stack to be used by merge_sort_join later

  sra $a0, $a0, 1     # divide array size by two, to sort half of the array
  jal merge_sort_impl # call merge sort and sort starting half of the array

  lw $a0, 12($sp) # recover arguments from stack
  lw $a1, 16($sp) # ^

  add $a1, $a1, $a0 # move array pointer by size*2 bytes, which is equivalent to moving it size/2 elements
                    # ^ so we can sort the second half of the array.

  andi $t0, $a0, 2  # handle odd number of elements
  add $a0, $a0, $t0 # ^ add (size % 2) to array size
  sub $a1, $a1, $t0 # ^ move back array pointer by (size % 2) elements
   
  sw $a1, 0($sp) # push array pointer (starting at middle of original array) to the stack
  sw $a0, 4($sp) # push size of second half of array to the stack

  sra $a0, $a0, 1     # divide array size by two, to sort half of the array 
  jal merge_sort_impl # call merge sort and sort second half of the array

                  # recover arguments from stack
  lw $a0, 8($sp)  # ^ $a0 = size*4 of the first half of the array
  lw $a1, 16($sp) # ^ $a1 = pointer to the first half of the array
  lw $a2, 4($sp)  # ^ $a2 = size*4 of the second half of the array
  lw $a3, 0($sp)  # ^ $a3 = pointer to the second half of the array
  
  jal merge_sort_join # join first and second halves of the array into a single sorted array

  lw $ra, 20($sp)   # recover return address to jump back from subroutine
  addi $sp, $sp, 24 # set stack pointer back to its original position
merge_sort_finish:
  jr $ra

merge_sort_join: # see lines 49~52 for descriptions of the arguments
  la $t0, aux_values # $t0 = pointer to the current position of the auxiliary array
  move $t1, $a1      # $t1 = pointer to the current position of the first half of the array
  move $t2, $a3      # $t2 = pointer to the current position of the second half of the array
  add $t6, $a1, $a0  # $t6 = pointer to the end of the first half of the array
  add $t7, $a3, $a2  # $t7 = pointer to the end of the second half of the array
                     # additional conventions:
                     # ^ array[k] == 0($t0)
                     # ^ array[i] == $t3 == 0($t1)
                     # ^ array[j] == $t4 == 0($t2)

merge_sort_join_loop_a: # loop a: compare elements between the two halves and add them to the auxiliary array
                        # ^ until one of the halves is exhausted.
  beq $t1, $t6, merge_sort_join_loop_a_finish # if first half is exhausted, exit loop a
  beq $t2, $t7, merge_sort_join_loop_a_finish # if second half is exhausted, exit loop a
  lw $t3, 0($t1) # $t3 = current element of the first half of the array
  lw $t4, 0($t2) # $t4 = current element of the second half of the array

  slt $t8, $t3, $t4                               # if array[i] < array[j]
  beq $t8, $zero, merge_sort_join_loop_a_clause_0 # ^
  sw $t3, 0($t0)                                  # ^  set aux[k] = array[i]
  addi $t0, $t0, 4                                # ^  move pointer to auxiliary array one element forward
  addi $t1, $t1, 4                                # ^  move pointer to first half of the array one element forward
  j merge_sort_join_loop_a                        # ^  return to start of loop a

merge_sort_join_loop_a_clause_0:                  # else if array[j] < array[i]
  slt $t8, $t4, $t3                               # ^ 
  beq $t8, $zero, merge_sort_join_loop_a_clause_1 # ^
  sw $t4, 0($t0)                                  # ^  set aux[k] = array[j]
  addi $t0, $t0, 4                                # ^  move pointer to auxiliary array one element forward
  addi $t2, $t2, 4                                # ^  move pointer to second half of array one element forward
  j merge_sort_join_loop_a                        # ^  return to start of loop a

merge_sort_join_loop_a_clause_1:                  # else (in this case, array[i] == array[j])
  sw $t3, 0($t0)                                  # ^  set aux[k] = array[i]
  sw $t4, 4($t0)                                  # ^  set aux[k+1] = array[j]
  addi $t0, $t0, 8                                # ^  move pointer to auxiliary array two elements forward
  addi $t1, $t1, 4                                # ^  move pointer to first half of the array one element forward
  addi $t2, $t2, 4                                # ^  move pointer to second half of the array one element forward
  j merge_sort_join_loop_a                        # ^  return to start of loop a

merge_sort_join_loop_a_finish:         # if either half of the array remains unexhausted, copy the remaining elements to the auxiliary array
  bne $t1, $t6, merge_sort_join_loop_b # ^ if the first half is unexhausted, copy from the first half
  bne $t2, $t7, merge_sort_join_loop_c # ^ if the second half is unexhausted, copy from the second half
  j merge_sort_join_loop_d_start       # ^ if neither, skip to next step

merge_sort_join_loop_b: # loop b: copy remaining elements of the first half of the array to the auxiliary array
  lw $t3, 0($t1)        # ^  set aux[k] = array[i]
  sw $t3, 0($t0)        # ^
  addi $t0, $t0, 4      # ^  move pointer to auxiliary array one element forward
  addi $t1, $t1, 4      # ^  move pointer to first half of the array one element forward
  bne $t1, $t6, merge_sort_join_loop_b # if there are elements remaining, go back to start of loop b
  j merge_sort_join_loop_d_start       # ^ otherwise, go to next step

merge_sort_join_loop_c: # loop c: copy remaining elements of the second half of the array to the auxiliary array
  lw $t4, 0($t2)        # ^  set aux[k] = array[i]
  sw $t4, 0($t0)        # ^
  addi $t0, $t0, 4      # ^  move pointer to auxiliary array one element forward
  addi $t2, $t2, 4      # ^  move pointer to second half of the array one element forward
  bne $t2, $t7, merge_sort_join_loop_c # if there are elements remaining, go back to start of loop c

merge_sort_join_loop_d_start: # prepare loop d
  move $t1, $t2               # ^ $t1 = pointer to the end of the array
  la $t2, aux_values          # ^ $t2 = pointer to the beginning of the auxiliary array

merge_sort_join_loop_d: # copy back the elements of the auxiliary array that were set in this subroutine call back into the array
  lw $t3, -4($t0)       # ^  set array[i-1] = aux[k-1]
  sw $t3, -4($t1)       # ^
  addi $t0, $t0, -4     # ^  move pointer to auxiliary array one element back
  addi $t1, $t1, -4     # ^  move pointer to array one element back
  bne $t0, $t2, merge_sort_join_loop_d # if there's still elements in the auxiliary array, return to start of loop d

merge_sort_join_finish: # array is merged and sorted
  jr $ra


fin: # program finish
  sll $0, $0, 0
  
  
.data 0x10010000
# input array
array_length: .word 20
array_values: .word 3 5 9 19 1 4 2 7 10 13 6 16 15 8 11 18 14 12 0 17

# auxiliary array (must have at least same size as input array)
aux_length: .word 20
aux_values: .word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0

