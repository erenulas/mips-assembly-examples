			.data 0x10000000
msg1:		.asciiz "Enter an input string (max 20 chars): "
msg2:		.asciiz "Enter an input char: "
msg3:		.asciiz "The number of "
newLine:	.asciiz "\n"
msg3_2:		.asciiz " in "
msg3_3:		.asciiz " is "
buffer:		.space 21
			.text
			.globl main
			
			
			
main:		##################### get input string from user #########################

			li $v0, 4				#	print enter input string
			la $a0, msg1
			syscall
			
			li $v0, 8				#	gets input string
			la $a0, buffer	
			li $a1, 21
			syscall
			
			addu $t3, $a0, $0  		#	now t3 has the string
			
			la $a0, newLine			#	prints a new line
			addi $v0, $0, 4
			syscall
			
			##################### get input char from user ###########################
			
			li $v0, 4		 		#	print enter char 
			la $a0, msg2
			syscall
			
			
			li $v0, 12				#	get char input
			syscall
			
			addu $t4, $v0, $0			#	t4 has the input char
			
			la $a0, newLine			#	prints a new line
			addi $v0, $0, 4
			syscall

			
			addu $t0, $0, $0			#	make t0 zero which will be the count
									
			addu $t1, $0, $0			# 	make t1 zero which is the index for loop
			
			##################### loop for counting number of char ###################
			
loop:		slt $t5, $t1, $a1			# 	compares index of loop with the max. length
			beq $t5, $0, exit			
			
			add $t7, $t3, $t1			#	move the address of ith element to t7
			
			lb $t6, 0($t7)			#	loads that element into t6
			
			beq $t4,$t6, matched		# 	checks if the ith element is same as input char
				
			addi $t1, $t1, 1			#	increases the index by 1
			j loop
			
matched:	addi $t0, $t0, 1			#	increases the count and index by 1 if matched
			addi $t1, $t1, 1			#	increases index by 1
			j loop
			
			##################### prints the result ##################################
			
exit:		##################### removes the new line element at the end of the input string
			
			li $t6, '\n'				#	moves new line character to t6 for comparison
			addu $t1, $0, $0			#	makes t1 zero
			addi $t1, $t1, -1
									#	loop for removing /n from string
remove:		slt $t5, $t1, $a1			#	continues until t1 is lower than max. length
			beq $t5, $0, removeend
			addi $t1, $t1, 1			#	increases index by 1
			lb $t7, buffer($t1)		#	loads ith character to t7
			bne $t7, $t6, remove		#	compare it with /n element
			li $t6, 0				#	makes t6 zero
			sb $t6, buffer($t1)		#	replaces /n in string with zero
removeend:

			##################### prints the results #################################
			
			#### prints new line
			la $a0, newLine
			addi $v0, $0, 4
			syscall
			
			### prints msg3 text
			li $v0, 4
			la $a0, msg3
			syscall
			
			### prints input char
			li $v0, 11
			addu $a0, $t4, $0
			syscall
			
			### prints msg3_2 text
			li $v0, 4
			la $a0, msg3_2
			syscall
			
			### prints input string
			li $v0, 4
			addu $a0, $t3, $0
			syscall
			
			### prints msg3_3 text
			li $v0, 4
			la $a0, msg3_3
			syscall
			
			### prints the count 
			li $v0, 1			 
			addu $a0, $t0, $0
			syscall
			jr $ra