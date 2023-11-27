.data

User: .asciiz "Bush"
Line: .asciiz "\n"
Address: .word User

.text

main:
li $t0,1
li $t1,2
li $t2,3
li $t3,4
li $t4,5

lb $a0,User($0)
li $v0,1
syscall

la $a0,Line
li $v0,4
syscall

lb $a0,User($t0)
li $v0,1
syscall

la $a0,Line
li $v0,4
syscall

lb $a0,User($t1)

li $v0,1
syscall

la $a0,Line
li $v0,4
syscall

lb $a0,User($t2)

li $v0,1
syscall

la $a0,Line
li $v0,4
syscall

lb $a0,User($t3)

li $v0,1
syscall

la $a0,Line
li $v0,4
syscall

li $t1,-1
jal Length

j Exit

Length:

beq $a0,0,End
addi $t1,$t1,1
lb $a0,User($t1)
j Length

End:
move $a0,$t1
li $v0,1
syscall

jr $ra

Exit:
li $v0,10
syscall