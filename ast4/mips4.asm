###########################################################################
#  Name: Kamila Kinel
#  NSHE ID: 5005951543
#  Section: 1003 & 1004
#  Assignment: MIPS #4
#  Description: Find least cost path in a triangle
#				of numbers, as well as lists number of all
#				possible solutions.  Also outputs two d-
#				array in form of a triangle.

#  MIPS assembly language program to calculate
#  the least cost path in a triangle from top
#  to bottom.

###########################################################
#  data segment

.data

TRUE = 1
FALSE = 0

hdr:	.ascii	"\nMIPS Assignment #4\n"
	.asciiz	"Program to Find Cost of Least Cost Path.\n\n"

# -----
#  Triangles.

bName1:	.asciiz	"Triangle #1 (example)\n"
bOrd1:	.word	4
brd1:	.word	3, 0, 0, 0
	.word	7, 4, 0, 0
	.word	4, 2, 6, 0
	.word	8, 2, 9, 5

bName2:	.asciiz	"Triangle #2 (small)\n"
bOrd2:	.word	5
brd2:	.word	5, 0, 0, 0, 0
	.word	6, 8, 0, 0, 0
	.word	3, 4, 7, 0, 0
	.word	5, 8, 2, 6, 0
	.word	8, 5, 1, 3, 9

bName3:	.asciiz	"Triangle #3 (small)\n"
bOrd3:	.word	6
brd3:	.word	3, 0, 0, 0, 0, 0
	.word	7, 4, 0, 0, 0, 0
	.word	4, 2, 6, 0, 0, 0
	.word	8, 2, 9, 5, 0, 0
	.word	9, 3, 6, 2, 7, 0
	.word	1, 2, 8, 4, 7, 3

bName4:	.asciiz	"Triangle #4 (medium)\n"
bOrd4:	.word	15
brd4:	.word	75,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	.word	95, 64,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	.word	17, 47, 82,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	.word	18, 35, 87, 10,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	.word	20,  4, 82, 47, 65,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	.word	19,  1, 23, 75,  3, 34,  0,  0,  0,  0,  0,  0,  0,  0,  0
	.word	88,  2, 77, 73,  7, 63, 67,  0,  0,  0,  0,  0,  0,  0,  0
	.word	99, 65,  4, 28,  6, 16, 70, 92,  0,  0,  0,  0,  0,  0,  0
	.word	41, 41, 26, 56, 83, 40, 80, 70, 33,  0,  0,  0,  0,  0,  0
	.word	41, 48, 72, 33, 47, 32, 37, 16, 94, 29,  0,  0,  0,  0,  0
	.word	53, 71, 44, 65, 25, 43, 91, 52, 97, 51, 14,  0,  0,  0,  0
	.word	70, 11, 33, 28, 77, 73, 17, 78, 39, 68, 17, 57,  0,  0,  0
	.word	91, 71, 52, 38, 17, 14, 91, 43, 58, 50, 27, 29, 48,  0,  0
	.word	63, 66, 04, 68, 89, 53, 67, 30, 73, 16, 69, 87, 40, 31,  0
	.word	 4, 62, 98, 27, 23,  9, 70, 98, 73, 93, 38, 53, 60,  4, 23


bName5:	.asciiz	"Triangle #5 (large)\n"
bOrd5:	.word	17
brd5:	.word	75,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	.word	95, 64,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	.word	17, 47, 82,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	.word	18, 35, 87, 10,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	.word	20, 04, 82, 47, 65,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	.word	19, 01, 23, 75, 03, 34,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	.word	88, 02, 77, 73, 07, 63, 67,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	.word	99, 65, 04, 28, 06, 16, 70, 92,  0,  0,  0,  0,  0,  0,  0,  0,  0
	.word	41, 41, 26, 56, 83, 40, 80, 70, 33,  0,  0,  0,  0,  0,  0,  0,  0
	.word	41, 48, 72, 33, 47, 32, 37, 16, 94, 29,  0,  0,  0,  0,  0,  0,  0
	.word	53, 71, 44, 65, 25, 43, 91, 52, 97, 51, 14,  0,  0,  0,  0,  0,  0
	.word	70, 11, 33, 28, 77, 73, 17, 78, 39, 68, 17, 57,  0,  0,  0,  0,  0
	.word	91, 71, 52, 38, 17, 14, 91, 43, 58, 50, 27, 29, 48,  0,  0,  0,  0
	.word	63, 66, 04, 68, 89, 53, 67, 30, 73, 16, 69, 87, 40, 31,  0,  0,  0
	.word	04, 62, 98, 27, 23, 09, 70, 98, 73, 93, 38, 53, 60, 04, 23,  0,  0
	.word	77, 22, 10, 81, 12, 94, 07, 22, 35, 80, 87, 70, 19, 03, 84, 34,  0
	.word	28, 33, 10, 38, 11, 99, 31, 43, 86, 19, 71, 72, 64, 41, 70, 44, 53


