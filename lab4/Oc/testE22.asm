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

qsort:
addi $sp, $sp, -4
sw $fp, 0($sp)
move $fp, $sp
addi, $sp, $sp, -40
lw $t0, 12($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -4($fp)
lw $t0, 8($fp)
lw $t1, -4($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -8($fp)
lw $t0, -8($fp)
lw $t0, 0($t0)
addi $sp, $sp, -4
move $t1, $t0
sw $t1, -12($fp)
lw $t0, 12($fp)
addi $sp, $sp, -4
move $t1, $t0
sw $t1, -16($fp)
lw $t0, 16($fp)
addi $sp, $sp, -4
move $t1, $t0
sw $t1, -20($fp)
lw $t0, -16($fp)
lw $t1, -20($fp)
bge $t0, $t1, label1
label2:
lw $t0, -16($fp)
lw $t1, -20($fp)
bge $t0, $t1, label3
label4:
lw $t0, -16($fp)
lw $t1, -20($fp)
bge $t0, $t1, label5
lw $t0, -20($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -24($fp)
lw $t0, 8($fp)
lw $t1, -24($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -28($fp)
lw $t0, -28($fp)
lw $t0, 0($t0)
lw $t1, -12($fp)
ble $t0, $t1, label5
lw $t0, -20($fp)
addi $t0, $t0, -1
sw $t0, -20($fp)
j label4
label5:
lw $t0, -16($fp)
lw $t1, -20($fp)
bge $t0, $t1, label6
lw $t0, -16($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -32($fp)
lw $t0, 8($fp)
lw $t1, -32($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -36($fp)
lw $t0, -20($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -40($fp)
lw $t0, 8($fp)
lw $t1, -40($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -44($fp)
lw $t0, -44($fp)
lw $t0, 0($t0)
lw $t1, -36($fp)
sw $t0, 0($t1)
sw $t1, -36($fp)
lw $t0, -16($fp)
addi $t0, $t0, 1
sw $t0, -16($fp)
label6:
label7:
lw $t0, -16($fp)
lw $t1, -20($fp)
bge $t0, $t1, label8
lw $t0, -16($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -48($fp)
lw $t0, 8($fp)
lw $t1, -48($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -52($fp)
lw $t0, -52($fp)
lw $t0, 0($t0)
lw $t1, -12($fp)
bge $t0, $t1, label8
lw $t0, -16($fp)
addi $t0, $t0, 1
sw $t0, -16($fp)
j label7
label8:
lw $t0, -16($fp)
lw $t1, -20($fp)
bge $t0, $t1, label9
lw $t0, -20($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -56($fp)
lw $t0, 8($fp)
lw $t1, -56($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -60($fp)
lw $t0, -16($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -64($fp)
lw $t0, 8($fp)
lw $t1, -64($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -68($fp)
lw $t0, -68($fp)
lw $t0, 0($t0)
lw $t1, -60($fp)
sw $t0, 0($t1)
sw $t1, -60($fp)
lw $t0, -20($fp)
addi $t0, $t0, -1
sw $t0, -20($fp)
label9:
j label2
label3:
lw $t0, -16($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -72($fp)
lw $t0, 8($fp)
lw $t1, -72($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -76($fp)
lw $t0, -12($fp)
lw $t1, -76($fp)
sw $t0, 0($t1)
sw $t1, -76($fp)
lw $t0, -16($fp)
addi $sp, $sp, -4
addi $t1, $t0, -1
sw $t1, -80($fp)
lw $t0, -80($fp)
addi $sp, $sp, -4
sw $t0, -84($fp)
lw $t0, 12($fp)
addi $sp, $sp, -4
sw $t0, -88($fp)
lw $t0, 8($fp)
addi $sp, $sp, -4
sw $t0, -92($fp)
addi $sp, $sp, -4
lw $t9, -84($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
lw $t9, -88($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
lw $t9, -92($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal qsort
lw $ra, 0($sp)
addi $sp, $sp, 4
addi $sp, $sp, -4
move $t0, $v0
sw $t0, -96($fp)
lw $t0, 16($fp)
addi $sp, $sp, -4
sw $t0, -100($fp)
lw $t0, -16($fp)
addi $sp, $sp, -4
addi $t1, $t0, 1
sw $t1, -104($fp)
lw $t0, -104($fp)
addi $sp, $sp, -4
sw $t0, -108($fp)
lw $t0, 8($fp)
addi $sp, $sp, -4
sw $t0, -112($fp)
addi $sp, $sp, -4
lw $t9, -100($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
lw $t9, -108($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
lw $t9, -112($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal qsort
lw $ra, 0($sp)
addi $sp, $sp, 4
addi $sp, $sp, -4
move $t0, $v0
sw $t0, -116($fp)
label1:
li $t0, 0
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
addi $sp, $sp, -40
addi $sp, $sp, -4
li $t0, 10
sw $t0, -44($fp)
addi $sp, $sp, -4
li $t0, 0
sw $t0, -48($fp)
label10:
lw $t0, -48($fp)
lw $t1, -44($fp)
bge $t0, $t1, label11
lw $t0, -48($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -52($fp)
la $t0, -40($fp)
lw $t1, -52($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -56($fp)
addi $sp, $sp, -4
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
lw $ra, 0($sp)
addi $sp, $sp, 4
move $t0, $v0
sw $t0, -60($fp)
lw $t0, -60($fp)
lw $t1, -56($fp)
sw $t0, 0($t1)
sw $t1, -56($fp)
lw $t0, -48($fp)
addi $t0, $t0, 1
sw $t0, -48($fp)
j label10
label11:
lw $t0, -44($fp)
addi $sp, $sp, -4
addi $t1, $t0, -1
sw $t1, -64($fp)
lw $t0, -64($fp)
addi $sp, $sp, -4
sw $t0, -68($fp)
li $t0, 0
addi $sp, $sp, -4
sw $t0, -72($fp)
la $t0, -40($fp)
addi $sp, $sp, -4
sw $t0, -76($fp)
addi $sp, $sp, -4
lw $t9, -68($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
lw $t9, -72($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
lw $t9, -76($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal qsort
lw $ra, 0($sp)
addi $sp, $sp, 4
addi $sp, $sp, -4
move $t0, $v0
sw $t0, -80($fp)
li $t0, 0
sw $t0, -48($fp)
label12:
lw $t0, -48($fp)
lw $t1, -44($fp)
bge $t0, $t1, label13
lw $t0, -48($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -84($fp)
la $t0, -40($fp)
lw $t1, -84($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -88($fp)
lw $t0, -88($fp)
lw $t0, 0($t0)
move $a0, $t0
addi $sp, $sp, -4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t0, -48($fp)
addi $t0, $t0, 1
sw $t0, -48($fp)
j label12
label13:
li $t0, 0
move $v0, $t0
move $sp, $fp
lw $fp, 0($sp)
addi $sp, $sp, 4
jr $ra
