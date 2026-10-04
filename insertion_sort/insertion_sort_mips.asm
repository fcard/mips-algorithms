.text
main:
  # lui $sp, 0x10ff # init sp
  la $a0, array_length
  lw $a0, 0($a0)
  la $a1, array_values
  jal insertion_sort
  j fin
  
  
insertion_sort:
  beq $a0, $zero, insertion_sort_finish # if the array is empty, it is sorted; return.

  li $t0, 1
  beq $a0, $t0, insertion_sort_finish # if the array has size 1, it is sorted; return.
  
  add $t0, $a1, 4   # $t0 = pointer to the key element in the array, start at the second element
  sll $t1, $a0, 2
  add $t7, $a1, $t1 # $t7 = pointer to the end of the array
  
insertion_sort_loop_a:
  lw $t1, 0($t0) # $t1 = key 
  move $t2, $t0  # $t2 = pointer to the element next to the element being compared to the key

insertion_sort_loop_b: # compare every element before the key to the key, moving any elements greater than it one position forward
  lw $t3, -4($t2) # $t3 = element to be compared to the key
  slt $t4, $t1, $t3
  beq $t4, $zero, insertion_sort_loop_b_finish # if $t3 >= key, we found the position for the key

  sw $t3, 0($t2) # otherwise, we move the element one position forward
  addi $t2, $t2, -4 # and keep seeking backwards
  bne $t2, $a1, insertion_sort_loop_b # unless we've reached the beginning of the array
  
insertion_sort_loop_b_finish:
  sw $t1, 0($t2) # place the key behind all elements that were determined to be larger than it.
  addi $t0, $t0, 4
  bne $t0, $t7, insertion_sort_loop_a

insertion_sort_finish:
  jr $ra

fin:
  sll $0, $0, 0
    
.data 0x10010000
# input array
array_length: .word 20
array_values: .word 3 5 9 19 1 4 2 7 10 13 6 16 15 8 11 18 14 12 0 17
