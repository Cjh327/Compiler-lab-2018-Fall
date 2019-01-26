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

trap:
addi $sp, $sp, -4
sw $fp, 0($sp)
move $fp, $sp
addi, $sp, $sp, -40
addi $sp, $sp, -4
li $t0, 0
sw $t0, -4($fp)
addi $sp, $sp, -4
li $t0, 0
sw $t0, -8($fp)
addi $sp, $sp, -4
li $t0, 0
sw $t0, -12($fp)
addi $sp, $sp, -4
li $t0, 0
sw $t0, -16($fp)
addi $sp, $sp, -4
li $t0, 0
sw $t0, -20($fp)
addi $sp, $sp, -4
li $t0, 12
sw $t0, -24($fp)
addi $sp, $sp, -4
li $t0, 0
sw $t0, -28($fp)
addi $sp, $sp, -48
label1:
lw $t0, -12($fp)
lw $t1, -24($fp)
bge $t0, $t1, label2
lw $t0, -12($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -80($fp)
la $t0, -76($fp)
lw $t1, -80($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -84($fp)
addi $sp, $sp, -4
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
lw $ra, 0($sp)
addi $sp, $sp, 4
move $t0, $v0
sw $t0, -88($fp)
lw $t0, -88($fp)
lw $t1, -84($fp)
sw $t0, 0($t1)
sw $t1, -84($fp)
lw $t0, -12($fp)
addi $t0, $t0, 1
sw $t0, -12($fp)
j label1
label2:
li $t0, 0
sw $t0, -12($fp)
label3:
lw $t0, -12($fp)
lw $t1, -24($fp)
bge $t0, $t1, label4
lw $t0, -12($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -92($fp)
la $t0, -76($fp)
lw $t1, -92($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -96($fp)
lw $t0, -96($fp)
lw $t0, 0($t0)
li $t1, 0
bne $t0, $t1, label4
lw $t0, -12($fp)
addi $t0, $t0, 1
sw $t0, -12($fp)
j label3
label4:
lw $t0, -12($fp)
lw $t1, -24($fp)
blt $t0, $t1, label5
li $t0, 0
move $v0, $t0
move $sp, $fp
lw $fp, 0($sp)
addi $sp, $sp, 4
jr $ra
label5:
lw $t0, -12($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -100($fp)
la $t0, -76($fp)
lw $t1, -100($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -104($fp)
lw $t0, -104($fp)
lw $t0, 0($t0)
move $t1, $t0
sw $t1, -4($fp)
lw $t0, -12($fp)
move $t1, $t0
sw $t1, -8($fp)
li $t0, 0
sw $t0, -20($fp)
lw $t0, -12($fp)
addi $t0, $t0, 1
sw $t0, -12($fp)
label6:
lw $t0, -12($fp)
lw $t1, -24($fp)
bge $t0, $t1, label7
lw $t0, -12($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -108($fp)
la $t0, -76($fp)
lw $t1, -108($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -112($fp)
lw $t0, -112($fp)
lw $t0, 0($t0)
lw $t1, -4($fp)
bge $t0, $t1, label8
lw $t0, -12($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -116($fp)
la $t0, -76($fp)
lw $t1, -116($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -120($fp)
lw $t0, -4($fp)
lw $t1, -120($fp)
lw $t1, 0($t1)
addi $sp, $sp, -4
sub $t2, $t0, $t1
sw $t2, -124($fp)
lw $t0, -20($fp)
lw $t1, -124($fp)
add $t0, $t0, $t1
sw $t0, -20($fp)
j label9
label8:
lw $t0, -16($fp)
lw $t1, -20($fp)
add $t0, $t0, $t1
sw $t0, -16($fp)
lw $t0, -12($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -128($fp)
la $t0, -76($fp)
lw $t1, -128($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -132($fp)
lw $t0, -132($fp)
lw $t0, 0($t0)
move $t1, $t0
sw $t1, -4($fp)
lw $t0, -12($fp)
move $t1, $t0
sw $t1, -8($fp)
li $t0, 0
sw $t0, -20($fp)
label9:
lw $t0, -12($fp)
addi $t0, $t0, 1
sw $t0, -12($fp)
j label6
label7:
li $t0, 0
sw $t0, -20($fp)
li $t0, 0
sw $t0, -28($fp)
lw $t0, -24($fp)
addi $t1, $t0, -1
sw $t1, -12($fp)
label10:
lw $t0, -12($fp)
lw $t1, -8($fp)
ble $t0, $t1, label11
lw $t0, -12($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -136($fp)
la $t0, -76($fp)
lw $t1, -136($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -140($fp)
lw $t0, -140($fp)
lw $t0, 0($t0)
li $t1, 0
bne $t0, $t1, label11
lw $t0, -12($fp)
addi $t0, $t0, -1
sw $t0, -12($fp)
j label10
label11:
lw $t0, -12($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -144($fp)
la $t0, -76($fp)
lw $t1, -144($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -148($fp)
lw $t0, -148($fp)
lw $t0, 0($t0)
move $t1, $t0
sw $t1, -28($fp)
lw $t0, -12($fp)
addi $t0, $t0, -1
sw $t0, -12($fp)
label12:
lw $t0, -12($fp)
lw $t1, -8($fp)
ble $t0, $t1, label13
lw $t0, -12($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -152($fp)
la $t0, -76($fp)
lw $t1, -152($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -156($fp)
lw $t0, -156($fp)
lw $t0, 0($t0)
lw $t1, -28($fp)
bge $t0, $t1, label14
lw $t0, -12($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -160($fp)
la $t0, -76($fp)
lw $t1, -160($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -164($fp)
lw $t0, -28($fp)
lw $t1, -164($fp)
lw $t1, 0($t1)
addi $sp, $sp, -4
sub $t2, $t0, $t1
sw $t2, -168($fp)
lw $t0, -20($fp)
lw $t1, -168($fp)
add $t0, $t0, $t1
sw $t0, -20($fp)
j label15
label14:
lw $t0, -16($fp)
lw $t1, -20($fp)
add $t0, $t0, $t1
sw $t0, -16($fp)
lw $t0, -12($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -172($fp)
la $t0, -76($fp)
lw $t1, -172($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -176($fp)
lw $t0, -176($fp)
lw $t0, 0($t0)
move $t1, $t0
sw $t1, -28($fp)
li $t0, 0
sw $t0, -20($fp)
label15:
lw $t0, -12($fp)
addi $t0, $t0, -1
sw $t0, -12($fp)
j label12
label13:
lw $t0, -16($fp)
lw $t1, -20($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -180($fp)
lw $t0, -180($fp)
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
sw $ra, 0($sp)
jal trap
lw $ra, 0($sp)
addi $sp, $sp, 4
addi $sp, $sp, -4
move $t0, $v0
sw $t0, -4($fp)
lw $t0, -4($fp)
addi $sp, $sp, -4
move $t1, $t0
sw $t1, -8($fp)
lw $t0, -8($fp)
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
