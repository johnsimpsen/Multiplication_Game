# Author: John Simpsen
# Date: 4/29/2025
# Description: Calculate the computer's move

.include "SysCalls.asm"

.data
	#Global labels
	.globl ComputerDecision

.text

	#No parameters
	ComputerDecision:
    		#Generate a random number (1-9)
    		li $a1, 9 #load upperbound into $a1 (9)
    		li $v0, SysRandomInt #generates the random number
    		syscall #run system call
    		add $a0, $a0, 1  #Add the lowest bound (1)
    		move $s0, $a0 #$s0 = $a0
    		
    		#Generate a second random number (1-2)
    		li $a1, 2 #load upperbound into $a1 (2)
    		li $v0, SysRandomInt #generates the random number
    		syscall #run system call
    		add $a0, $a0, 1  #Here you add the lowest bound (1)
    		move $s1, $a0 #$s1 = $a0
    		
    		move $v0, $s0 #First return value (new integer to use)
    		move $v1, $s1 #Second return value (which value to replace
    			
    		jr $ra #Jump back to the return address in Main.asm
