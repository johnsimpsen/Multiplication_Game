# Author: John Simpsen
# Date: 4/29/2025
# Description: Determines if moves made are valid or not

.include "SysCalls.asm"

.data

	invalidPrompt: .asciiz "Invalid Input, please try again!\n"

	#Global Labels
	.globl ValidateMove

.text

	#a0 - new first number
	#a1 - new second number
	#a2 - Player move or Computer move (1 or 2)
	ValidateMove:
		#Load num1
		la $t0, num1 #load address of num1
		lw $t2, 0($t0) #load contents of num1 into $t2
		
		#Load num2
		la $t1, num2 #load address of num2
		lw $t3, 0($t1) #load contents of num2 into $t4
		
		CheckRange:
			#check if the 2nd inputted number is 0 < num < 10
			sgt $t5, $a0, 0 #$t5 = 1 if $a0 > 0, else $t5 = 0
			slti $t6, $a0, 10 #$t6 = 1, if $a0 < 10, else $t6 = 0
			and $t5, $t5, $t6 #$t5 = 1 if $t5 & $t6 are both 1, else $t5 = 0
		
			#check if the 2nd inputted number is 0 < num < 10
			sgt $t6, $a1, 0 #$t6 = 1 if $a1 > 0, else $t6 = 0
			slti $t7, $a1, 10 #$t7 = 1, if $a1 < 10, else $t7 = 0
			and $t6, $t6, $t7 #$t6 = 1 if $t5 & $t6 are both 1, else $t6 = 0
		
			#check if both numbers are not 0 < nums < 10
			and $t5, $t5, $t6 #$t5 = 1 if $t5 & $t6 are both 1, else $t5 = 0
			beq $t5, $zero, InvalidInput #Branch to InvalidInput if $t5 == 0
		
		CheckFirstMove:
			#check if existing numbers are 0 (first move so both numbers may be chosen)
			seq $t4, $t2, $zero #$t4 = 1 if $t2 == 0, else $t4 = 0
			seq $s5, $t3, $zero #$t5 = 1 if $t3 == 0, else $t5 = 0
			and $t5, $t4, $t5 #$t5 = 1 if $t4 & $t5 are both 1, else $t5 = 0
			beq $t5, 1, ValidInput #Branch to ValidInput if $t5 == 1
		
		
		#check if one number has changed and the other has not
		seq $t4, $a0, $t2 #$t4 = 1 if $a0 == $t2, else $t4 = 0
		seq $t5, $a1, $t3 #$t5 = 1 if $a1 == $t3, else $t5 = 0
		xor $t5, $t4, $t5 #t5 = 1 if $t4 == 1 || $t5 == 1 and $t4 != $t5, else $t5 = 0
		beq $t5, $zero, InvalidInput #Branch to InvalidInput if $t5 == 0
		
		ValidInput:
			#save the numbers back into memory
			sw $a0, 0($t0) #store $t2 to num1
			sw $a1, 0($t1) #store $t4 to num2
		
			jr $ra #Jump back to the return address in Main.asm
		
		InvalidInput:
			beq $a2, 2 computer #Branch to computer if $a2 = 2, otherwise continue to player
		
			player:
				#Print number prompt #1
				la $a0, invalidPrompt #load invalidPrompt
				li $v0, SysPrintString #service call to print a string
				syscall #run system call
			
				j ChooseNumbers #Jump back to ChooseNumbers in Main.asm
			
			computer:
			
				j ComputerMove #Jump back to ComputerMove in Main.asm (redo the computer's move)
