###########################################################################
#  Name: Kamila Kinel
#  NSHE ID: 5005951543
#  Section: 1003 and 1004
#  Assignment: MIPS #1
#  Description: A MIPS assembly language program that 
#				calculates the semi-perimter for each
#				right triangle. It then calulates the
#               middle value, the average, the sum, the
#				min, and the max.

################################################################################
#  data segment

.data

aSides:	.word	 121,  123,  131,  139,  141,  149,  153,  157,  163,  169
	.word	 201,  207,  212,  215,  223,  227,  231,  236,  241,  245
	.word	 251,  252,  262,  264,  271,  273,  287,  289,  293,  299
	.word	 301,  305,  312,  315,  326,  328,  332,  337,  341,  343
	.word	 401,  408,  411,  413,  421,  424,  431,  434,  445,  448
	.word	 453,  454,  460,  462,  474,  475,  486,  487,  491,  492
	.word	 501,  504,  515,  517,  524,  525,  535,  537,  543,  548
	.word	 551,  553,  563,  567,  577,  579,  582,  588,  593,  595

bSides:	.word	  75,   81,   83,   87,   89,   91,   94,   97,   99,  101
	.word	 107,  111,  120,  121,  137,  141,  157,  167,  177,  181
	.word	 191,  199,  202,  209,  215,  219,  223,  225,  231,  242
	.word	 244,  249,  251,  253,  266,  269,  271,  272,  280,  288
	.word	 291,  299,  301,  303,  307,  311,  321,  329,  330,  331
	.word	 332,  351,  376,  387,  390,  400,  411,  423,  432,  445
	.word	 469,  474,  477,  479,  482,  484,  486,  488,  492,  493
	.word	 557,  587,  599,  601,  623,  624,  625,  626,  627,  628

cSides:	.word	  13,   17,   21,   23,   33,   39,   47,   53,   63,   79
	.word	  81,   93,   99,  100,  103,  107,  109,  111,  121,  127
	.word	 132,  137,  142,  149,  154,  161,  167,  178,  186,  197
	.word	 206,  212,  222,  231,  246,  250,  254,  278,  288,  292
	.word	 303,  315,  321,  339,  348,  359,  362,  374,  380,  391
	.word	 400,  404,  406,  407,  424,  425,  426,  429,  448,  492
	.word	 501,  513,  524,  536,  540,  556,  575,  587,  590,  596
	.word	 634,  652,  674,  686,  697,  704,  716,  720,  736,  753
	.word	 782,  795,  807,  812,  817,  827,  837,  839,  841,  844

semiPerims:
	.space	320

length:	.word	80

sMin:	.word	0
sMid:	.word	0
sMax:	.word	0
sSum:	.word	0
sAve:	.word	0 


# -----

hdr:	.ascii	"MIPS Assignment #1 \n"
	.ascii	"Program to calculate the semi-perimeter of each right "
	.ascii	"triangle in a\n series of right triangles.  Also finds "
	.asciiz	"min, mid, max, sum, and average\n for the semi-perimeters.\n"

newLine:
	.asciiz	"\n"
blnks:	.asciiz	"  "

a1_st:	.asciiz	"\nSemi-Perimeters min = "
a2_st:	.asciiz	"\nSemi-Perimeters mid = "
a3_st:	.asciiz	"\nSemi-Perimeters max = "
a4_st:	.asciiz	"\nSemi-Perimeters sum = "
a5_st:	.asciiz	"\nSemi-Perimeters ave = "


###########################################################
#  text/code segment

.text
.globl main
.ent main
main:

# -----
#  Display header.

	la	$a0, hdr
	li	$v0, 4
	syscall				# print header

