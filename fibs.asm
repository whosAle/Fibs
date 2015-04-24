#
#	fibs.asm
#	Author: Alejandro Belgrave
#	
#	An assembly language program which computers a sequence of
#	fibonacci numbers and displays it.The input is three integer
#	values descirbing the first number, second number, and the 
#	number elements in the sequence. The output displays each 
#	element's number in decimal notation, hexidecimal notation,
#	and the number of bits in the binary represeentation using
#	the Brian Kernighan algorithm
#

	.data
first:	.word 0
second:	.word 0
n:	.word 0

current:.word 0
setbits:.word 0
tab:	.asciiz  "\t"
nl:	.asciiz  "\n"

pr1:	.asciiz	"Please enter the first number in the sequence: "
pr2:	.asciiz "Please enter the second number in the sequence: "
pr3:	.asciiz "Please enter the number of elements of the sequence: "


	.text
main:

# read the input values

#first value
	li      $v0, 4
	la      $a0, pr1
	syscall			# display prompt for first value
	li      $v0, 5
	syscall			# get value from keyboard
	sw	$v0, first	# and store it in first
	
#second value
	li      $v0, 4
	la      $a0, pr2	# load prompt to register
	syscall			# display prompt for second value
	li      $v0, 5
	syscall			# get value from keyboard
	sw	$v0, second	# and store it in second
	
#number of elements
	li      $v0, 4
	la      $a0, pr3
	syscall			# display prompt for n
	li      $v0, 5
	syscall			# get value from keyboard
	sw	$v0, n		# and store it in n
	
	
#
# Do Fib Arithmatic
#
	lw	$t1, first	# t1 <--- first input value
	jal	Print		# prints first input value
	
	lw	$t0, first	# t0 <--- previous value
	lw	$t1, second	# t1 <--- current value
	jal	Print		# prints second input value
	
	lw	$s1, n		# s1 <--- the number of elements
	sub	$s1, $s1, 2	# subtracts the first two elements from the total amount

	add	$s0, $zero, $zero	#index for the for loop
	
Loop:	beq	$s0, $s1, End	#checks to see if i < n
	add	$t2, $t1, $zero	# t2 <---- stores the current value
	add	$t1, $t1, $t0	# adds the current and previous values
	add	$t0, $t2, $zero # set the previous value to the current value
	
	addi	$s0, $s0, 1	# increments the counter
	jal	Print		# runs print procedure before finishing loop
	j	Loop		# jumps back to beginning of loop
	
#
# Print Procedure for the output.
#
	
Print:	sw $t1, current		# stores current value to current variable
	li $v0, 1		# loads system call to print integer
	lw $a0, current		# loads value into address register
	syscall			# prints the digit as a decimal
	
	li      $v0, 4		# load system call to print tab
	la      $a0, tab
	syscall			# add a tabs worth of whitespace
	
	li $v0, 34		# loads system call to print hex
	lw $a0, current
	syscall			# prints the digit as a hexidecimal number
	
	li      $v0, 4		# load system call to print tab
	la      $a0, tab
	syscall			# add another tabs worth of whitespace
	
#
# Count Set Bits and Print
#
	add $s2, $zero, $zero	# counter for total set bits
	lw  $t3, current	# t3 <--- n value
setL:	beq $t3, $zero, printSB # checks to see if the number
	subi $t4, $t3, 1	# subtracts t3 by 1 
	and $t3, $t3, $t4	# performs action n&(n-1) to unset the rightmost bit and stores it in t3
	addi $s2, $s2, 1	# increment counter
	
	j setL
	
printSB:sw $s2, setbits		# store bit count into label
	lw $a0, setbits		# loads set bit count into register
	li $v0, 1
	syscall			# prints the digit as a decimal number
	
	li      $v0, 4		# load system call to print new line
	la      $a0, nl
	syscall			# prints a new line to separate sequence
	
	jr $ra
	
End:	li      $v0, 10		# load system call to exit program
	syscall			# exit program
