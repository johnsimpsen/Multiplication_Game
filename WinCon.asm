# Author: John Simpsen
# Date: 4/29/2025
# Description: Checks if the game has been won by the player or computer

.include "SysCalls.asm"

.data

	playerWinPrompt: .asciiz "You win!\n"
	playerLosePrompt: .asciiz "You lose!\n"

	#Global labels
	.globl CheckWin
.text

	#a0 - Player or Computer win (1 or 2)
	CheckWin:
	
		#Find row and column of the last move
		la $t0, rowG1 #load address of Row1 of the Game Board
		li $t1, 0 #initialize the index of the Game Board
		li $t2, 6 #initialize num of the rows (6)
		
		mul $t3, $s0, $s1 #$t3 = $s0 * $s1 (the number on the Game Board being looked for)
		
		loop1:
			#beq $t1, 6, exit1 #Branch to exit1 if $t1 = 36 (end of the game board)
			
			lw $t4, 0($t0) #load the current number of the Game Board
			beq $t3, $t4, exit1 #Branch to exit1 if $t3 = $t4 (number has been found)
			
			addi $t0, $t0, 4 #increment $t0 by 4
			addi $t1, $t1, 1 #increment $t1 by 1
			
			j loop1 #jump back to loop1
		
		exit1:
			
			#Get the address + offset of the current row and column
			div $t1, $t2 #$t1 / 6 
			mflo $t2 #$t2 = lo(row index)
			mfhi $t4 #$t4 = hi (column index)
			
			la $t1, rowS1 #load address of Row1 of the score board
			move $t3, $t1 #$t3 = $t1
			
			mul $t2, $t2, 24 #$t3 = $t2 * 24 (offset to current row from beginning of board)
			add $t3, $t2, $t3 #$t2 = $t2 + $t3 (address to the beginning of the row)
			
			mul $t4, $t4, 4 #$t4 = $t4 * 4
			#add $t4, $t4, 4 #$t4 = $t4 + 4
			add $t4, $t4, $t1 #$t4 = $t4 + $t1 (address to the beginning of the column)
			
			li $t5, 4 #initialize how to index for rows
			
		CheckCurrRowAndCol:	
			li $t1, 0 #initialize num of consecutive points
			li $t2, 0 #initialize num of times looped
			
			loop2:
				beq $t2, 6, exit2 #branch to exit2 if $t2 == 6
				
				#Check each number of the current row for a 4 in a row
				lw $t0, 0($t3) #load the current number of the Score Board
				
				bne $t0, $a0, miss #branch to miss if $t0 != $a0 (player or computer has a point)
				
				match:
					add $t1, $t1, 1 #increment $t1 by 1
					beq $t1, 4, GameEnd #branch to GameEnd if $t1 = 4
					
					j end #jump to end
					
				miss:
					li $t1, 0 #reset $t1 to 0 (streak was broken)
					
				end:
				
				addi $t2, $t2, 1 #increment $t1 by 1
				add $t3, $t3, $t5 #$t3 = $t3 + $t5 ($t5 is 4, then 24)
				
				j loop2 #jump to loop2
				
			exit2:
				beq $t5, 24, EndCheck #branch if $t5 == 24 (second time through the function)
				
				#Set up the loop
				li $t5, 24 #initialize how to index for columns
				move $t3, $t4 #$t3 = $t4 (set new address to load from)
				
				j CheckCurrRowAndCol #Jump back to CheckCurrRowAndCol (2nd time)
		EndCheck:
			#Nobody won on this turn
			jr $ra #jump back to return address in Main.asm
			
			
	GameEnd:
	
		beq $a0, 2, playerlose #branch to playerlose if $a0 == 2 (computer wins) otherwise continue to playerwin
		
		playerwin:
			#Print playerWinPrompt
			la $a0, playerWinPrompt #load the player win prompt
			li $v0, SysPrintString #service call to print a string
			syscall #run system call
			
			j Exit #jump to Exit to end the program
		
		playerlose:
			#Print playerLosePrompt
			la $a0, playerLosePrompt #load the player lose prompt
			li $v0, SysPrintString #service call to print a string
			syscall #run system call
			
			j Exit #jump to Exit to end the program
				
			
			
