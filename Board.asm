# Author: John Simpsen
# Date: 4/29/2025
# Description: Displays and updates the game board

.include "SysCalls.asm"

.data

	space: .asciiz " " #space for seperating numbers

	#Global Labels
	.globl UpdateBoard
	.globl DrawBoard

.text

	#a0 - new first number
	#a1 - new second number
	#a2 - player or computer input (1 - player, 2 - computer)
	UpdateBoard:
		#determine the requested position on the board
		mul $t0, $a0, $a1 #$t0 = $a0 * $a1
		
		la $t1, rowG1 #load address of Row1 of the Game Board
		li $t3, 0 #initialize the index of the Game Board
		
		loop1:
			lw $t2, 0($t1) #Load the current number of the Game Board
			beq $t2, $t0, exit1 #Branch to exit1 if $t2 == $t0
			
			addi $t1, $t1, 4 #Increment $t1 by 4
			addi $t3, $t3, 1 #Increment $t3 by 1 (offset from the beginning of the Game Board)
			j loop1 #jump back to loop1
			
		exit1:
			la $t1, rowS1 #load address of Row1 of the Score Board
			
			#determine the offset from the beginning of the Score Board
			mul $t3, $t3, 4 #$t3 = $t3 * 4
			add $t1, $t1, $t3 #$t1 = $t1 + $t3
			
			lw $t0, 0($t1) #load contents of rowS1 + offset
			
			#check if the player or computer has already played in this position
			bne $t0, $zero, FinishTurn #Branch to FinishTurn if $t0 != 0 (someone has taken this position)
			
			sw $a2, 0($t1) #Save who played in the chosen position of the Score Board
			
		FinishTurn:
	
			jr $ra #Jump back to the return address in Main.asm
	
	#No parameters
	DrawBoard:
		la $t0, rowS1 #load address of Row1 of the Score Board
		li $t1, 1 #initialize the index of the Score Board
		li $t2, 6 #initialize num of the rows (6)
		
		loop2:
		
			beq $t1, 37, exit2 #Branch to exit2 if $t1 = 37 (end of the score board)
			
			div $t1, $t2 #$t1 / 6
			mfhi $t3 #$t1 = hi (remainder)
			
			lw $t4, 0($t0) #load the current number of the Score Board
			
			#Print the integer
			move $a0, $t4 #$a0 = $t4
			li $v0, SysPrintInt #service call to print an integer
			syscall #run system call
			
			#Print a space
			la $a0, space #load the space
			li $v0, SysPrintString #service call to print a string
			syscall #run system call
			
			beq $t1, 0, nextint   # If t1 == 0, don't print newline
			bne $t3, 0, nextint #Branch to nextint if $t3 != 0
				
			newrow:
				#Print a newline if at the end of the row
				la $a0, newline #load the newline
				li $v0, SysPrintString #service call to print a String
				syscall #run system call
				
			nextint:
			
				addi $t0, $t0, 4 #increment $t0 by 4
				addi $t1, $t1, 1 ##Increment $t1 by 1 (offset from the beginning of the Score Board)
			
				j loop2 #jump back to loop2
		
		exit2:
		
			#Print a newline
			la $a0, newline #load the newline
			li $v0, SysPrintString #service call to print a String
			syscall #run system call
			
			jr $ra #jump back to return address in Main.asm
