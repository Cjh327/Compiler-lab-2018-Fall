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
li $t1, 2
div $t0, $t1
addi $sp, $sp, -4
mflo $t2
sw $t2, -12($fp)
lw $t0, -12($fp)
li $t1, 2
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -16($fp)
lw $t0, -8($fp)
lw $t1, -16($fp)
bne $t0, $t1, label1
addi $sp, $sp, -4
li $t0, 1
sw $t0, -20($fp)
j label2
label1:
lw $t0, -4($fp)
move $t1, $t0
sw $t1, -20($fp)
label2:
lw $t0, -8($fp)
li $t1, 2
div $t0, $t1
mflo $t0
sw $t0, -8($fp)
label3:
lw $t0, -8($fp)
li $t1, 0
ble $t0, $t1, label4
lw $t0, -4($fp)
mul $t0, $t0, $t0
sw $t0, -4($fp)
lw $t0, -8($fp)
li $t1, 2
div $t0, $t1
addi $sp, $sp, -4
mflo $t2
sw $t2, -24($fp)
lw $t0, -24($fp)
li $t1, 2
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -28($fp)
lw $t0, -8($fp)
lw $t1, -28($fp)
beq $t0, $t1, label5
lw $t0, -20($fp)
lw $t1, -4($fp)
mul $t0, $t0, $t1
sw $t0, -20($fp)
label5:
lw $t0, -8($fp)
li $t1, 2
div $t0, $t1
mflo $t0
sw $t0, -8($fp)
j label3
label4:
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
