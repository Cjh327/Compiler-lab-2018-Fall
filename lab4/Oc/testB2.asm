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

countSort:
addi $sp, $sp, -4
sw $fp, 0($sp)
move $fp, $sp
addi, $sp, $sp, -40
addi $sp, $sp, -20
addi $sp, $sp, -40
addi $sp, $sp, -20
addi $sp, $sp, -4
li $t0, 0
sw $t0, -84($fp)
label1:
lw $t0, -84($fp)
li $t1, 10
bge $t0, $t1, label2
lw $t0, -84($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -88($fp)
la $t0, -60($fp)
lw $t1, -88($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -92($fp)
li $t0, 0
lw $t1, -92($fp)
sw $t0, 0($t1)
sw $t1, -92($fp)
lw $t0, -84($fp)
addi $t0, $t0, 1
sw $t0, -84($fp)
j label1
label2:
li $t0, 0
sw $t0, -84($fp)
label3:
lw $t0, -84($fp)
li $t1, 5
bge $t0, $t1, label4
lw $t0, -84($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -96($fp)
la $t0, -20($fp)
lw $t1, -96($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -100($fp)
addi $sp, $sp, -4
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
lw $ra, 0($sp)
addi $sp, $sp, 4
move $t0, $v0
sw $t0, -104($fp)
lw $t0, -104($fp)
lw $t1, -100($fp)
sw $t0, 0($t1)
sw $t1, -100($fp)
lw $t0, -84($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -108($fp)
la $t0, -20($fp)
lw $t1, -108($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -112($fp)
lw $t0, -112($fp)
lw $t0, 0($t0)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -116($fp)
la $t0, -60($fp)
lw $t1, -116($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -120($fp)
lw $t0, -84($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -124($fp)
la $t0, -20($fp)
lw $t1, -124($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -128($fp)
lw $t0, -128($fp)
lw $t0, 0($t0)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -132($fp)
la $t0, -60($fp)
lw $t1, -132($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -136($fp)
lw $t0, -136($fp)
lw $t0, 0($t0)
addi $sp, $sp, -4
addi $t1, $t0, 1
sw $t1, -140($fp)
lw $t0, -140($fp)
lw $t1, -120($fp)
sw $t0, 0($t1)
sw $t1, -120($fp)
lw $t0, -84($fp)
addi $t0, $t0, 1
sw $t0, -84($fp)
j label3
label4:
li $t0, 1
sw $t0, -84($fp)
label5:
lw $t0, -84($fp)
li $t1, 10
bge $t0, $t1, label6
lw $t0, -84($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -144($fp)
la $t0, -60($fp)
lw $t1, -144($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -148($fp)
lw $t0, -84($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -152($fp)
la $t0, -60($fp)
lw $t1, -152($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -156($fp)
lw $t0, -84($fp)
addi $sp, $sp, -4
addi $t1, $t0, -1
sw $t1, -160($fp)
lw $t0, -160($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -164($fp)
la $t0, -60($fp)
lw $t1, -164($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -168($fp)
lw $t0, -156($fp)
lw $t0, 0($t0)
lw $t1, -168($fp)
lw $t1, 0($t1)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -172($fp)
lw $t0, -172($fp)
lw $t1, -148($fp)
sw $t0, 0($t1)
sw $t1, -148($fp)
lw $t0, -84($fp)
addi $t0, $t0, 1
sw $t0, -84($fp)
j label5
label6:
li $t0, 0
sw $t0, -84($fp)
label7:
lw $t0, -84($fp)
li $t1, 5
bge $t0, $t1, label8
lw $t0, -84($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -176($fp)
la $t0, -20($fp)
lw $t1, -176($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -180($fp)
lw $t0, -180($fp)
lw $t0, 0($t0)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -184($fp)
la $t0, -60($fp)
lw $t1, -184($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -188($fp)
lw $t0, -188($fp)
lw $t0, 0($t0)
addi $sp, $sp, -4
addi $t1, $t0, -1
sw $t1, -192($fp)
lw $t0, -192($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -196($fp)
la $t0, -80($fp)
lw $t1, -196($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -200($fp)
lw $t0, -84($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -204($fp)
la $t0, -20($fp)
lw $t1, -204($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -208($fp)
lw $t0, -208($fp)
lw $t0, 0($t0)
lw $t1, -200($fp)
sw $t0, 0($t1)
sw $t1, -200($fp)
lw $t0, -84($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -212($fp)
la $t0, -20($fp)
lw $t1, -212($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -216($fp)
lw $t0, -216($fp)
lw $t0, 0($t0)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -220($fp)
la $t0, -60($fp)
lw $t1, -220($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -224($fp)
lw $t0, -84($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -228($fp)
la $t0, -20($fp)
lw $t1, -228($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -232($fp)
lw $t0, -232($fp)
lw $t0, 0($t0)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -236($fp)
la $t0, -60($fp)
lw $t1, -236($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -240($fp)
lw $t0, -240($fp)
lw $t0, 0($t0)
addi $sp, $sp, -4
addi $t1, $t0, -1
sw $t1, -244($fp)
lw $t0, -244($fp)
lw $t1, -224($fp)
sw $t0, 0($t1)
sw $t1, -224($fp)
lw $t0, -84($fp)
addi $t0, $t0, 1
sw $t0, -84($fp)
j label7
label8:
li $t0, 0
sw $t0, -84($fp)
label9:
lw $t0, -84($fp)
li $t1, 5
bge $t0, $t1, label10
lw $t0, -84($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -248($fp)
la $t0, -80($fp)
lw $t1, -248($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -252($fp)
lw $t0, -252($fp)
lw $t0, 0($t0)
move $a0, $t0
addi $sp, $sp, -4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t0, -84($fp)
addi $t0, $t0, 1
sw $t0, -84($fp)
j label9
label10:
li $t0, 0
move $v0, $t0
move $sp, $fp
lw $fp, 0($sp)
addi $sp, $sp, 4
jr $ra

bubbleSort:
addi $sp, $sp, -4
sw $fp, 0($sp)
move $fp, $sp
addi, $sp, $sp, -40
addi $sp, $sp, -20
addi $sp, $sp, -4
li $t0, 0
sw $t0, -24($fp)
label11:
lw $t0, -24($fp)
li $t1, 5
bge $t0, $t1, label12
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
j label11
label12:
addi $sp, $sp, -4
li $t0, 1
sw $t0, -40($fp)
label13:
lw $t0, -40($fp)
li $t1, 1
bne $t0, $t1, label14
li $t0, 0
sw $t0, -40($fp)
li $t0, 1
sw $t0, -24($fp)
label15:
lw $t0, -24($fp)
li $t1, 5
bge $t0, $t1, label16
lw $t0, -24($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -44($fp)
la $t0, -20($fp)
lw $t1, -44($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -48($fp)
lw $t0, -24($fp)
addi $sp, $sp, -4
addi $t1, $t0, -1
sw $t1, -52($fp)
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
lw $t0, -48($fp)
lw $t0, 0($t0)
lw $t1, -60($fp)
lw $t1, 0($t1)
bge $t0, $t1, label17
li $t0, 1
sw $t0, -40($fp)
lw $t0, -24($fp)
addi $sp, $sp, -4
addi $t1, $t0, -1
sw $t1, -64($fp)
lw $t0, -64($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -68($fp)
la $t0, -20($fp)
lw $t1, -68($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -72($fp)
lw $t0, -72($fp)
lw $t0, 0($t0)
addi $sp, $sp, -4
move $t1, $t0
sw $t1, -76($fp)
lw $t0, -24($fp)
addi $sp, $sp, -4
addi $t1, $t0, -1
sw $t1, -80($fp)
lw $t0, -80($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -84($fp)
la $t0, -20($fp)
lw $t1, -84($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -88($fp)
lw $t0, -24($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -92($fp)
la $t0, -20($fp)
lw $t1, -92($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -96($fp)
lw $t0, -96($fp)
lw $t0, 0($t0)
lw $t1, -88($fp)
sw $t0, 0($t1)
sw $t1, -88($fp)
lw $t0, -24($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -100($fp)
la $t0, -20($fp)
lw $t1, -100($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -104($fp)
lw $t0, -76($fp)
lw $t1, -104($fp)
sw $t0, 0($t1)
sw $t1, -104($fp)
label17:
lw $t0, -24($fp)
addi $t0, $t0, 1
sw $t0, -24($fp)
j label15
label16:
j label13
label14:
li $t0, 0
sw $t0, -24($fp)
label18:
lw $t0, -24($fp)
li $t1, 5
bge $t0, $t1, label19
lw $t0, -24($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -108($fp)
la $t0, -20($fp)
lw $t1, -108($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -112($fp)
lw $t0, -112($fp)
lw $t0, 0($t0)
move $a0, $t0
addi $sp, $sp, -4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t0, -24($fp)
addi $t0, $t0, 1
sw $t0, -24($fp)
j label18
label19:
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
addi $sp, $sp, -4
sw $ra, 0($sp)
jal countSort
lw $ra, 0($sp)
addi $sp, $sp, 4
addi $sp, $sp, -4
move $t0, $v0
sw $t0, -4($fp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal bubbleSort
lw $ra, 0($sp)
addi $sp, $sp, 4
addi $sp, $sp, -4
move $t0, $v0
sw $t0, -8($fp)
li $t0, 0
move $v0, $t0
move $sp, $fp
lw $fp, 0($sp)
addi $sp, $sp, 4
jr $ra
