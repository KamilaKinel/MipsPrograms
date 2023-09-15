###########################################################################
#  Name: Kamila Kinel 
#  NSHE ID: 5005951543
#  Section: 1003 & 1004
#  Assignment: MIPS #5
#  Description: Mips assembly language program that counts the number 
#				that change can made given US monetary denominations.
#				Program uses recursion.

#  Provided template

##########################################################################
#  data segment

.data

# -----
#  Constants

TRUE = 1
FALSE = 0

# -----
#  Variables for main
hdr:		.ascii	"\n**********************************************\n"
		.ascii	"MIPS Assignment #5\n"
		.asciiz	"Ways to Make Change Program\n"

endMsg:		.ascii	"\nYou have reached recursive nirvana.\n"
		.asciiz	"Program Terminated.\n"

amountMinimum:	.word	1		# $0.01 dollars or 1 cent
amountMaximum:	.word	500		# $10.00 dollars or 1000 cents
initialAmount:	.word	0
waysCount:	.word	0
errorLimit:	.word	3		# 3 errors allowed, 4th error exits

coins:		.word	500, 100, 50, 25, 10, 5, 1
coinsCount:	.word	7

# -----
#  Variables for showWays() function.

cntMsg1:	.asciiz	"\nFor an amount of $"
cntDot:		.asciiz	"."
cntMsg2:	.asciiz	", there are "
cntMsg3:	.asciiz	" ways to make change.\n"

# -----
#  Variables for readInitAmt() function.

amtPmt1:	.asciiz	"  Enter Amount ("
amtPmt2:	.asciiz	" - "
amtPmt3:	.asciiz	"): "

err1:		.ascii	"\nError, amount out of range. \n"
		.asciiz	"Please re-enter data.\n"

err2:		.ascii	"\nSorry your having problems.\n"
		.asciiz	"Please try again later.\n"

spc:		.asciiz	"   "

# -----
#  Variables for prtNewline function.

newLine:	.asciiz	"\n"


# -----
#  Variables for makeChange() function.


# -----
#  Variables for continue.

qPmt:		.asciiz	"\nTry another amount (y/n)? "
ansErr:		.asciiz	"Error, must answer with (y/n)."

ans:		.space	3


#####################################################################
#  text/code segment

.text

.globl main
.ent main
main:

# -----
#  Display program header.

	la	$a0, hdr
	li	$v0, 4
	syscall					# print header

# -----
#  Function to read and amount (1-AMT_MAX).

doAnother:
	sw	$zero, initialAmount		# re-set variables
	sw	$zero, waysCount

	lw	$a0, amountMinimum		# min
	lw	$a1, amountMaximum		# max
	lw	$a2, errorLimit			# allowed errors
	la	$a3, initialAmount
	jal	readInitAmt

	bne	$v0, TRUE, programDone		# if not TRUE, exit

# -----
#  call makeChange to determine how many ways change could be made.
#	Returns integer answer.
#	HLL Call:
#		waysCount = makeChange(denomCount, initialAmount)

	la	$a0, coins
	lw	$a1, coinsCount
	lw	$a2, initialAmount
	jal	makeChange

	sw	$v0, waysCount

# ----
#  Display results (formatted).

	lw	$a0, initialAmount
	lw	$a1, waysCount
	jal	showWays

# -----
#  See if user wants to do another?

	jal	continue
	beq	$v0, TRUE, doAnother

programDone:
	li	$v0, 4
	la	$a0, endMsg
	syscall

# -----
#  Done, terminate program.

	li	$v0, 10
	syscall					# all done...
.end main

# =================================================================
#  Very simple function to print a new line.
#	Note, this routine is optional.

.globl	prtNewline
.ent	prtNewline
prtNewline:
	la	$a0, newLine
	li	$v0, 4
	syscall

	jr	$ra
.end	prtNewline

# =================================================================
#  Function to print final result (formatted).

#  Formatted message:
#    For an amount of $xx.yy, there are zz ways to make change.

# -----
#  Arguments
#	$a0 - initial amount
#	$a1 - ways to make change


.globl	showWays
.ent	showWays
showWays:

	move    $t0, $a0
	move    $t1, $a1

	# prints newline
	la  	$a0, newLine
	li	    $v0, 4
	syscall

	# "For an amount of $"
	la	    $a0, cntMsg1
	li	    $v0, 4
	syscall

	divu    $t2, $t0, 100
	remu    $t3, $t0, 100

	move    $a0, $t2
	li 		$v0, 1 		      
	syscall

	# print dots
	la	    $a0, cntDot
	li      $v0, 4
	syscall

	# 
	bge     $t3, 10, NoneZero

	li      $t4, 0
	move    $a0, $t4
	li      $v0, 1 		      
	syscall

	NoneZero:
		move   $a0, $t3
		li     $v0, 1 		      
		syscall

	# "There are"
	la	   $a0, cntMsg2
	li	   $v0, 4
	syscall

	# print make change
	move   $a0, $t1
	li     $v0, 1 		      
	syscall

	# " ways to make change.\n"
	la	   $a0, cntMsg3
	li	   $v0, 4
	syscall

	# newline
	la	   $a0, newLine
	li	   $v0, 4
	syscall

	# newline
	la     $a0, newLine
	li	   $v0, 4
	syscall

