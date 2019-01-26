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

myPow:
addi $sp, $sp, -4
sw $fp, 0($sp)
move $fp, $sp
addi, $sp, $sp, -40
lw $t0, 12($fp)
li $t1, 0
bne $t0, $t1, label1
li $t0, 1
move $v0, $t0
move $sp, $fp
lw $fp, 0($sp)
addi $sp, $sp, 4
jr $ra
label1:
lw $t0, 12($fp)
li $t1, 1
bne $t0, $t1, label2
lw $t0, 8($fp)
move $v0, $t0
move $sp, $fp
lw $fp, 0($sp)
addi $sp, $sp, 4
jr $ra
label2:
lw $t0, 12($fp)
li $t1, 2
bne $t0, $t1, label3
lw $t0, 8($fp)
addi $sp, $sp, -4
mul $t1, $t0, $t0
sw $t1, -4($fp)
lw $t0, -4($fp)
move $v0, $t0
move $sp, $fp
lw $fp, 0($sp)
addi $sp, $sp, 4
jr $ra
label3:
lw $t0, 12($fp)
li $t1, 2
div $t0, $t1
addi $sp, $sp, -4
mflo $t2
sw $t2, -8($fp)
lw $t0, -8($fp)
li $t1, 2
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -12($fp)
lw $t0, 12($fp)
lw $t1, -12($fp)
bne $t0, $t1, label4
li $t0, 2
addi $sp, $sp, -4
sw $t0, -16($fp)
lw $t0, 12($fp)
li $t1, 2
div $t0, $t1
addi $sp, $sp, -4
mflo $t2
sw $t2, -20($fp)
lw $t0, -20($fp)
addi $sp, $sp, -4
sw $t0, -24($fp)
lw $t0, 8($fp)
addi $sp, $sp, -4
sw $t0, -28($fp)
addi $sp, $sp, -4
lw $t9, -24($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
lw $t9, -28($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal myPow
lw $ra, 0($sp)
addi $sp, $sp, 4
addi $sp, $sp, -4
move $t0, $v0
sw $t0, -32($fp)
lw $t0, -32($fp)
addi $sp, $sp, -4
sw $t0, -36($fp)
addi $sp, $sp, -4
lw $t9, -16($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
lw $t9, -36($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal myPow
lw $ra, 0($sp)
addi $sp, $sp, 4
addi $sp, $sp, -4
move $t0, $v0
sw $t0, -40($fp)
lw $t0, -40($fp)
move $v0, $t0
move $sp, $fp
lw $fp, 0($sp)
addi $sp, $sp, 4
jr $ra
j label5
label4:
li $t0, 2
addi $sp, $sp, -4
sw $t0, -44($fp)
lw $t0, 12($fp)
li $t1, 2
div $t0, $t1
addi $sp, $sp, -4
mflo $t2
sw $t2, -48($fp)
lw $t0, -48($fp)
addi $sp, $sp, -4
sw $t0, -52($fp)
lw $t0, 8($fp)
addi $sp, $sp, -4
sw $t0, -56($fp)
addi $sp, $sp, -4
lw $t9, -52($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
lw $t9, -56($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal myPow
lw $ra, 0($sp)
addi $sp, $sp, 4
addi $sp, $sp, -4
move $t0, $v0
sw $t0, -60($fp)
lw $t0, -60($fp)
addi $sp, $sp, -4
sw $t0, -64($fp)
addi $sp, $sp, -4
lw $t9, -44($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
lw $t9, -64($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal myPow
lw $ra, 0($sp)
addi $sp, $sp, 4
addi $sp, $sp, -4
move $t0, $v0
sw $t0, -68($fp)
lw $t0, 8($fp)
lw $t1, -68($fp)
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -72($fp)
lw $t0, -72($fp)
move $v0, $t0
move $sp, $fp
lw $fp, 0($sp)
addi $sp, $sp, 4
jr $ra
label5:

main:
addi $sp, $sp, -4
sw $fp, 0($sp)
move $fp, $sp
addi, $sp, $sp, -40
addi $sp, $sp, -4
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
lw $ra, 0($sp)
addi $sp, $sp, 4
move $t0, $v0
sw $t0, -4($fp)
addi $sp, $sp, -4
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
lw $ra, 0($sp)
addi $sp, $sp, 4
move $t0, $v0
sw $t0, -8($fp)
lw $t0, -8($fp)
addi $sp, $sp, -4
sw $t0, -12($fp)
lw $t0, -4($fp)
addi $sp, $sp, -4
sw $t0, -16($fp)
addi $sp, $sp, -4
lw $t9, -12($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
lw $t9, -16($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal myPow
lw $ra, 0($sp)
addi $sp, $sp, 4
addi $sp, $sp, -4
move $t0, $v0
sw $t0, -20($fp)
lw $t0, -20($fp)
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
