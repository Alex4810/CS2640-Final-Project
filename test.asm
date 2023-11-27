# Macro to transfer letters to numbers
.macro charToNum char, result
    li      $t0, 'a'           # Load ASCII value of 'a'
    sub     $result, $char, $t0 # Calculate the position of the character
    addi    $result, $result, 1 # Adjust to 1-based indexing
.end_macro

# Macro to transfer numbers to letters
.macro numToChar num, result
    li      $t0, 'a'           # Load ASCII value of 'a'
    add     $result, $num, $t0 # Calculate ASCII value of the character
.end_macro

# Macro to convert string to number array
.macro strToNumArray str, numArray, length
    li      $t1, 0              # Initialize index
    li      $t2, 26             # Set the maximum value for a letter
    la      $t3, $str            # Load the address of the input string
convert_loop:
    lb      $t4, 0($t3)          # Load the current character
    beqz    $t4, convert_end     # If null terminator, end the loop
    charToNum $t4, $t5            # Convert the character to a number
    add     $t4, $t4, $offset    # Add the Caesar shift
    rem     $t4, $t4, $t2        # Ensure it stays within the alphabet range
    sb      $t4, 0($t6)          # Store the result in the array
    addi    $t1, $t1, 1          # Increment the index
    addi    $t6, $t6, 1          # Move to the next position in the array
    addi    $t3, $t3, 1          # Move to the next character in the string
    j       convert_loop         # Repeat the process
convert_end:
    sw      $t1, $length         # Store the length of the array
.end_macro

# Macro to convert number array to string
.macro numArrayToStr numArray, str, length
    li      $t1, 0              # Initialize index
    la      $t2, $str            # Load the address of the output string
    lw      $t3, $length         # Load the length of the array
convert_loop:
    beq     $t1, $t3, convert_end # If index equals length, end the loop
    lb      $t4, 0($t6)          # Load the current number
    numToChar $t4, $t5            # Convert the number to a character
    sb      $t5, 0($t2)          # Store the result in the string
    addi    $t1, $t1, 1          # Increment the index
    addi    $t2, $t2, 1          # Move to the next position in the string
    addi    $t6, $t6, 1          # Move to the next position in the array
    j       convert_loop         # Repeat the process
convert_end:
    sb      $zero, 0($t2)        # Null-terminate the string
.end_macro


.data
message:    .asciiz "Enter the message: "
offsetMsg:  .asciiz "Enter the Caesar shift offset: "
resultMsg:  .asciiz "Encrypted message: "
buffer:     .space  256           # Buffer for user input

.text
main:
    # Prompt for user input
    li      $v0, 4
    la      $a0, message
    syscall

    # Receive user input for the message
    li      $v0, 8
    la      $a0, buffer
    li      $a1, 256
    syscall

    # Prompt for user input for the Caesar shift offset
    li      $v0, 4
    la      $a0, offsetMsg
    syscall

    # Receive user input for the Caesar shift offset
    li      $v0, 5
    syscall
    move    $t0, $v0

    # Convert the message to an array of numbers
    la      $a0, buffer
    la      $a1, numArray
    la      $a2, length
    strToNumArray $a0, $a1, $a2

    # Add the Caesar shift offset to each number in the array
    li      $a0, $t0
    la      $a1, numArray
    la      $a2, length
    addCaesarShift $a0, $a1, $a2

    # Convert the number array back to a string
    la      $a0, numArray
    la      $a1, buffer
    la      $a2, length
    numArrayToStr $a0, $a1, $a2

    # Print the encrypted message
    li      $v0, 4
    la      $a0, resultMsg
    syscall

    li      $v0, 4
    la      $a0, buffer
    syscall

    # Exit the program
    li      $v0, 10
    syscall
