.macro call($label)
  addi $sp, $sp, -4
  sw $ra, 0($sp)
  jal $label
.end_macro

.macro return
  move $t8, $ra
  lw $ra, 0($sp)
  addi $sp, $sp, 4
  jr $t8
.end_macro

.macro print_string($label)
  la $a0, $label
  li $v0, 4
  syscall
.end_macro

.macro print_register($r)
  move $a0, $r
  li $v0, 1
  syscall
.end_macro

.macro println_register($r)
  print_register($r)
  print_string(strings.newline)
.end_macro

.macro read_integer($r)
  li $v0, 5
  syscall
  move $r, $v0
.end_macro

.macro random_integer($r,$lower,$upper)
  li $t8, $lower
  li $t9, $upper
  sub $t9, $t9, $t8
  
  li $a0, 0
  move $a1, $t9
  li $v0, 42
  syscall
  
  add $r, $a0, $t8
.end_macro
