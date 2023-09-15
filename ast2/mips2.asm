###########################################################################
#  Name: Kamila Kinel
#  NSHE ID: 5005951543
#  Section: 1003 & 1004
#  Assignment: MIPS #2
#  Description: An assembly program that calculates
#				the area of each right triangle in a 
#				series.  The right triangle areas are then
#				sorted and the min, max, sum, and ave is
#				found.

###########################################################
#  data segment

.data

aSides:	.word	  233,   214,   273,   231,   255 
	.word	  264,   273,   274,   223,   256 
	.word	  244,   252,   231,   242,   256 
	.word	  255,   224,   236,   275,   246 
	.word	  253,   223,   253,   267,   235 
	.word	  254,   229,   264,   267,   234 
	.word	  256,   253,   264,   253,   265 
	.word	  226,   252,   257,   267,   234 
	.word	  217,   254,   217,   225,   253 
	.word	  223,   273,   235,   261,   259 
	.word	  225,   224,   263,   247,   223 
	.word	  234,   234,   256,   264,   242 
	.word	  236,   252,   232,   231,   246 
	.word	  250,   254,   278,   288,   292 
	.word	  282,   295,   247,   252,   257 
	.word	  257,   267,   279,   288,   294 
	.word	  234,   252,   274,   286,   297 
	.word	  244,   276,   242,   236,   253 
	.word	  232,   251,   236,   287,   290 
	.word	  220,   241,   223,   232,   245 

bSides:	.word	  157,   187,   199,   111,   123 
	.word	  124,   125,   126,   175,   194 
	.word	  149,   126,   162,   131,   127 
	.word	  177,   199,   197,   175,   114 
	.word	  164,   141,   142,   173,   166 
	.word	  104,   146,   123,   156,   163 
	.word	  121,   118,   177,   143,   178 
	.word	  112,   111,   110,   135,   110 
	.word	  127,   144,   210,   172,   124 
	.word	  125,   116,   162,   128,   192 
	.word	  117,   114,   115,   172,   124 
	.word	  125,   116,   162,   138,   192 
	.word	  121,   183,   133,   130,   137 
	.word	  142,   135,   158,   123,   135 
	.word	  127,   126,   126,   127,   227 
	.word	  177,   199,   177,   175,   114 
	.word	  194,   124,   112,   143,   176 
	.word	  134,   126,   132,   156,   163 
	.word	  124,   119,   122,   183,   110 
	.word	  191,   192,   129,   129,   122 

rtAreas:
	.space	400 

len:	.word	100 

rtMin:	.word	0 
rtMid:	.word	0 
rtMax:	.word	0 
rtSum:	.word	0 
rtAve:	.word	0 

LN_CNTR	= 8


# -----

hdr:	.ascii	"MIPS Assignment #2 \n"
	.ascii	"  Right Triangle Areas Program:\n"
	.ascii	"  Also finds minimum, middle value, maximum, sum,\n"
	.asciiz	"  and average for the areas.\n\n"

a1_st:	.asciiz	"\nAreas Minimum = "
a2_st:	.asciiz	"\nAreas Median  = "
a3_st:	.asciiz	"\nAreas Maximum = "
a4_st:	.asciiz	"\nAreas Sum     = "
a5_st:	.asciiz	"\nAreas Average = "

newLn:	.asciiz	"\n"
blnks:	.asciiz	"  "

#  Variables/constants for insertion sort
tmp: 	.word 0 

###########################################################
#  text/code segment

# --------------------
#  Compute right triangle areas.
#  Then find middle, max, sum, and average for the areas.

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
	la    $t7, rtAreas   # destination

	li    $t3, 0         # counter i
	lw    $t4, len	     # length

	areasLP:
		lw    $t5, ($t0)   # a sides[i]
		lw    $t6, ($t1)   # bsides[i]

		mul   $t5, $t5, $t6
		div   $t5, $t5, 2    # sum/2

		sw   $t5, ($t7)  # saves into areas array

		add  $t3, $t3, 1  # i++
		add  $t0, $t0, 4  # next aside
		add  $t1, $t1, 4  # next b side
		add  $t7, $t7, 4  # next area
		blt  $t3, $t4, areasLP

#_________Prints areas_________________________________


