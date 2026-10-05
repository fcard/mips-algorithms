.text
.include "macros.inc"

game.main:
  jal game.main_menu
  bne $v0, $zero, game.start
  j game.exit
  
game.start:
  jal game.starting_hand
  jal game.main_loop

game.main_menu:
  print_string(strings.game_header)
  print_string(strings.select_option)
  print_string(strings.start_game)
  print_string(strings.exit_game)
game.main_menu.input_loop:
  read_integer($t0)
  beq $t0, 1, game.main_menu.start
  beq $t0, 2, game.main_menu.exit
  print_string(strings.invalid_option)
  j game.main_menu.input_loop
game.main_menu.start:
  li $v0, 1
  jr $ra
game.main_menu.exit:
  li $v0, 0
  jr $ra
      
game.starting_hand:
  call(game.draw_card)
  call(game.draw_card)
  jr $ra
  

game.main_loop:
  lw $t0, player.hand
  beq $t0, 21, game.main_loop.victory
  slti $t1, $t0, 21
  beq $t1, $zero, game.main_loop.bust

  print_string(strings.select_option)
  print_string(strings.hit)
  print_string(strings.stand)

game.main_loop.input_loop:
  read_integer($t0)
  beq $t0, 1, game.main_loop.hit
  beq $t0, 2, game.main_loop.stand
  print_string(strings.invalid_option)
  j game.main_loop.input_loop

game.main_loop.hit:
  call(game.draw_card)
  j game.main_loop
  
game.main_loop.stand:
  lw $t0, player.hand
  random_integer($t1, 11, 21)
  print_string(strings.dealers_hand)
  println_register($t1)
  slt $t2, $t1, $t0
  bne $t2, $zero, game.main_loop.victory

game.main_loop.lose:
  print_string(strings.lost)
  j game.exit

game.main_loop.victory:
  print_string(strings.won)
  j game.exit

game.main_loop.bust:
  print_string(strings.bust)
  j game.exit
  
game.draw_card:
  random_integer($t0, 1, 13)
  bne $t0, 1, game.draw_card.not_ace
  print_string(strings.got_ace)
  print_string(strings.ace_as_one)
  print_string(strings.ace_as_eleven)

game.draw_card.input_loop:
  read_integer($t0)
  beq $t0, 1, game.draw_card.ace_as_one
  beq $t0, 2, game.draw_card.ace_as_eleven
  print_string(strings.invalid_option)
  j game.draw_card.input_loop
  
game.draw_card.ace_as_one:
  lw $t0, player.hand
  addi $t0, $t0, 1
  sw $t0, player.hand
  return
  
game.draw_card.ace_as_eleven:
  lw $t0, player.hand
  addi $t0, $t0, 11
  sw $t0, player.hand
  return

game.draw_card.not_ace:
  li $t1, 10
  slt $t1, $t1, $t0
  beq $t1, $zero, game.draw_card.number_card
  li $t0, 10

game.draw_card.number_card:
  print_string(strings.you_drew)
  println_register($t0)
  lw $t1, player.hand
  add $t1, $t1, $t0
  sw $t1, player.hand
  return

game.exit:
  li $v0, 10
  syscall
  
.data
player:
player.hand: .word 0

dealer:
dealer.hand: .word 0

strings:
strings.newline:        .asciiz "\n"
strings.game_header:    .asciiz "   #--- BLACK JACK ---#   \n\n"
strings.select_option:  .asciiz "Select your option:\n\n"
strings.invalid_option: .asciiz "Invalid option.\n"
strings.start_game:     .asciiz "1. Begin Game\n"
strings.exit_game:      .asciiz "2. Exit\n"
strings.your_hand:      .asciiz "Your initial hand is:\n"
strings.got_ace:        .asciiz "You drew an ace, do you want to use it as 1 or 11?\n\n"
strings.ace_as_one:     .asciiz "1. as 1\n"
strings.ace_as_eleven:  .asciiz "2. as 11\n"
strings.hit:            .asciiz "1. hit\n"
strings.stand:          .asciiz "2. stand\n"
strings.lost:           .asciiz "You lost...\n"
strings.won:            .asciiz "You won!!\n"
strings.bust:           .asciiz "You went above 21. You lost...\n"
strings.dealers_hand:   .asciiz "The dealer's hand is: "
strings.you_drew:       .asciiz "You drew "
