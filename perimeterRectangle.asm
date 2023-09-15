###########################################################################
#  Name: Kamila Kinel 
#  NSHE ID: 5005951543
#  Section: 1001
#  Description: Mips assembly language program that finds area and perimeter
#               of a rectangle with prompt inputs. Code that accomplishes
#               the same thing in c++ is commented out on top of the page.

##########################################################################


# The area/perimeter code in c++ ---------------------------------------
#
#    int length = 0;   // in our asm code, we will use $t0
#    int width = 0;   // in our asm code, we will use $t1
#    int area = 0;    // in our asm code, we will use $t2
#    int perim = 0;   // in our asm code, we will use $t3
#    
#    cout << "Enter length\n";
#     cin >> length;
#     
#    cout << "Enter width\n";
#     cin >> width;
#     
#     // finding area
#     area = length * width;
#     
#     // finding perimeter
#     perim = 2*length + 2*width;
#    
#     // output
#     cout << "The area is " << area << endl;
#     cout << "The perimeter is " << perim << endl;
#-------------------------------------------------------------------------


.data
# message to prompt user for length and width
userL:       .asciiz "Enter length\n"
userW:       .asciiz "Enter width\n"

# message for displaying answer
area:        .asciiz  "The area is "
per:         .asciiz  "The perimeter is "

newline:     .asciiz "\n"

.text

.globl main
.ent main
main:

# input--------------------------------------------------------
    #prompts user to enter length
    la  $a0, userL     # Prints enter length
    li  $v0, 4
    syscall

    li  $v0, 5        # reads user input
    syscall
    
    move   $t0, $v0   # $t0 holds length

    #prompts user to enter width
    la  $a0, userW     # Prints enter width
    li  $v0, 4
    syscall

    li  $v0, 5         # reads user input
    syscall

    move   $t1, $v0   # $t1 holds width

# Find area-----------------------------------------------------

    mul    $t2, $t0, $t1    # $t2 = length * width

# find perimeter------------------------------------------------

    add   $t1, $t1, $t1     # $t1 = width + width
    add   $t0, $t0, $t0     # $t0 = length + length
    add   $t3, $t1, $t0     # $t3 = 2(width) + 2(length)

# print results-------------------------------------------------

    la   $a0, area          # prints "area is"{
    li   $v0, 4
    syscall

    move  $a0, $t2           # prints value of area
    li    $v0, 1
    syscall

    la   $a0, newline
    li   $v0, 4
    syscall

    la   $a0, per            # prints "perimenter is"
    li   $v0, 4
    syscall

    move  $a0, $t3            # prints value of perimenter
    li    $v0, 1
    syscall

jr	$ra    # end of func
.end main