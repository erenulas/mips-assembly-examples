			.data 0x10000000
alp:		.byte ' ','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'
msg1:		.asciiz "Enter length of array: "
msg2:		.asciiz "Enter an array element "
msg2_2:		.asciiz ": "
			.text
			.globl main
			
			
			
main:		##################### get length of array #########################

			li $v0, 4				#	print enter length of arr
			la $a0, msg1
			syscall
			
			li $v0, 5				#	reads integer input
			syscall
			
			addu $t1, $v0, $0			#	move integer to t1
			
			##################### space allocation ############################
			
			sub $t2, $0, $t1			#	allocates some space in stack
			add $sp, $sp, $t2
			add $t0, $0, $sp
			
			##################### loop section ################################
			
			addu $t2, $0, $0			#	initializes loop index to 0
			
loop:		slt $t3, $t2, $t1			#	compares index with array length
			beq $t3, $0, loop2_init
			
			li $v0, 4				#	prints enter array element string
			la $a0, msg2
			syscall
			
			li $v0, 1
			add $a0, $0, $t2
			syscall
			
			li $v0, 4
			la $a0, msg2_2
			syscall
			
			li $v0, 5				#	reads integer input	
			syscall
			
			add $t4, $t0, $t2			#	finds the address to put input into
			addi $t2, $t2, 1			#	increases index by 1
			sb $v0, 0($t4)			#	puts integer input into stack
			j loop

			##################### finds corresponding letter ##################
			
loop2_init:	addu $t2, $0, $0			#	initializes index to 0

loop2:		slt $t3, $t2, $t1			#	compares index with array length
			beq $t3, $0, exit
			
			add $t4, $t0, $t2			#	gets the ith integer
			lb $t3, 0($t4)			#
			
			addi $t2, $t2, 1			#	increases index by 1
			
			addi $t7, $0, -1			#	puts -1 into t7
			slt $t5, $t7, $t3			#	compares ith integer with -1
			slti $t6, $t3, 28			#	compares ith integer with 28
			and $t5, $t5, $t6			#	ands them to be sure that integer are in range
			beq $t5, $0, loop2		#	if not in range goes to loop2
			
			la $t6, alp				#	loads the corresponding letter from alp
			add $t6, $t3, $t6
			lb $a0, 0($t6)
			
			li $v0, 11				#	prints the corresponding letter
			syscall
			j loop2					
			
exit:		jr $ra
			
			