bName6:	.asciiz	"Triangle #6 (largest)\n"
bOrd6:	.word	20
brd6:	.word	59,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	.word	73, 41,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	.word	52, 40, 09,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	.word	26, 53, 06, 34,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	.word	10, 51, 87, 86, 81,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	.word	61, 95, 66, 57, 25, 68,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	.word	90, 81, 80, 38, 92, 67, 73,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	.word	30, 28, 51, 76, 81, 18, 75, 44,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	.word	84, 14, 95, 87, 62, 81, 17, 78, 58,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	.word	21, 46, 71, 58, 02, 79, 62, 39, 31, 09,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
	.word	56, 34, 35, 53, 78, 31, 81, 18, 90, 93, 15,  0,  0,  0,  0,  0,  0,  0,  0,  0
	.word	78, 53, 04, 21, 84, 93, 32, 13, 97, 11, 37, 51,  0,  0,  0,  0,  0,  0,  0,  0
	.word	45, 03, 81, 79, 05, 18, 78, 86, 13, 30, 63, 99, 95,  0,  0,  0,  0,  0,  0,  0
	.word	39, 87, 96, 28, 03, 38, 42, 17, 82, 87, 58, 07, 22, 57,  0,  0,  0,  0,  0,  0
	.word	06, 17, 51, 17, 07, 93, 09, 07, 75, 97, 95, 78, 87, 08, 53,  0,  0,  0,  0,  0
	.word	67, 66, 59, 60, 88, 99, 94, 65, 55, 77, 55, 34, 27, 53, 78, 28,  0,  0,  0,  0
	.word	76, 40, 41, 04, 87, 16, 09, 42, 75, 69, 23, 97, 30, 60, 10, 79, 87,  0,  0,  0
	.word	12, 10, 44, 26, 21, 36, 32, 84, 98, 60, 13, 12, 36, 16, 63, 31, 91, 35,  0,  0
	.word	70, 39, 06, 05, 55, 27, 38, 48, 28, 22, 34, 35, 62, 62, 15, 14, 94, 89, 86,  0
	.word	66, 56, 68, 84, 96, 21, 34, 34, 34, 81, 62, 40, 65, 54, 62, 05, 98, 03, 02, 60


# -----
#  Variables for displayTriangle() function.

brdHdr:		.asciiz	"***********************************************\n"
newLine:	.asciiz	"\n"
blnk:		.asciiz	" "
blnk2:		.asciiz	"  "
zer:		.asciiz	"0"

# -----
#  Variables for findLeastCost() function.

LCmsg:		.asciiz	"Least Cost Traversal: "
PSmsg:		.asciiz	"Possible Solutions: "


###########################################################
#  text/code segment

.text

.globl main
.ent main
main:

# -----
#  Display main program header.

	la	$a0, hdr
	li	$v0, 4
	syscall					# print header

