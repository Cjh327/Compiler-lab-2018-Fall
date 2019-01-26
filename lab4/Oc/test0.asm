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
addi, $sp, $sp, -40
addi $sp, $sp, -4
li $t0, 1
sw $t0, -4($fp)
addi $sp, $sp, -4
li $t0, 2
sw $t0, -8($fp)
addi $sp, $sp, -0
la $t0, -8($fp)
addi $sp, $sp, -4
addi $t1, $t0, 0
sw $t1, -12($fp)
lw $t0, -4($fp)
addi $sp, $sp, -4
add $t1, $t0, $t0
sw $t1, -16($fp)
lw $t0, -16($fp)
lw $t1, -4($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -20($fp)
lw $t0, -20($fp)
lw $t1, -4($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -24($fp)
lw $t0, -24($fp)
lw $t1, -12($fp)
sw $t0, 0($t1)
sw $t1, -12($fp)
la $t0, -8($fp)
addi $sp, $sp, -4
addi $t1, $t0, 0
sw $t1, -28($fp)
lw $t0, -28($fp)
lw $t0, 0($t0)
move $a0, $t0
addi $sp, $sp, -4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
li $t0, 0
move $v0, $t0
move $sp, $fp
lw $fp, 0($sp)
addi $sp, $sp, 4
jr $ra
