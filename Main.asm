# Author: John Simpsen
# Date: 4/29/2025
# Description: Term Project - Multiplication Game

.include "SysCalls.asm"

.data
	#game board
	rowG1: .word 1, 2, 3, 4, 5, 6
	rowG2: .word 7, 8, 9, 10, 12, 14
	rowG3: .word 15, 16, 18, 20, 21, 24
	rowG4: .word 25, 27, 28, 30, 32, 35
	rowG5: .word 36, 40, 42, 45, 48, 49
	rowG6: .word 54, 56, 63, 64, 72, 81
	.globl rowG1
	
	#score board
	#0 - Empty
	#1 - Player
	#2 - Computer
	rowS1: .word 0, 0, 0, 0, 0, 0
	rowS2: .word 0, 0, 0, 0, 0, 0
	rowS3: .word 0, 0, 0, 0, 0, 0
	rowS4: .word 0, 0, 0, 0, 0, 0
	rowS5: .word 0, 0, 0, 0, 0, 0
	rowS6: .word 0, 0, 0, 0, 0, 0
	.globl rowS1
	
	newline: .asciiz "\n"
	.globl newline
	
	newgamePrompt: .asciiz "Would you like to start a new game? (y/n)\n"
	
	numberPrompt1: .asciiz "Choose a number: "
	numberPrompt2: .asciiz "Choose another number: "
	
	computerNumbers1: .asciiz "Computer chose numbers: "
	computerNumbers2: .asciiz " and "
	
	num1: .word 0
	.globl num1
	
	num2: .word 0
	.globl num2
	
	#Global Labels
	.globl ChooseNumbers
	.globl ComputerMove
	.globl Exit
	
.text

	#Print new game prompt
	la $a0, newgamePrompt #load the newgame prompt
	li $v0, SysPrintString #service call to print a string
	syscall #run system call
	
	#Read inputted character
	li $v0, SysReadChar #service call to read a String
	syscall
	move $t0, $v0 #$t0 = $v0
	
	li $t1, 'y' #load y into $t1
	bne $t0, $t1, Exit #Exit if not y
	
	#Print a newline
	la $a0, newline #load the newline
	li $v0, SysPrintString #service call to print a String
	syscall #run system call
	
	#Print newline
	la $a0, newline #load newline
	li $v0, SysPrintString #service call to print a string
	syscall #run system call
	
	
	ChooseNumbers:
		#Print number prompt #1
		la $a0, numberPrompt1 #load numberPrompt1
		li $v0, SysPrintString #service call to print a string
		syscall #run system call
		
		#Read an integer from the console
		li $v0, SysReadInt #run system call
		syscall #read the integer
		move $s0, $v0 #$t0 = $v0
		
		#Print number prompt #2
		la $a0, numberPrompt2 #load numberPrompt2
		li $v0, SysPrintString #service call to print a string
		syscall #run system call
		
		#Read an integer from the console
		li $v0, SysReadInt #run system call
		syscall #read the integer
		move $s1, $v0 #$s0 = $v0
		
		#Print newline
		la $a0, newline #load newline
		li $v0, SysPrintString #service call to print a string
		syscall #run system call
		
		la $t0, num1 #load address of num1
		la $t1, num2 #load address of num2
		
		#Call to ValidateMove
		move $a0, $s0 #Load 1st parameter
		move $a1, $s1 #Load 2nd parameter
		li $a2, 1 #load immediate 1 into $a2 to specify this call came from a player
		jal ValidateMove #Jump to ValidateMove in MoveValidation.asm
		
	PlayerMove:
		#Call to UpdateBoard
		move $a0, $s0 #Load 1st parameter
		move $a1, $s1 #Load 2nd parameter
		li $a2, 1 #load immediate 1 into $a2 to specify this call came from a player
		jal UpdateBoard #Jump to UpdateBoard in Board.asm
		
		li $a0, 1 #load immediate 1 into $a0 to specify this call came from the player's turn
		jal CheckWin #Jump to CheckWin in WinCon.asm
		
	ComputerMove:
		#Call to ComputerDecision
		jal ComputerDecision #Jump to ComputerDecision in Computer.asm
		move $s0, $v0 #$s0 = $v0 (new integer)
		move $s1, $v1 #s1 = $v1 (new integer position)
		
		beq $s1, 2 replaceSecondInt #If $s1 = 2, branch to replaceSecondInt, otherwise continue to replaceFirstInt 
		
		replaceFirstInt:
			#load previous num2 into $s1
			la $t0, num2 #load address of num2
			lw $s1, 0($t0) #load contents of num1 into $s1
			
			j end1 #jump to end1
			
		replaceSecondInt:
			#replace second intefer with the new one
			move $s1, $s0 #s1 = $s0
			
			#load previous num1 into $s0
			la $t0, num1 #load address of num2
			lw $s0, 0($t0) #load contents of num1 into $s1
		
		end1:
			#Call to ValidateMove
			move $a0, $s0 #Load 1st parameter
			move $a1, $s1 #Load 2nd parameter
			li $a2, 2 #load immediate 2 into $a2 to specify this call came from the computer
			jal ValidateMove #Jump to ValidateMove in MoveValidation.asm
			
			#Call to UpdateBoard
			move $a0, $s0 #Load 1st parameter
			move $a1, $s1 #Load 2nd parameter
			li $a2, 2 #load immediate 2 into $a2 to specify this call came from the computer
			jal UpdateBoard #Jump to UpdateBoard in Board.asm
		
		#Display Computer Decision
		#Print computerNumbers1
		la $a0, computerNumbers1 #load computerNumbers1
		li $v0, SysPrintString #service call to print a string
		syscall #run system call
		
		#Print the first integer
		move $a0, $s0 #$a0 = $s0
		li $v0, SysPrintInt #service call to print an integer
		syscall #run system call
		
		#Print computerNumbers2
		la $a0, computerNumbers2 #load computerNumbers2
		li $v0, SysPrintString #service call to print a string
		syscall #run system call
		
		#Print the second integer
		move $a0, $s1 #$a0 = $s1
		li $v0, SysPrintInt #service call to print an integer
		syscall #run system call
		
		#Print newline
		la $a0, newline #load newline
		li $v0, SysPrintString #service call to print a string
		syscall #run system call
		
		#Print newline
		la $a0, newline #load newline
		li $v0, SysPrintString #service call to print a string
		syscall #run system call
		
		jal DrawBoard #Jump to DrawBoard in Board.asm
		
		li $a0, 2 #load immediate 2 into $a0 to specify this call came from the computer's turn
		jal CheckWin #Jump to CheckWin in WinCon.asm
	
		#End Computer's turn
		j ChooseNumbers #Jump to ChooseNumbers for player's turn
	
	
	Exit:
		#End Program
		li $v0, SysExit
		syscall
		
