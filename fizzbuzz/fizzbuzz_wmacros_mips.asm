
.macro print_string($label)
  la $a0, $label
  li $v0, 4
  syscall
.end_macro

.macro println_integer($r)
  move $a0, $r
  li $v0, 1
  syscall
  la $a0, newline
  li $v0, 4
  syscall
.end_macro

.macro mod($dest, $p, $q)
  div $p, $q
  mfhi $dest
.end_macro

.macro if_less_goto($a, $b, $label)
  slt $t8, $a, $b
  bne $t8, $zero, $label
.end_macro

main:
  li $a0, 20
  j fizz_buzz

# fizz_buzz : for x from 0 to $a0, print Fizz if 3 | x, Buzz if 5 | x, FizzBuzz if 3 | x and 5 | x, and otherwise print x
fizz_buzz: # $a0 = final number
  li $t0, 0     # $t0 = current number to be fizzbuzz'd
  li $t1, 3     # $t1 = 3, to check if 3 | $t0
  li $t2, 5     # $t2 = 5, to check if 5 | $t0
  move $t3, $a0 # $t3 = $a0, to check if the loop is over

fizz_buzz_loop:
  if_less_goto($t3, $t0, fizz_buzz_finish) # loop function until $t3 < $t0, i.e. all numbers have been fizzbuzz'd

  mod($t4, $t0, $t1) # $t4 = $t0 % $t1. If $t4 == 0, 3 | $t0
  mod($t5, $t0, $t2) # $t4 = $t0 % $t1. If $t5 == 0, 5 | $t0
  
  or $t6, $t4, $t5 # $t6 == 0 if both $t4 == 0 and $t5 == 0
  bne $t6, $zero, not_both_fizz_buzz # if $t6 != 0, then $t0 is not divisible by 3 or $t0 is not divisible by 5.

  print_string(fizz_and_buzz)
  j fizz_buzz_loop_next
  
not_both_fizz_buzz: # only one of fizz or buzz will be printed, or neither
  beq $t4, $zero, fizz_buzz_fizz # fizz will be printed
  beq $t5, $zero, fizz_buzz_buzz # buzz will be printed

  # neither fizz or buzz, so just print the number
  println_integer($t0)
  j fizz_buzz_loop_next
  
fizz_buzz_fizz: # print Fizz
  print_string(fizz)
  j fizz_buzz_loop_next
  
fizz_buzz_buzz: # print Buzz
  print_string(buzz)
  
fizz_buzz_loop_next: # move to next number
  addi $t0, $t0, 1
  j fizz_buzz_loop
  
fizz_buzz_finish:
  
  
.data 0x10010000
fizz: .asciiz "Fizz\n"
buzz: .asciiz "Buzz\n"
fizz_and_buzz: .asciiz "FizzBuzz\n"
newline: .asciiz "\n"