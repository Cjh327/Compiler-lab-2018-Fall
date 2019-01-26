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
li $t0, 3
sw $t0, -4($fp)
addi $sp, $sp, -4
li $t0, 12
sw $t0, -8($fp)
lw $t0, -8($fp)
addi $sp, $sp, -4
mul $t1, $t0, $t0
sw $t1, -12($fp)
lw $t0, -12($fp)
addi $sp, $sp, -4
addi $t1, $t0, 13
sw $t1, -16($fp)
lw $t0, -16($fp)
li $t1, 13
div $t0, $t1
addi $sp, $sp, -4
mflo $t2
sw $t2, -20($fp)
lw $t0, -20($fp)
addi $sp, $sp, -4
addi $t1, $t0, 1
sw $t1, -24($fp)
lw $t0, -8($fp)
lw $t1, -16($fp)
div $t0, $t1
addi $sp, $sp, -4
mflo $t2
sw $t2, -28($fp)
lw $t0, -16($fp)
lw $t1, -24($fp)
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -32($fp)
lw $t0, -28($fp)
lw $t1, -32($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -36($fp)
lw $t0, -36($fp)
move $a0, $t0
addi $sp, $sp, -4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t0, -36($fp)
li $t1, 2
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -40($fp)
lw $t0, -4($fp)
lw $t1, -40($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -44($fp)
lw $t0, -44($fp)
move $a0, $t0
addi $sp, $sp, -4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t0, -8($fp)
lw $t1, -16($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -48($fp)
lw $t0, -48($fp)
lw $t1, -24($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -52($fp)
lw $t0, -8($fp)
lw $t1, -44($fp)
div $t0, $t1
addi $sp, $sp, -4
mflo $t2
sw $t2, -56($fp)
lw $t0, -52($fp)
lw $t1, -56($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -60($fp)
lw $t0, -60($fp)
lw $t1, -4($fp)
add $t1, $t0, $t1
sw $t1, -4($fp)
lw $t0, -4($fp)
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