# -----
#  Display triangle and find least cost for each triangle.

	lw	$a0, bOrd1
	la	$a1, brd1
	la	$a2, bName1
	jal	displayTriangle

	lw	$a0, bOrd1
	la	$a1, brd1
	jal	findLeastCost


	lw	$a0, bOrd2
	la	$a1, brd2
	la	$a2, bName2
	jal	displayTriangle

	lw	$a0, bOrd2
	la	$a1, brd2
	jal	findLeastCost


	lw	$a0, bOrd3
	la	$a1, brd3
	la	$a2, bName3
	jal	displayTriangle

	lw	$a0, bOrd3
	la	$a1, brd3
	jal	findLeastCost


	lw	$a0, bOrd4
	la	$a1, brd4
	la	$a2, bName4
	jal	displayTriangle

	lw	$a0, bOrd4
	la	$a1, brd4
	jal	findLeastCost


	lw	$a0, bOrd5
	la	$a1, brd5
	la	$a2, bName5
	jal	displayTriangle

	lw	$a0, bOrd5
	la	$a1, brd5
	jal	findLeastCost


	lw	$a0, bOrd6
	la	$a1, brd6
	la	$a2, bName6
	jal	displayTriangle

	lw	$a0, bOrd6
	la	$a1, brd6
	jal	findLeastCost

# -----
#  Done, terminate program.

	li	$v0, 10
	syscall
.end main

######################################################################
#  Function to print a formatted triangle (as per assignment).

# -----
#  Formula for multiple dimension array indexing:
#	addr(r,c) = baseAddr + (r * colSize + c) * dataSize

# -----
#  Arguments:
#	$a0 - order (size) of the triangle
#	$a1 - triangle address
#	$a2 - title address  ( name )
.globl displayTriangle
.ent   displayTriangle
displayTriangle:
	subu  $sp, $sp, 24
	sw    $s0, 0($sp) 
	sw    $s1, 4($sp) 
	sw    $s2, 8($sp) 
	sw    $s3, 12($sp)
	sw    $fp, 16($sp)
	sw    $ra, 20($sp) 
	addu  $fp, $sp, 24 # set frame pointer

	move  $s0, $a0     # $s0 = size
	move  $s1, $a1     # $s1 = triangle add
	move  $s2, $a2     # $s3 = tittle add

	# display ***** header
	la    $a0, brdHdr  # ***** header
	li    $v0, 4       # call code for string
	syscall

	move  $a0, $a2    # name
	li    $v0, 4      # call code for string
	syscall

	# print newline
	la	  $a0, newLine
	li    $v0, 4
	syscall

	# print newline
	la	  $a0, newLine
	li    $v0, 4
	syscall

	li    $t0, 0     # row index
	li    $t3, 0     # size index

	#print triangle
	#          03       size = 4   10
	#              03   size = 6   14
	#            05     size = 5   12
	#        07         size = 4   8 
	# spacing for top one is (2*size) + 2

	move   $t1, $s0     # puts size in alterable val
	startSPC:
	li     $t9, 0       # t9 = index for spacing loop

	# Gets correct num of spaces for before each row
	mul    $t1, $t1, 2
	add    $t1, $t1, 2
	spaceLP:
		la      $a0, blnk            # prints " "
		syscall

		add     $t9, $t9, 1          # index++
		bltu    $t9, $t1, spaceLP    # if i < size, loop

	# convert size back to size
	sub   $t1, $t1, 2
	div   $t1, $t1, 2

	# print triangle here
	li    $t2, 0     # colomn index ( here cus needs to be reset/every row)
	move  $t7, $t1   # $t7 is alterable, of the alterable size index

	#	addr(r,c) = baseAddr + (r * colSize + c) * dataSize
	triPRINT:
		bgtu  $t7, $s0, stopTri    # compare alterable alterable size to og size

		# prints zero before num
		mul   $t4, $t0, $s0   # row * col
		add   $t4, $t4, $t2   # (row * col) + col
		mul   $t4, $t4, 4     # data size
		add   $t4, $t4, $s1   # base add
		lw    $t5, ($t4)      # saves actual val in $t5

		bgeu  $t5, 10, skipZero  # skip zero if there is two digits

		la    $a0, zer
		li    $v0, 4
	    syscall 
		skipZero:

		move $a0, $t5   	  # prints value
		li   $v0, 1
		syscall

		add  $t7, $t7, 1    # inc alt/alt size index
		add  $t2, $t2, 1    # increase col

		bgtu  $t7, $s0, stopTri    # compare alterable alterable size to og size

		la      $a0, blnk       # prints " "
		li     $v0, 4
		syscall

		la      $a0, blnk       # prints " "
		li     $v0, 4
		syscall

		j     triPRINT
	stopTri:

	# prints newline at the end of last num
	la	  $a0, newLine
	li    $v0, 4
	syscall

	sub   $t1, $t1, 1    # increments size index that decreases each row
	add   $t0, $t0, 1    # row++
	bnez  $t1, startSPC  # if size != 0, get spacing

	# prints newline at the end of last num
	la	  $a0, newLine
	li    $v0, 4
	syscall

	lw    $s0, 0($sp) 
	lw    $s1, 4($sp) 
	lw    $s2, 8($sp) 
	lw    $s3, 12($sp) 
	lw    $fp, 16($sp)
	lw    $ra, 20($sp)
	addu  $sp, $sp, 24

