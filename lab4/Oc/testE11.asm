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
addi $sp, $sp, -8
la $t0, -8($fp)
addi $sp, $sp, -4
addi $t1, $t0, 0
sw $t1, -12($fp)
addi $sp, $sp, -4
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
lw $ra, 0($sp)
addi $sp, $sp, 4
move $t0, $v0
sw $t0, -16($fp)
lw $t0, -16($fp)
lw $t1, -12($fp)
sw $t0, 0($t1)
sw $t1, -12($fp)
la $t0, -8($fp)
addi $sp, $sp, -4
addi $t1, $t0, 4
sw $t1, -20($fp)
li $t0, 3
lw $t1, -20($fp)
sw $t0, 0($t1)
sw $t1, -20($fp)
la $t0, -8($fp)
addi $sp, $sp, -4
addi $t1, $t0, 0
sw $t1, -24($fp)
la $t0, -8($fp)
addi $sp, $sp, -4
addi $t1, $t0, 4
sw $t1, -28($fp)
lw $t0, -24($fp)
lw $t0, 0($t0)
lw $t1, -28($fp)
lw $t1, 0($t1)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -32($fp)
lw $t0, -32($fp)
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
