.text
main:
  la $a0, array_length
  lw $a0, 0($a0)
  la $a1, array_values
  li $a2, 10
  jal binary_search
  j fin

binary_search: # $a0 = array size, $a1 = array pointer, $a2 = element to search (key)
  li $t0, 0         # $t0 = least position the element can be at
  addi $t1, $a0, -1 # $t1 = last position the element can be at
binary_search_loop:
  slt $t2, $t1, $t0                       # The search stops once the rightmost element position is less than the leftmos. 
  bne $t2, $zero, binary_search_not_found # ^
  
  add $t2, $t0, $t1 # $t2 = position of the element to be compared
  sra $t2, $t2, 1   # ^ it is obtatined with $t2 = ($t0 + $t1)/2

  sll $t3, $t2, 2   # $t3 = element to be compared.
  add $t3, $t3, $a1 # ^ basically, $t3 = array[$t2]
  lw $t3, 0($t3)    # ^

  beq $t3, $a2, binary_search_found # if array[$t2] == $a2, return $t2

  slt $t4, $a2, $t3                  # otherwise, check if $a2 is less or more than array[$t2]
  bne $t4, $zero, binary_search_less # ^ branching accordingly

binary_search_greater:   # if $a2 < array[$t2]
  addi $t0, $t2, 1       #   set $t0 = $t2 + 1
  j binary_search_loop   #   return to start of loop

binary_search_less:      # else if $a2 > array[$t2]
  addi $t1, $t2, -1      #   set $t1 = $t2 - 1
  j binary_search_loop   #   return to start of loop

binary_search_found:
  move $v0, $t2
  jr $ra

binary_search_not_found:
  li $v0, -1
  jr $ra


fin:
  sll $0, $0, 0
    
.data 0x10010000
# input array
array_length: .word 20
array_values: .word 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
