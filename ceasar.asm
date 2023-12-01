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
    la      $t3, result         # Load the address of the result string

encrypt_loop:
    lb      $t4, 0($t1)         # Load the current character
    beqz    $t4, encrypt_end    # If null terminator, end the loop

    # Check if the character is a letter
    li      $t5, 'a'            # Load ASCII value of 'a'
    li      $t6, 'z'            # Load ASCII value of 'z'
    blt     $t4, $t5, uppercase_check # If the character is not lowercase, check uppercase

lowercase_check:
    # Calculate the encrypted character for lowercase letters
    sub     $t4, $t4, $t5        # Calculate (ch - 'a')
    add     $t4, $t4, $t2        # Add the offset
    rem     $t4, $t4, 26         # Ensure it stays within the alphabet range
    add     $t4, $t4, $t5        # Add 'a' to get the encrypted character
    j       store_char

uppercase_check:
    li      $t5, 'A'            # Load ASCII value of 'A'
    li      $t6, 'Z'            # Load ASCII value of 'Z'
    blt     $t4, $t5, not_letter # If the character is not a letter, skip

    # Calculate the encrypted character for uppercase letters
    sub     $t4, $t4, $t5        # Calculate (ch - 'A')
    add     $t4, $t4, $t2        # Add the offset
    rem     $t4, $t4, 26         # Ensure it stays within the alphabet range
    add     $t4, $t4, $t5        # Add 'A' to get the encrypted character
    j       store_char

not_letter:
    # If the character is not a letter, store it directly
    j       store_char

store_char:
    sb      $t4, 0($t3)          # Store the character in the result string
    addi    $t1, $t1, 1          # Move to the next character in the message
    addi    $t3, $t3, 1          # Move to the next position in the result string
    j       encrypt_loop         # Repeat the process

encrypt_end:
    sb      $zero, 0($t3)        # Null-terminate the result string
    jr      $ra                 # Return to the calling function
