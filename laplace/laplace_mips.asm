.text

main:
  la $a0, strings.input_matrix_length
  li $v0, 4
  syscall
  li $v0, 5
  syscall
  move $a0, $v0
  sw $a0, matrix.size
  jal create_matrix

  lw $a0, matrix.size
  sw $v0, matrix.address
  move $a1, $v0
  jal populate_matrix

  la $a0, strings.newline
  li $v0, 4
  syscall
  
  lw $a0, matrix.size
  lw $a1, matrix.address
  jal print_matrix

  lw $a0, matrix.size
  lw $a1, matrix.address
  jal laplace
  
  move $t0, $v0
  la $a0, strings.determinant_is
  li $v0, 4
  syscall
  move $a0, $t0
  li $v0, 1
  syscall
  la $a0, strings.newline
  li $v0, 4
  syscall

  li $a0, 0
  li $v0, 17
  syscall
  
  
laplace:
  addi $sp, $sp, -20
  sw $ra, 0($sp)
  sw $a0, 4($sp)
  sw $a1, 8($sp)
  sw $zero, 12($sp)
  sw $zero, 16($sp)
  
  beq $a0, 1, laplace.order_1
  beq $a0, 2, laplace.order_2
  
laplace.loop:
  lw $a0, 4($sp)
  lw $a1, 8($sp)
  lw $a2, 12($sp)
  
  beq $a0, $a2, laplace.loop_end
  
  addi $a2, $a2, 1
  sw $a2, 12($sp)
  
  jal create_cofactor_matrix

  lw $a0, 4($sp)
  subi $a0, $a0, 1
  move $a1, $v0
  jal laplace
  
  lw $t4, 4($sp)
  lw $t0, 8($sp)
  lw $t1, 12($sp)
  lw $t2, 12($sp)
  addi $t1, $t1, -1
  mul $t1, $t1, $t4
  sll $t1, $t1, 2
  add $t0, $t0, $t1
  lw $t0, 0($t0)
  mul $t0, $t0, $v0

  andi $t2, $t2, 1
  beq $t2, $zero, laplace.loop.add_det
  mul $t0, $t0, -1
  
laplace.loop.add_det:
  lw $a3, 16($sp)
  add $a3, $a3, $t0
  sw $a3, 16($sp)
  j laplace.loop
  
laplace.loop_end:
  lw $v0, 16($sp)
  j laplace.end
 
laplace.order_1:
  lw $v0, 0($a1)
  j laplace.end

laplace.order_2:
  lw $t0, 0($a1)
  lw $t1, 4($a1)
  lw $t2, 8($a1)
  lw $t3, 12($a1)
  mul $t4, $t0, $t3
  mul $t5, $t1, $t2
  sub $v0, $t4, $t5
  j laplace.end
  
laplace.end:
  lw $ra, 0($sp)
  addi $sp, $sp, 20
  jr $ra
  
create_cofactor_matrix:
  addi $sp, $sp, -16
  sw $ra, 0($sp)
  sw $a0, 4($sp)
  sw $a1, 8($sp)
  sw $a2, 12($sp)

  subi $a0, $a0, 1
  jal create_matrix
  
  lw $t0, 4($sp)
  lw $t1, 8($sp)
  lw $t2, 12($sp)
  move $t3, $v0
  
  sll $t8, $t0, 2

  subi $t0, $t0, 1 
  mul $t4, $t0, $t0
  sll $t4, $t4, 2
  add $t4, $t3, $t4

  sll $t5, $t0, 2
  move $t6, $t3
  
  li $t7, 0
  
create_cofactor_matrix.loop:
  beq $t3, $t4, create_cofactor_matrix.end
  bne $t3, $t6, create_cofactor_matrix.dont_skip_line
  add $t1, $t1, 4
  add $t6, $t6, $t5
  add $t7, $t7, 1
  bne $t7, $t2, create_cofactor_matrix.dont_skip_line
  add $t1, $t1, $t8
  j create_cofactor_matrix.loop

create_cofactor_matrix.dont_skip_line:
  lw $t9, 0($t1)
  sw $t9, 0($t3)
  add $t1, $t1, 4
  add $t3, $t3, 4
  j create_cofactor_matrix.loop
  
create_cofactor_matrix.end:
  lw $ra, 0($sp)
  addi $sp, $sp, 16
  jr $ra

print_matrix:
  move $t0, $a0
  move $t1, $a1
  mul $t2, $a0, $a0
  sll $t2, $t2, 2
  add $t2, $t1, $t2
  sll $t3, $a0, 2
  add $t4, $t1, $t3 

  la $a0, strings.matrix_start
  li $v0, 4
  syscall

print_matrix.loop:
  bne $t1, $t4, print_matrix.skip_line
  add $t4, $t4, $t3
  la $a0, strings.matrix_linebreak
  li $v0, 4
  syscall
  beq $t1, $t2, print_matrix.end
  la $a0, strings.matrix_start
  li $v0, 4
  syscall
print_matrix.skip_line:
  lw $a0, 0($t1)
  li $v0, 1
  syscall

  la $a0, strings.space
  li $v0, 4
  syscall

  addi $t1, $t1, 4
  j print_matrix.loop
print_matrix.end:
  jr $ra 


populate_matrix:
  move $t0, $a1
  mul $t1, $a0, $a0
  sll $t1, $t1, 2
  add $t1, $t0, $t1
  la $a0, strings.input_matrix_values
  li $v0, 4
  syscall
populate_matrix.loop:
  beq $t0, $t1, populate_matrix.end
  li $v0, 5
  syscall
  sw $v0, 0($t0)
  addi $t0, $t0, 4
  j populate_matrix.loop
populate_matrix.end:
  jr $ra 

create_matrix:
  blez $a0, create_matrix.below_one
  mult $a0, $a0
  mfhi $t0
  bne $t0, $zero, create_matrix.alloc_size_too_big
  mflo $t0
  bge $t0, 16000, create_matrix.alloc_size_too_big
  sll $a0, $t0, 2
  li $v0, 9
  syscall
  jr $ra
  
create_matrix.below_one:
  la $a0, strings.alloc_size_non_positive
  li $v0, 4
  syscall
  li $a0, -1
  li $v0, 17
  syscall
  
create_matrix.alloc_size_too_big:
  la $a0, strings.alloc_size_too_big
  li $v0, 4
  syscall
  li $a0, -1
  li $v0, 17
  syscall

.data

matrix.size: .word 0
matrix.address: .word 0

strings.matrix_start: .asciiz "| "
strings.matrix_linebreak: .asciiz "|\n"
strings.newline: .asciiz "\n"
strings.space: .asciiz " "
strings.alloc_size_too_big: .asciiz "Cannot allocate data: required size too large.\n"
strings.alloc_size_non_positive: .asciiz "Cannot allocate data: size must be a positive integer.\n"
strings.input_matrix_length: .asciiz "Input matrix size below:\n"
strings.input_matrix_values: .asciiz "Input all matrix values below:\n"
strings.determinant_is: .asciiz "Determinant is = "

