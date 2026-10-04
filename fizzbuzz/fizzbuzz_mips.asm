main:
  addi $a0, $zero, 20
  j fizz_buzz

# fizz_buzz : for x from 0 to $a0, print Fizz if 3 | x, Buzz if 5 | x, FizzBuzz if 3 | x and 5 | x, and otherwise print x
fizz_buzz: # $a0 = final number
  add $t0, $zero, $zero # $t0 = current number to be fizzbuzz'd
  addi $t1, $zero, 3    # $t1 = 3, to check if 3 | $t0
  addi $t2, $zero, 5    # $t2 = 5, to check if 5 | $t0
  add $t3, $a0, $zero   # $t3 = $a0, to check if the loop is over

fizz_buzz_loop:
  slt $t4, $t3, $t0                # loop function until $t3 < $t0, i.e. all numbers have been fizzbuzz'd
  bne $t4, $zero, fizz_buzz_finish # ^

  div $t0, $t1 # v
  mfhi $t4     # $t4 = $t0 % $t1. If $t4 == 0, 3 | $t0
  
  div $t0, $t2 # v
  mfhi $t5     # $t5 = $t0 % $t2. If $t5 == 0, 5 | $t0
  
  or $t6, $t4, $t5 # $t6 == 0 if both $t4 == 0 and $t5 == 0
  bne $t6, $zero, not_both_fizz_buzz # if $t6 != 0, then $t0 is not divisible by 3 or $t0 is not divisible by 5.

  la $a0, fizz_and_buzz # print FizzBuzz
  addi $v0, $zero, 4    # ^
  syscall               # ^

  j fizz_buzz_loop_next
  
not_both_fizz_buzz: # only one of fizz or buzz will be printed, or neither
  beq $t4, $zero, fizz_buzz_fizz # fizz will be printed
  beq $t5, $zero, fizz_buzz_buzz # buzz will be printed

  # neither fizz or buzz, so just print the number
  add $a0, $zero, $t0
  addi $v0, $zero, 1
  syscall

  la $a0, newline
  addi $v0, $zero, 4
  syscall
  
  j fizz_buzz_loop_next
  
fizz_buzz_fizz: # print Fizz
  la $a0, fizz
  addi $v0, $zero, 4
  syscall
  j fizz_buzz_loop_next
  
fizz_buzz_buzz: # print Buzz
  la $a0, buzz
  addi $v0, $zero, 4
  syscall
  
fizz_buzz_loop_next: # move to next number
  addi $t0, $t0, 1
  j fizz_buzz_loop
  
fizz_buzz_finish:
  
  
.data 0x10010000
fizz: .asciiz "Fizz\n"
buzz: .asciiz "Buzz\n"
fizz_and_buzz: .asciiz "FizzBuzz\n"
newline: .asciiz "\n"
