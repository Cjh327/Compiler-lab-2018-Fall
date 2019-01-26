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

search:
addi $sp, $sp, -4
sw $fp, 0($sp)
move $fp, $sp
addi, $sp, $sp, -40
addi $sp, $sp, -20
addi $sp, $sp, -4
li $t0, 0
sw $t0, -24($fp)
label1:
lw $t0, -24($fp)
li $t1, 5
bge $t0, $t1, label2
lw $t0, -24($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -28($fp)
la $t0, -20($fp)
lw $t1, -28($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -32($fp)
addi $sp, $sp, -4
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
lw $ra, 0($sp)
addi $sp, $sp, 4
move $t0, $v0
sw $t0, -36($fp)
lw $t0, -36($fp)
lw $t1, -32($fp)
sw $t0, 0($t1)
sw $t1, -32($fp)
lw $t0, -24($fp)
addi $t0, $t0, 1
sw $t0, -24($fp)
j label1
label2:
addi $sp, $sp, -4
li $t0, 0
sw $t0, -40($fp)
addi $sp, $sp, -4
li $t0, 4
sw $t0, -44($fp)
label3:
lw $t0, -40($fp)
lw $t1, -44($fp)
bgt $t0, $t1, label4
lw $t0, -40($fp)
lw $t1, -44($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -48($fp)
lw $t0, -48($fp)
li $t1, 2
div $t0, $t1
addi $sp, $sp, -4
mflo $t2
sw $t2, -52($fp)
lw $t0, -52($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -56($fp)
la $t0, -20($fp)
lw $t1, -56($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -60($fp)
lw $t0, -60($fp)
lw $t0, 0($t0)
addi $sp, $sp, -4
move $t1, $t0
sw $t1, -64($fp)
lw $t0, -64($fp)
lw $t1, 8($fp)
bne $t0, $t1, label5
lw $t0, -52($fp)
move $v0, $t0
move $sp, $fp
lw $fp, 0($sp)
addi $sp, $sp, 4
jr $ra
label5:
lw $t0, -40($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -68($fp)
la $t0, -20($fp)
lw $t1, -68($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -72($fp)
lw $t0, -64($fp)
lw $t1, -72($fp)
lw $t1, 0($t1)
ble $t0, $t1, label9
lw $t0, -40($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -76($fp)
la $t0, -20($fp)
lw $t1, -76($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -80($fp)
lw $t0, 8($fp)
lw $t1, -80($fp)
lw $t1, 0($t1)
blt $t0, $t1, label9
lw $t0, 8($fp)
lw $t1, -64($fp)
blt $t0, $t1, label8
label9:
lw $t0, -40($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -84($fp)
la $t0, -20($fp)
lw $t1, -84($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -88($fp)
lw $t0, -64($fp)
lw $t1, -88($fp)
lw $t1, 0($t1)
bge $t0, $t1, label6
lw $t0, -40($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -92($fp)
la $t0, -20($fp)
lw $t1, -92($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -96($fp)
lw $t0, 8($fp)
lw $t1, -96($fp)
lw $t1, 0($t1)
bge $t0, $t1, label10
lw $t0, 8($fp)
lw $t1, -64($fp)
bge $t0, $t1, label6
label10:
label8:
lw $t0, -52($fp)
addi $t1, $t0, -1
sw $t1, -44($fp)
j label7
label6:
lw $t0, -52($fp)
addi $t1, $t0, 1
sw $t1, -40($fp)
label7:
j label3
label4:
li $t0, -1
move $v0, $t0
move $sp, $fp
lw $fp, 0($sp)
addi $sp, $sp, 4
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
lw $t0, -4($fp)
addi $sp, $sp, -4
sw $t0, -8($fp)
addi $sp, $sp, -4
lw $t9, -8($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal search
lw $ra, 0($sp)
addi $sp, $sp, 4
addi $sp, $sp, -4
move $t0, $v0
sw $t0, -12($fp)
lw $t0, -12($fp)
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