# -----

    la    $t0, aSides	 #array start for a sides
	la    $t1, bSides	 # array start for b sides
	la    $t2, cSides    # array start for c sides
	la    $t7, semiPerims  # destination

	li    $t3, 0         # counter
	lw    $t4, length    #length

	semiPLP:
		lw    $t5, ($t0)   # a sides[i]
		lw    $t6, ($t1)   # bsides[i]

		add   $t5, $t5, $t6

		lw    $t6, ($t2)   # csides[i]
		add   $t5, $t5, $t6  #$t5= asides[i]+bsides{i]+csides[i]

		div   $t5, $t5, 2    # sum/2

		sw   $t5, ($t7)  # saves into semip array

		add  $t3, $t3, 1
		add  $t0, $t0, 4
		add  $t1, $t1, 4
		add  $t2, $t2, 4
		add  $t7, $t7, 4
		blt  $t3, $t4, semiPLP

##########################################################
#  Display numbers (8 numbers per row) from the array.

	la	$a0, newLine		# print a newline
	li	$v0, 4
	syscall

	la    $s0, semiPerims
	lw    $t1, length
	li    $t2, 0
	li    $t4, 4

	printLP:
		li    $v0, 1
		lw    $a0, ($s0)
		syscall

		li    $v0, 4
		la    $a0, blnks
		syscall

		addu  $s0, $s0, 4
		add   $t2, $t2, 1
		rem   $t0, $t2, 8   # ensures 8 perline
		bnez  $t0, skipNew

		li    $v0, 4
		la    $a0, newLine
		syscall

	skipNew:
		bne   $t2, $t1, printLP

# STATS_________________________________________________

	## Sum
	la    $t0, semiPerims
	lw    $t1, length  #legnth
	li    $t2, 0       # sum

	sumLP:
		lw    $t3, ($t0)
		add   $t2, $t2, $t3  # sum=+ semiPer[i]
		addu  $t0, $t0, 4    # next num in aray
		sub   $t1, $t1, 1
		bnez  $t1, sumLP

	sw    $t2, sSum  #saves into sum var

	## Ave
	lw    $t1, length
	div   $t5, $t2, $t1
	sw    $t5, sAve

	## Median
	la    $t0, semiPerims   #first num of arr
	div   $t2, $t1, 2       # length/2
	mul   $t3, $t2, 4		# index of offest
	add   $t4, $t0, $t3     # bas adr of arr
	
	lw    $t6, ($t4)        # array[len/2]
	sub   $t4, $t4, 4       # arr[(len/2)-1]

	lw    $t5, ($t4)        # load val into $t5

	add   $t7, $t5, $t6     # arr[len/2]+arr[(len/2)-1]
	div   $t8, $t7, 2       # sum/2

	sw    $t8, sMid			# save to mid var

	## Min and Max
	la    $t0, semiPerims
	lw    $t6, ($t0)       #saves val of arr[0]
	sw    $t6, sMin        # saves to min var

	sub   $t1, $t1, 1       # length -1
	mul   $t3, $t1, 4		# index of offest
	add   $t7, $t0, $t3     # bas adr of arr

	lw    $t8, ($t7)		# saves val into t8
	sw    $t8, sMax			# saves to max addr

##########################################################
#  Display results.

	la	$a0, newLine		# print a newline
	li	$v0, 4
	syscall

#  Print min message followed by result.

	la	$a0, a1_st
	li	$v0, 4
	syscall				# print "min = "

	lw	$a0, sMin
	li	$v0, 1
	syscall				# print min

# -----
#  Print middle message followed by result.

	la	$a0, a2_st
	li	$v0, 4
	syscall				# print "med = "

	lw	$a0, sMid
	li	$v0, 1
	syscall				# print mid

# -----
#  Print max message followed by result.

	la	$a0, a3_st
	li	$v0, 4
	syscall				# print "max = "

	lw	$a0, sMax
	li	$v0, 1
	syscall				# print max

# -----
#  Print sum message followed by result.

	la	$a0, a4_st
	li	$v0, 4
	syscall				# print "sum = "

	lw	$a0, sSum
	li	$v0, 1
	syscall				# print sum

# -----
#  Print average message followed by result.

	la	$a0, a5_st
	li	$v0, 4
	syscall				# print "ave = "

	lw	$a0, sAve
	li	$v0, 1
	syscall				# print average

# -----
#  Done, terminate program.

endit:
	la	$a0, newLine		# print a newline
	li	$v0, 4
	syscall

	li	$v0, 10
	syscall				# all done!

.end main