jr	$ra
.end showWays

# =================================================================
#  Function to prompt for and read initial amount.
#  Ensure that amount is between min cents (passed)
#  and max cents (passed).

# -----
#  HLL Call:
#	bool = readInitAmt(min, max, errLimit, &initAmt)

# -----
#    Arguments:
#	$a0 - minimum amount
#	$a1 - maximum amount
#	$a2 - error limit
#	$a3 - initial amount
#    Returns:
#	$v0 - n value
.globl	readInitAmt
.ent	readInitAmt
readInitAmt:

	move  $t2, $a2    # $t2 is err limit
readVal:
	# prints Enter amount (1-500) _____________
	la    $a0, amtPmt1
	li    $v0, 4
	syscall 

	lw    $a0, amountMinimum
	li    $v0, 1
	syscall

	la    $a0, amtPmt2
	li    $v0, 4
	syscall

	lw    $a0, amountMaximum
	li    $v0, 1
	syscall

	la    $a0, amtPmt3
	li    $v0, 4
	syscall
	#____________________________________________

	## read user input
	li	$v0, 5
	syscall
	
	move	$t0, $v0					# user input
	bltu  	$t0, 1, invalidNum	    	# check t0 < 1
	bgtu 	$t0, 500, invalidNum		# check t0 > 500

	# saves and returns true
	sw      $v0, ($a3)
	la      $v0, TRUE
	j       endRead

	invalidNum:
		# compares lim to zero
		beq   $t2, 0, maxLim

		la    $a0, err1
		li    $v0, 4
		syscall
		# limit is dec everytime invalid num
		sub   $t2, $t2, 1
		j     readVal

		maxLim:
			la    $a0, err2
			li    $v0, 4
			syscall
			# returns false
			la    $v0, FALSE
			j     endRead

endRead:

jr	 $ra
.end	readInitAmt
#####################################################################
#  Function to count the number of ways that change can be made
#  given our standard US monetary denominations (cent,
#  nickel, dime, quarter, etc.).

# -----
#  Arguments:
#	$a0 - coins array
#	$a1 - denomCnt
#	$a2 - currentAmount
#  Returns:
#	$v0 - ways count

.globl	makeChange
.ent	makeChange
makeChange:
	# pushing regs
	subu $sp, $sp, 20
	sw   $ra, ($sp)
	sw   $s0, 4($sp)
	sw   $s1, 8($sp)
	sw   $s2, 12($sp)
	sw   $s4, 16($sp) 

	# save
	move    $t0, $a0
	move    $t1, $a1
	move    $t2, $a2

	# base
	li    $v0, 1
	beq   $t2, 0, endMake    # if amount = 0

	# else, 
	li    $v0, 0
	blt   $t2, 0, endMake   # amount < 0, return 0
	ble   $t1, 0, endMake   # count <= 0, return 0

	# save
	move    $s0, $t0	  # coins array
	move    $s1, $t1	  # count	
	move    $s2, $t2	  # amount

	# recursive ____________________________________
		sub   $a1, $a1, 1    # countt - 1
		jal   makeChange

		move   $s4, $v0      # $s4 = resu;ts

		sub $t4, $s1, 1      # count - 1
		mul $t4, $t4, 4 
		add $t4, $t4, $s0    # address of cnt -1 

		# save 
		move    $a0, $s0 
		move    $a1, $s1
		move    $a2, $s2

		lw      $t5, ($t4)    	 # array at count-1

		sub     $a2, $a2, $t5     # amt - c[cCnt -1]
		jal     makeChange        # recurzsize call

	# add results
	add    $v0, $v0, $s4

endMake: 
	# pop regs
	lw   $ra, ($sp)
	lw   $s0, 4($sp)
	lw   $s1, 8($sp)
	lw   $s2, 12($sp)
	lw   $s4, 16($sp)
	addu $sp, $sp, 20

jr	 $ra
.end	makeChange
#####################################################################
#  Function to ask user if they want to continue.

#  Basic flow:
#	prompt user
#	read user answer (as character)
#		if y -> return TRUE
#		if n -> return FALSE
#	otherwise, display error and loop to re-prompt

# -----
#  Arguments:
#	none
#  Returns:
#	$v0 - TRUE/FALSE
.globl	continue
.ent	continue
continue:

# reprompt user
prompt:
	la	$a0, qPmt	
	li	$v0, 4
	syscall


	# input
	la    $a0, ans	 # where to place answer
	li    $v0, 8 	 # call code for string
	li    $a1, 3	 # one char
	syscall 

	la    $t1, ans		# load address of ans
	lb    $t0, ($t1)    # get byte at needed address 

	# prints newline
	la    $a0, newLine
	li	  $v0, 4
	syscall

	# y/n error check 
	bne   $t0, 'y', checkNo	  # jump to no if its not yes
	la    $v0, TRUE           # true will, restart program
	j     contDone


	checkNo:
		bne   $t0, 'n', Error	    # checks for 'n'
		la    $v0, FALSE            # false, exits program
		j     contDone

		# error if not yes or no
		Error: 
			la	 $a0, ansErr
			li	 $v0, 4
			syscall
			# jump back to prompt
			j    prompt

contDone:

jr	$ra
.end continue
#####################################################################