jr    $ra
.end displayTriangle

######################################################################
#  Function to find the value of least cost path.

# -----
#  Formula for multiple dimension array indexing:
#	addr(r,c) = baseAddr + (r * colSize + c) * dataSize

# -----
#    Arguments:
#	$a0 - triangle order
#	$a1 - triangle address

#    Returns:
#	nothing

.globl findLeastCost
.ent   findLeastCost
findLeastCost:
# here to visualize---------------------
#bOrd1:	.word	4

# brd1:	.word	3, 0, 0, 0
#    	.word	7, 4, 0, 0
#   	.word	4, 2, 6, 0
#   	.word	8, 2, 9, 5

	move   $s0, $a0		# triangle order
	move   $s1, $a1		# triangle address

	sub    $t0, $s0, 2  # row index
	li     $t1, 0		# col index

firstFor:
	secFor:
		add    $t9, $t0, 1    # row bellow

		# same col 
		mul    $t3, $t9, $s0    # row * size 
		add    $t3, $t3, $t1    # + collidx (same col )
		mul    $t3, $t3, 4      # data size
		add    $t3, $t3, $s1    # add base address 

		# row same col
		lw     $t5, ($t3) 

		# to the right
		add    $t7, $t1, 1    # to the right

		mul    $t4, $t9, $s0   # row + size 
		add    $t4, $t4, $t7
		mul    $t4, $t4, 4    # data
		add    $t4, $t4, $s1  # add base address 

		lw    $t6, ($t4) 

		# calculate addtion
		mul   $t2, $t0, $s0   # row*col
		add   $t2, $t2, $t1   # + col
		mul   $t2, $t2, 4     # data size 
		add   $t2, $t2, $s1   # add base address 

		lw    $t8, ($t2)  	  # $t9 has out value

		bgt   $t5, $t6, newVal 

		add   $s3, $t5, $t8 
		sw    $s3, ($t2)      # overwrite
		j     skip
		
	newVal:
		add   $s3, $t6, $t8 
		sw    $s3, ($t2)  

	skip:
		add   $t1, $t1, 1        # col++ 
		bgtu  $t1, $t0, backRow
		j     secFor

	backRow: 
		sub   $t0, $t0, 1   # move up one row 
		li    $t1, 0		# col =0
	
    	bne   $t0, -1, firstFor # jump if row neg

	li   $t0, 1
	li   $s4, 1

	orderLoop:
		mul    $s4, $s4, 2
		add    $t0, $t0, 1            # i++

		bne    $t0, $s0, orderLoop

# printing==================================================

	# prints leas cost trav
		la    $a0, LCmsg
		li    $v0, 4       # call code for string
		syscall

		move $a0, $s3
		li $v0, 1 
		syscall

		la	  $a0, newLine
		li    $v0, 4
		syscall
	# prints possible solutions
		la    $a0, PSmsg
		li    $v0, 4       # call code for string
		syscall

		move $a0, $s4
		li $v0, 1 
		syscall

		la	  $a0, newLine
		li    $v0, 4
		syscall

	# prints newline 
	la	  $a0, newLine
	li    $v0, 4
	syscall

#==========================================================


jr    $ra
.end findLeastCost
######################################################################

