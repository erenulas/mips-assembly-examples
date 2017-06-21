			.data 0x10000000
msg1:		.asciiz "Please enter your choice to skip number (1-4): "
msg2:		.asciiz "Sum of numbers: "
numbers:	.byte 100, -7, 11, 25, -66, 99, -1, 34, 12, 22, -2, -7, 100, 11, 4, 67, 2, -90, 22, 2, 56, 3, -89, 12, -10, 21, 10, -25, -6, 9, 111, 34, 12, 22, -2, -17, 100, 111, -4, 7, 14, -19, -2, 29, 36, 31, -79, 2
			.text
			.globl main
			
main:		############### gets user choice ##########

			li $v0, 4			#	prints message to console
			la $a0, msg1
			syscall
			
			li $v0, 5			#	gets user input
			syscall
			
			add $t0, $v0, $0		#	puts user input into t0
			
			################ initializations #############################
			
			add $t3, $0, $0		#	t3 will be used as index so initializes it to 0
			add $t5, $0, $0		#	t5 will kept the sum, and is initialized to 0
			la $t6, numbers		#	puts the beginning address of numbers into t6
			add $t7, $0, $0		#	t7 will kept the length of numbers array
			
			############ finds the length of numbers #####################
			
findlength: add $t4, $t3, $t6		#	gets an element from array
			lb $t4, 0($t4)
			beq $0, $t4, found	#	checks if it is the end of array
			addi $t7,$t7, 1		#	increases length and index by 1
			add $t3, $t3, 1
			j findlength		
			
			###########	sets increment according to user input #################
			
found:		add $t3, $0, $0
			addi $t1, $0, 1
			bne $t1, $t0, else2	#	if choice is 1
			addi $t2, $0, 1
			j loop
			
else2:		addi $t1, $0, 2
			bne $t1, $t0, else3	#	if choice is 2
			addi $t2, $0, 2
			j loop
			
else3:		addi $t1, $0, 3
			bne $t1, $t0, else4	#	if choice is 3
			addi $t2, $0, 3
			j loop
			
else4:		addi $t1, $0, 4
			bne $t1, $t0, else	#	if choice is 4
			addi $t2, $0, 4
			j loop

else:		j main				#	if it is not 1,2,3,4 asks for new input

			############# loop for finding the sum of n numbers ##################

loop:		slt $t1, $t3, $t7		#	checks if index is lower than the length
			beq $t1, $0, exit
			add $t4, $t3, $t6		#	gets the element and checks if it is the end
			lb $t4, 0($t4)
			beq $0, $t4, exit
			
			add $t5, $t5, $t4		#	adds the integer to t5
			add $t3, $t3, $t2		#	increases index by t2(user's choice)
			j loop
			
exit:		li $v0, 4			#	prints msg2 to console
			la $a0, msg2
			syscall
			
			add $a0, $t5, $0		#	prints the sum to console
			li $v0, 1
			syscall
			jr $ra
			