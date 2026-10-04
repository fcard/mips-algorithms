.text
main:
  la $a0, input
  jal rot13

  li $v0, 4 # print encoded string
  syscall   # ^
  j fin
  
rot13:
  move $t0, $a0 # $t0 = pointer to the current character to be decoded
rot13_loop:
  lb $t1, 0($t0) # $t1 = character to be decoded
  beq $t1, $zero, rot13_finish # $t1 == null character; return.

  # test if 'A' <= $t1 <= 'Z', i.e. it's an uppercase character
  li $t2, 'A'
  slt $t2, $t1, $t2
  bne $t2, $zero, rot13_next
  li $t2, 'Z'
  slt $t2, $t2, $t1
  beq $t2, $zero, rot13_uppercase
  
  # test if 'a' <= $t1 <= 'z', i.e. it's an lowercase character
  li $t2, 'a'
  slt $t2, $t1, $t2
  bne $t2, $zero, rot13_next
  li $t2, 'z'
  slt $t2, $t2, $t1
  bne $t2, $zero, rot13_next

rot13_lowercase:
  # branch  depending if $t1 is above 'n' or not
  li $t2, 'n'
  slt $t2, $t1, $t2
  bne $t2, $zero, rot13_below_n
  j rot13_n_and_above

rot13_uppercase:
  # branch  depending if $t1 is above 'N' or not
  li $t2, 'N'
  slt $t2, $t1, $t2
  bne $t2, $zero, rot13_below_n

rot13_n_and_above:
  addi $t1, $t1, -13 # if $t1 >= 'n', decrease it by 13
  j rot13_set

rot13_below_n:
  addi $t1, $t1, 13 # if $t1 < 'n', increase it by 13

rot13_set:       # we arrive here if $t1 was changed
  sb $t1, 0($t0) # ^ change the contents of ($t0) to its new value

rot13_next:
  addi $t0, $t0, 1 # move to next byte and restart loop
  j rot13_loop     # ^
  
rot13_finish:
  jr $ra
  
fin:
  

.data
input: .asciiz "Hello World!"
