.data
prompt_choice: .asciiz "Encrypt (e) or Decrypt (d)? "
prompt_msg:    .asciiz "Please input message: "
offset_msg:    .asciiz "Please input offset number for Caesar cipher: "
original_msg:  .asciiz "Original message: "
encrypted_msg: .asciiz "Encrypted/Decrypted message: "
buffer:  .space  256           # Buffer for user input
result:  .space  256           # Buffer for the encrypted/decrypted message

.text
main:
    # Prompt for user input - Encrypt or Decrypt
    li      $v0, 4
    la      $a0, prompt_choice
    syscall

    # Receive user input for Encrypt or Decrypt
    li      $v0, 8
    la      $a0, buffer
    li      $a1, 256
    syscall

    # Check the user's choice
    li      $t0, 'e'            # ASCII value for 'e'
    lb      $t1, buffer
    beq     $t1, $t0, encrypt_choice
    j       decrypt_choice

encrypt_choice:
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
    j       display_result

decrypt_choice:
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

    # Decrypt the message
    li      $t2, 26
    sub     $t0, $t2, $t0        # Calculate 26 - user input
    move    $a1, $t0
    la      $a0, buffer
    jal     encrypt
    j       display_result

display_result:
    # Display the results - original message
    li      $v0, 4
    la      $a0, original_msg
    syscall

    # Display the original message
    li      $v0, 4
    la      $a0, buffer
    syscall

    # Display the results - encrypted/decrypted message
    li      $v0, 4
    la      $a0, encrypted_msg
    syscall

    # Display the encrypted/decrypted message
    li      $v0, 4
    la      $a0, result
    syscall

    # Exit the program
    li      $v0, 10
    syscall

# Method to encrypt/decrypt the message using Caesar cipher
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
    blt     $t4, $t5, uppercase_check # If the character is


lowercase_check:
    # Calculate the encrypted/decrypted character for lowercase letters
    sub     $t4, $t4, $t5        # Calculate (ch - 'a')
    add     $t4, $t4, $t2        # Add the offset/decryption value
    rem     $t4, $t4, 26         # Ensure it stays within the alphabet range
    add     $t4, $t4, $t5        # Add 'a' to get the encrypted/decrypted character
    j       store_char

uppercase_check:
    li      $t5, 'A'            # Load ASCII value of 'A'
    li      $t6, 'Z'            # Load ASCII value of 'Z'
    blt     $t4, $t5, not_letter # If the character is not a letter, skip

    # Calculate the encrypted/decrypted character for uppercase letters
    sub     $t4, $t4, $t5        # Calculate (ch - 'A')
    add     $t4, $t4, $t2        # Add the offset/decryption value
    rem     $t4, $t4, 26         # Ensure it stays within the alphabet range
    add     $t4, $t4, $t5        # Add 'A' to get the encrypted/decrypted character
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
