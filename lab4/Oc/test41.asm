.data
_prompt: .asciiz "Enter an integer:"
_ret: .asciiz "\n"
.globl main

.text

read:
li $v0, 4
la $a0, _prompt
syscall
li $v0, 5
syscall
jr $ra

write:
li $v0, 1
syscall
li $v0, 4
la $a0, _ret
syscall
move $v0, $0
jr $ra

main:
addi $sp, $sp, -4
sw $fp, 0($sp)
move $fp, $sp
li $t0, 0
li $t1, 1
li $t2, 0
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
lw $ra, 0($sp)
addi $sp, $sp, 4
move $t3, $v0
move $t4, $t3
label1:
bge $t2, $t3, label2
add $t5, $t0, $t1
move $t6, $t5
move $a0, $t1
addi $sp, $sp, -4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
move $t0, $t1
move $t4, $t0
move $t1, $t6
move $t4, $t1
addi $t2, $t2, 1
move $t4, $t2
j label1
label2:
li $t7, 0
move $t7, $v0
move $sp, $fp
lw $fp, 0($sp)
addi $sp, $sp, 4
jr $ra
