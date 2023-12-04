.data
scores: .word 32, 56, 78, 66, 88, 90, 93, 100, 101, 82
fileName: .space 50  # Allocate space for filename input
filename_msg: .asciiz "Enter the filename (e.g., practiceFile.txt): "
practiceFile: .asciiz "practiceFile.txt"
enjoyMsg: .asciiz "What did you enjoy most in class: " 
aBuffer: .space 1025
bBuffer: .space 1025
userInput: .space 1025
test_msg: .asciiz "\nthis is a test message"
aString: .asciiz "A\n"
bString: .asciiz "B\n"
cString: .asciiz "C\n"
dString: .asciiz "D\n"
fString: .asciiz "F\n"

.text
main:
    # Task 1: Calculate Letter Grades
    li $t0, 0       # loop counter
    la $t1, scores  # pointer to scores array

    grade_loop:
        lw $t2, 0($t1)   # load score

        # Your logic for grade calculation here
        bgt $t2, 90, print_A
        bgt $t2, 80, print_B
        bgt $t2, 70, print_C
        bgt $t2, 60, print_D
        j print_F

print_A:
    li $v0, 4
    la $a0, aString
    syscall
    j end_print

print_B:
    li $v0, 4
    la $a0, bString
    syscall
    j end_print

print_C:
    li $v0, 4
    la $a0, cString
    syscall
    j end_print

print_D:
    li $v0, 4
    la $a0, dString
    syscall
    j end_print

print_F:
    li $v0, 4
    la $a0, fString
    syscall




    end_print:

# Task 2: File Operations (Read from practiceFile.txt)
    li $v0, 13
    la $a0, practiceFile
    li $a1, 0
    li $a2, 0
    syscall
    move $s0, $v0

    li $v0, 14
    move $a0, $s0
    la $a1, aBuffer
    li $a2, 1024
    syscall

    li $v0, 16
    move $a0, $s0
    syscall

# Task 3: File Operations (Append to a user-defined file)
    la $a0, filename_msg
    li $v0, 4
    syscall

    la $a0, fileName
    li $a1, 49
    li $v0, 8
    syscall

    li $v0, 13
    la $a0, fileName
    li $a1, 9
    li $a2, 0
    syscall
    move $s1, $v0

    li $v0, 4
    la $a0, enjoyMsg
    syscall

    la $a0, userInput
    li $a1, 1024
    li $v0, 8
    syscall

    li $v0, 15
    move $a0, $s1
    la $a1, userInput
    li $a2, 1024
    syscall

    li $v0, 16
    move $a0, $s1
    syscall

# Exit program
    li $v0, 10
    syscall