#_______Insertion sort___________________________________
#  for i = 1 to length-1 do  {
#      value = arr[i];
#      j = i - 1;
#      while((j ≥ 0) and (arr[j] > value)){
#          arr[j+1] = arr[j];
#          j = j - 1;
#      }
#      arr[j+1] = value;
#   }
#}
	la    $t0, rtAreas
	li    $t1, 1    # i
	li    $t6, 0    # j
	lw    $t2, len  # length

	for1:
		bgeu  $t1, $t2, endFor1  # i>= len
		mul   $t3, $t1, 4
		add   $t4, $t0, $t3

		lw    $t5, ($t4)	# key=arr[i]

		sub   $t6, $t1, 1   # j = i-1

		while:
			bltu   $t6, 0, endWhile   # j>=0

			mul    $t7, $t6, 4
			add    $t8, $t0, $t7 

			lw     $t3, ($t8)   # t3= arr[j]

			bgeu   $t5, $t3, endWhile   # key<arr[j]

			add    $t6, $t6, 1
			mul    $t9, $t6, 4
			add    $t7, $t0, $t9   #arr[j+1]

			sw     $t3, ($t7)   # arr[j+1] = arr[j]
			sub    $t6, $t6, 1  # retstore j

			sub    $t6, $t6, 1  #j--
			j      while
		endWhile:

		add    $t6, $t6, 1
		mul    $t9, $t6, 4
		add    $t4, $t0, $t9

		sw     $t5, ($t4)   # arr[j+1] =key
	
		sub    $t6, $t6, 1  # retstore j	

	    add   $t1, $t1, 1   # i++
	    j     for1

	endFor1:

#_________Prints sorted areas__________________________


	la    $s0, rtAreas
	lw    $t1, len
	li    $t2, 0   # counter
	li    $t4, 4

	printLP2:
		li    $v0, 1
		lw    $a0, ($s0)
		syscall

		li    $v0, 4
		la    $a0, blnks
		syscall

		addu  $s0, $s0, 4
		add   $t2, $t2, 1
		rem   $t0, $t2, 8   # ensures 8 perline
		bnez  $t0, skipNew2

		li    $v0, 4
		la    $a0, newLn
		syscall

	skipNew2:
		bne   $t2, $t1, printLP2

#_________stats__________________________________________

## sum
	la    $t0, rtAreas   # array
	lw    $t1, len       # length
	li    $t2, 0         # sum = 0

	sumLP:
		lw    $t3, ($t0)     # $t3 = val at arr[i]
		add   $t2, $t2, $t3  # add val to runnin sum
		add   $t0, $t0, 4  # get next add in arry  
		sub   $t1, $t1, 1  # length -1
		bnez  $t1, sumLP  #if $t1 !=0, lp
	
	sw    $t2, rtSum     # val into var

## Ave
	lw   $t1, len
	div  $t3, $t2 $t1
	sw   $t3, rtAve


## min and max
	la   $t0, rtAreas    # gets first a
	lw   $t1, len        # length

	lw   $t4, ($t0)     # gets val from arr[0]
	sw   $t4, rtMin     # saves val into var

	sub  $t1, $t1, 1  # legnth-1
	mul  $t5, $t1, 4    # gets offset
	add  $t7, $t0, $t5  # gets needed adress for arr

	lw   $t6, ($t7)    # saves max val into $t6
	sw   $t6, rtMax    # saves val into var

## median

	lw    $t1, len         #length

	div   $t2, $t1, 2     #length /2
	mul   $t3, $t2, 4     #index of offset
	add   $t7, $t0, $t3   # arr[legnth/2]
	lw    $t5, ($t7)      # $t5 = val from arr[len/2]

	sub   $t9, $t7, 4
	lw    $t8, ($t9)

	add   $t2, $t5, $t8
	div   $t9, $t2, 2

	sw    $t9, rtMid


##########################################################
#  Display results.

	la	$a0, newLn		# print a newline
	li	$v0, 4
	syscall

#  Print min message followed by result.

	la	$a0, a1_st
	li	$v0, 4
	syscall				# print "min = "

	lw	$a0, rtMin
	li	$v0, 1
	syscall				# print min

# -----
#  Print middle message followed by result.

	la	$a0, a2_st
	li	$v0, 4
	syscall				# print "med = "

	lw	$a0, rtMid
	li	$v0, 1
	syscall				# print mid

# -----
#  Print max message followed by result.

	la	$a0, a3_st
	li	$v0, 4
	syscall				# print "max = "

	lw	$a0, rtMax
	li	$v0, 1
	syscall				# print max

# -----
#  Print sum message followed by result.

	la	$a0, a4_st
	li	$v0, 4
	syscall				# print "sum = "

	lw	$a0, rtSum
	li	$v0, 1
	syscall				# print sum

# -----
#  Print average message followed by result.

	la	$a0, a5_st
	li	$v0, 4
	syscall				# print "ave = "

	lw	$a0, rtAve
	li	$v0, 1
	syscall				# print average

# -----
#  Done, terminate program.

endit:
	la	$a0, newLn		# print a newline
	li	$v0, 4
	syscall

	li	$v0, 10
	syscall				# all done!

.end main

