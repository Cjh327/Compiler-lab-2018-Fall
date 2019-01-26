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
addi $sp, $sp, -80
addi $sp, $sp, -4
li $t0, 10
sw $t0, -84($fp)
addi $sp, $sp, -4
li $t0, 0
sw $t0, -88($fp)
label1:
lw $t0, -88($fp)
lw $t1, -84($fp)
bge $t0, $t1, label2
lw $t0, -88($fp)
li $t1, 8
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -92($fp)
lw $t0, -92($fp)
addi $sp, $sp, -4
addi $t1, $t0, 0
sw $t1, -96($fp)
la $t0, -80($fp)
lw $t1, -96($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -100($fp)
li $t0, 10
lw $t1, -100($fp)
sw $t0, 0($t1)
sw $t1, -100($fp)
lw $t0, -88($fp)
li $t1, 8
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -104($fp)
lw $t0, -104($fp)
addi $sp, $sp, -4
addi $t1, $t0, 4
sw $t1, -108($fp)
la $t0, -80($fp)
lw $t1, -108($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -112($fp)
lw $t0, -88($fp)
lw $t1, -112($fp)
sw $t0, 0($t1)
sw $t1, -112($fp)
lw $t0, -88($fp)
addi $t0, $t0, 1
sw $t0, -88($fp)
j label1
label2:
li $t0, 0
sw $t0, -88($fp)
addi $sp, $sp, -4
li $t0, 0
sw $t0, -116($fp)
label3:
lw $t0, -88($fp)
lw $t1, -84($fp)
bge $t0, $t1, label4
addi $sp, $sp, -4
li $t0, 0
sw $t0, -120($fp)
lw $t0, -88($fp)
li $t1, 8
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -124($fp)
lw $t0, -124($fp)
addi $sp, $sp, -4
addi $t1, $t0, 4
sw $t1, -128($fp)
la $t0, -80($fp)
lw $t1, -128($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -132($fp)
lw $t0, -116($fp)
lw $t1, -132($fp)
lw $t1, 0($t1)
add $t0, $t0, $t1
sw $t0, -116($fp)
label5:
lw $t0, -120($fp)
lw $t1, -84($fp)
bge $t0, $t1, label6
lw $t0, -88($fp)
li $t1, 8
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -136($fp)
lw $t0, -136($fp)
addi $sp, $sp, -4
addi $t1, $t0, 0
sw $t1, -140($fp)
la $t0, -80($fp)
lw $t1, -140($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -144($fp)
lw $t0, -88($fp)
li $t1, 8
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -148($fp)
lw $t0, -148($fp)
addi $sp, $sp, -4
addi $t1, $t0, 0
sw $t1, -152($fp)
la $t0, -80($fp)
lw $t1, -152($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -156($fp)
lw $t0, -120($fp)
li $t1, 8
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -160($fp)
lw $t0, -160($fp)
addi $sp, $sp, -4
addi $t1, $t0, 4
sw $t1, -164($fp)
la $t0, -80($fp)
lw $t1, -164($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -168($fp)
lw $t0, -116($fp)
lw $t1, -168($fp)
lw $t1, 0($t1)
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -172($fp)
lw $t0, -156($fp)
lw $t0, 0($t0)
lw $t1, -172($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -176($fp)
lw $t0, -176($fp)
lw $t1, -144($fp)
sw $t0, 0($t1)
sw $t1, -144($fp)
lw $t0, -120($fp)
addi $t0, $t0, 1
sw $t0, -120($fp)
j label5
label6:
lw $t0, -88($fp)
addi $t0, $t0, 1
sw $t0, -88($fp)
j label3
label4:
lw $t0, -84($fp)
addi $sp, $sp, -4
addi $t1, $t0, -1
sw $t1, -180($fp)
lw $t0, -180($fp)
li $t1, 8
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -184($fp)
lw $t0, -184($fp)
addi $sp, $sp, -4
addi $t1, $t0, 0
sw $t1, -188($fp)
la $t0, -80($fp)
lw $t1, -188($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -192($fp)
lw $t0, -192($fp)
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
