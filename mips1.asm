.data
prompt_msg:    .asciiz "Please input message: "
offset_msg:    .asciiz "Please input offset number for Caesar cipher: "
original_msg:  .asciiz "Original message: "
encrypted_msg: .asciiz "Encrypted message: "
buffer:  .space  256           # Buffer for user input
result:  .space  256           # Buffer for the encrypted message

.text
main:
    # Prompt for user input - message
    li      $v0, 4
    la      $a0, prompt_msg
    syscall

    # Receive user input for the message
    li      $v0, 8
    la      $a0, buffer
    li      $a1, 256
    syscall

    # Prompt for user input - offset
    li      $v0, 4
    la      $a0, offset_msg
    syscall

    # Receive user input for the offset
li      $v0, 5
syscall
move    $t0, $v0

# Encrypt the message
la      $a0, buffer
move    $a1, $t0
jal     encrypt

    # Display the results - original message
    li      $v0, 4
    la      $a0, original_msg
    syscall

    # Display the original message
    li      $v0, 4
    la      $a0, buffer
    syscall

    # Display the results - encrypted message
    li      $v0, 4
    la      $a0, encrypted_msg
    syscall

    # Display the encrypted message
    li      $v0, 4
    la      $a0, result
    syscall

    # Exit the program
    li      $v0, 10
    syscall
# Method to encrypt the message using Caesar cipher
encrypt:
    move    $t1, $a0           # Save the address of the message
    move    $t2, $a1           # Save the offset value
    la      $t3, result        # Load the address of the result string

encrypt_loop:
    lb      $t4, 0($t1)        # Load the current character
    beqz    $t4, encrypt_end   # If null terminator, end the loop

    # Check if the character is lowercase
    li      $t5, 'a'           
    li      $t6, 'z'           
    blt     $t4, $t5, uppercase_check # If not lowercase, check uppercase

    # Handle lowercase characters
    blt     $t4, $t6, process_letter
    j       store_char

uppercase_check:
    # Check if the character is uppercase
    li      $t5, 'A'           
    li      $t6, 'Z'           
    blt     $t4, $t5, store_char
    blt     $t4, $t6, process_letter
    j       store_char

process_letter:
    # Common processing for uppercase and lowercase letters
    rem     $t7, $t2, 26        # Normalize the offset to be within 0-25
    add     $t4, $t4, $t7       # Add the offset

    # Check if wrapping is needed
    blt     $t4, $t5, wrap_around
    bgt     $t4, $t6, wrap_around
    j       store_char

wrap_around:
    # Correctly wrap the character
    blt     $t4, $t5, subtract_26 # If character is below 'A' or 'a', subtract 26
    bgt     $t4, $t6, add_26      # If character is above 'Z' or 'z', add 26
    j       store_char

subtract_26:
    add     $t4, $t4, 26
    j       store_char

add_26:
    sub     $t4, $t4, 26
    j       store_char

store_char:
    # Store the processed character
    sb      $t4, 0($t3)         
    addi    $t1, $t1, 1         
    addi    $t3, $t3, 1         
    j       encrypt_loop        

encrypt_end:
    sb      $zero, 0($t3)       # Null-terminate the result string
    jr      $ra                 # Return to the calling function