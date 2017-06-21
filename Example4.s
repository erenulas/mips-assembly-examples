			.data 0x10000000
msg1:		.asciiz "Enter length of array: "
msg2:		.asciiz "Enter array element "
msg2_2:		.asciiz ": "
			.text
			.globl main
			
			################ get length of array ###################
			
main:		li $v0, 4			#	print msg1
			la $a0, msg1
			syscall
			
			li $v0, 5			#	read integer
			syscall
			
			addu $t1, $v0, $0	#	t1 holds the length
			
			################ space allocation ####################
			
			sll $t2, $t1, 2		#	save some space on stack
			sub $t2, $0, $t2
			add $sp, $sp, $t2
			add $t0, $0, $sp		#	t0 holds the start address
			
			################ get array element inputs ############
			
			addu $t2, $0, $0		#	loop index to zero
			
loop:		slt $t3, $t2, $t1		#	loop condition, compares index with array length
			beq $t3, $0, loopend
			
			li $v0, 4			#	shows message to enter array element
			la $a0, msg2
			syscall
			
			li $v0, 1			#	puts index number into prompt message
			add $a0, $0, $t2
			syscall
			
			li $v0, 4
			la $a0, msg2_2
			syscall
			
			li $v0, 5			#	gets array element input
			syscall
			
			sll $t4,$t2,2		#	put the input into stack
			add $t4, $sp, $t4
			sw $v0, 0($t4)
			
			addi $t2, $t2, 1		#	increases index by 1
			j loop			
					
loopend:	add $a0, $0, $0		#	initializations for height function
			add $a1, $t0, $0
			add $v0, $0, $0
			add $t3, $0, $0
			addi $sp, $sp, -4	#	saves ra into stack before starting to execute height
			sw $ra, 0($sp)
			jal height			#	jumps to height
			lw $ra, 0($sp)		#	loads ra from stack
			addi $sp, $sp, 4
			add $t2, $v0, $0		#	t2 holds the result
			add $a0, $t2, $0		#	prints the height of tree 
			li $v0, 1
			syscall
			jr $ra
			
			#################### find height ###########################
			
height:		addi $sp, $sp, -4	#	saves ra
			sw $ra, 0($sp)
			
			addi $t4, $0, -1		#	compares the array element with -1
			bne $a0, $t4, L1		#	if it is not -1, program jumps to L1
			
			add $v0, $0, $0		#	returns 0, when element is -1
			addi $sp, $sp, 4
			jr $ra	

			
L1:			addi $sp, $sp, -4	#	saves previous value of a0 into stack
			sw $a0, 0($sp)
			addi $a0, $a0, 1		#	finds the left child
			sll $a0, $a0, 2
			add $a0, $a0, $a1
			lw $a0, 0($a0)		
			jal height			#	jumps to height with the new child
			lw $a0, 0($sp)		#	restores the previous value of a0 from stack
			addi $sp, $sp, 4
			
			add $t5, $v0, $0		#	puts the return value to t5 which is the height of left part 
			addi $sp, $sp, -4	#	saves this t5 value into stack
			sw $t5, 0($sp)
			
			addi $sp, $sp, -4	#	saves the value of a0 into stack
			sw $a0, 0($sp)
			addi $a0, $a0, 2		#	finds the right dhild
			sll $a0, $a0, 2
			add $a0, $a0, $a1
			lw $a0, 0($a0)
			jal height			#	jumps to height with the new child
			lw $a0, 0($sp)		#	restores the previous value of a0
			addi $sp, $sp,4
			
			add $t6, $v0, $0		#	puts the return value into t6
			
			lw $t5, 0($sp)		#	loads the saved value of t5 from stack
			addi $sp, $sp, 4
			
			slt $t7, $t6, $t5		#	compares t5 with t6, and largest one is increased by 1, and is returned
			beq $t7, $0, else
			
			addi $v0, $t5, 1
			j return
			
else:		addi $v0, $t6, 1
			
return:
			lw $ra, 0($sp)		#	restores the value of ra
			addi $sp, $sp, 4
			jr $ra
			

		