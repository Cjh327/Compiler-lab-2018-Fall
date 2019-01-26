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

process:
addi $sp, $sp, -4
sw $fp, 0($sp)
move $fp, $sp
addi, $sp, $sp, -40
addi $sp, $sp, -4
li $t0, 3
sw $t0, -4($fp)
li $t0, 36
sw $t0, -4($fp)
lw $t0, 8($fp)
li $t1, 321
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -8($fp)
lw $t0, -8($fp)
li $t1, 2
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -12($fp)
lw $t0, 8($fp)
lw $t1, -4($fp)
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -16($fp)
lw $t0, -12($fp)
lw $t1, -16($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -20($fp)
lw $t0, -20($fp)
lw $t1, 8($fp)
addi $sp, $sp, -4
sub $t2, $t0, $t1
sw $t2, -24($fp)
lw $t0, -4($fp)
lw $t1, 8($fp)
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -28($fp)
lw $t0, -24($fp)
lw $t1, -28($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -32($fp)
lw $t0, -4($fp)
addi $sp, $sp, -4
mul $t1, $t0, $t0
sw $t1, -36($fp)
lw $t0, -32($fp)
lw $t1, -36($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -40($fp)
lw $t0, -40($fp)
lw $t1, 8($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -44($fp)
lw $t0, -44($fp)
lw $t1, 8($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -48($fp)
lw $t0, -48($fp)
addi $sp, $sp, -4
addi $t1, $t0, -23
sw $t1, -52($fp)
lw $t0, -52($fp)
addi $t1, $t0, 45
sw $t1, -4($fp)
lw $t0, -4($fp)
li $t1, 3
div $t0, $t1
addi $sp, $sp, -4
mflo $t2
sw $t2, -56($fp)
lw $t0, -56($fp)
addi $sp, $sp, -4
addi $t1, $t0, 336
sw $t1, -60($fp)
lw $t0, 8($fp)
li $t1, 12
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -64($fp)
lw $t0, -64($fp)
li $t1, 4
div $t0, $t1
addi $sp, $sp, -4
mflo $t2
sw $t2, -68($fp)
lw $t0, -60($fp)
lw $t1, -68($fp)
addi $sp, $sp, -4
sub $t2, $t0, $t1
sw $t2, -72($fp)
lw $t0, -72($fp)
addi $sp, $sp, -4
addi $t1, $t0, -60
sw $t1, -76($fp)
lw $t0, -4($fp)
li $t1, 12
div $t0, $t1
addi $sp, $sp, -4
mflo $t2
sw $t2, -80($fp)
lw $t0, -80($fp)
li $t1, 24
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -84($fp)
lw $t0, -76($fp)
lw $t1, -84($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -88($fp)
lw $t0, -88($fp)
addi $sp, $sp, -4
addi $t1, $t0, 36
sw $t1, -92($fp)
lw $t0, -92($fp)
addi $t1, $t0, 1
sw $t1, -4($fp)
lw $t0, 8($fp)
addi $sp, $sp, -4
addi $t1, $t0, 24
sw $t1, -96($fp)
lw $t0, -96($fp)
addi $t1, $t0, 1
sw $t1, -4($fp)
lw $t0, -4($fp)
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
li $t0, 13
sw $t0, -4($fp)
addi $sp, $sp, -4
li $t0, 20
sw $t0, -8($fp)
addi $sp, $sp, -4
li $t0, 15
sw $t0, -12($fp)
lw $t0, -4($fp)
lw $t1, -8($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -16($fp)
lw $t0, -16($fp)
lw $t1, -12($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -20($fp)
lw $t0, -20($fp)
addi $sp, $sp, -4
move $t1, $t0
sw $t1, -24($fp)
lw $t0, -4($fp)
lw $t1, -8($fp)
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -28($fp)
lw $t0, -12($fp)
li $t1, 2
div $t0, $t1
addi $sp, $sp, -4
mflo $t2
sw $t2, -32($fp)
lw $t0, -28($fp)
lw $t1, -32($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -36($fp)
lw $t0, -36($fp)
addi $sp, $sp, -4
move $t1, $t0
sw $t1, -40($fp)
lw $t0, -4($fp)
lw $t1, -8($fp)
addi $sp, $sp, -4
sub $t2, $t0, $t1
sw $t2, -44($fp)
lw $t0, -44($fp)
lw $t1, -12($fp)
addi $sp, $sp, -4
sub $t2, $t0, $t1
sw $t2, -48($fp)
lw $t0, -48($fp)
addi $sp, $sp, -4
move $t1, $t0
sw $t1, -52($fp)
addi $sp, $sp, -4
li $t0, 42
sw $t0, -56($fp)
addi $sp, $sp, -4
li $t0, 0
sw $t0, -60($fp)
lw $t0, -4($fp)
lw $t1, -8($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -64($fp)
lw $t0, -64($fp)
lw $t1, -12($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -68($fp)
lw $t0, -68($fp)
addi $sp, $sp, -4
addi $t1, $t0, 2000
sw $t1, -72($fp)
lw $t0, -72($fp)
lw $t1, -52($fp)
sub $t1, $t0, $t1
sw $t1, -52($fp)
label1:
lw $t0, -4($fp)
lw $t1, -8($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -76($fp)
lw $t0, -76($fp)
lw $t1, -52($fp)
bge $t0, $t1, label2
lw $t0, -60($fp)
li $t1, 12
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -80($fp)
lw $t0, -56($fp)
lw $t1, -80($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -84($fp)
lw $t0, -84($fp)
addi $sp, $sp, -4
addi $t1, $t0, 4
sw $t1, -88($fp)
lw $t0, -88($fp)
addi $sp, $sp, -4
addi $t1, $t0, 5
sw $t1, -92($fp)
lw $t0, -92($fp)
addi $t1, $t0, 2
sw $t1, -56($fp)
lw $t0, -52($fp)
addi $sp, $sp, -4
sw $t0, -96($fp)
addi $sp, $sp, -4
lw $t9, -96($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal process
lw $ra, 0($sp)
addi $sp, $sp, 4
addi $sp, $sp, -4
move $t0, $v0
sw $t0, -100($fp)
li $t0, 2
lw $t1, -4($fp)
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -104($fp)
lw $t0, -100($fp)
lw $t1, -104($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -108($fp)
lw $t0, -108($fp)
lw $t1, -52($fp)
addi $sp, $sp, -4
sub $t2, $t0, $t1
sw $t2, -112($fp)
lw $t0, -12($fp)
lw $t1, -24($fp)
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -116($fp)
lw $t0, -112($fp)
lw $t1, -116($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -120($fp)
lw $t0, -60($fp)
add $t0, $t0, $t0
sw $t0, -60($fp)
lw $t0, -60($fp)
add $t0, $t0, $t0
sw $t0, -60($fp)
lw $t0, -60($fp)
add $t0, $t0, $t0
sw $t0, -60($fp)
lw $t0, -60($fp)
add $t0, $t0, $t0
sw $t0, -60($fp)
lw $t0, -60($fp)
add $t0, $t0, $t0
sw $t0, -60($fp)
lw $t0, -60($fp)
addi $sp, $sp, -4
addi $t1, $t0, 3
sw $t1, -124($fp)
lw $t0, -124($fp)
addi $t0, $t0, -1
sw $t0, -124($fp)
lw $t0, -124($fp)
addi $t0, $t0, 3
sw $t0, -124($fp)
lw $t0, -124($fp)
addi $t0, $t0, -6
sw $t0, -124($fp)
lw $t0, -4($fp)
addi $sp, $sp, -4
sw $t0, -128($fp)
addi $sp, $sp, -4
lw $t9, -128($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal process
lw $ra, 0($sp)
addi $sp, $sp, 4
addi $sp, $sp, -4
move $t0, $v0
sw $t0, -132($fp)
lw $t0, -4($fp)
addi $sp, $sp, -4
addi $t1, $t0, 3
sw $t1, -136($fp)
lw $t0, -136($fp)
addi $sp, $sp, -4
addi $t1, $t0, -2
sw $t1, -140($fp)
lw $t0, -140($fp)
addi $sp, $sp, -4
addi $t1, $t0, -1
sw $t1, -144($fp)
lw $t0, -144($fp)
addi $sp, $sp, -4
sw $t0, -148($fp)
addi $sp, $sp, -4
lw $t9, -148($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal process
lw $ra, 0($sp)
addi $sp, $sp, 4
addi $sp, $sp, -4
move $t0, $v0
sw $t0, -152($fp)
lw $t0, -132($fp)
lw $t1, -152($fp)
bne $t0, $t1, label3
lw $t0, -52($fp)
addi $sp, $sp, -4
addi $t1, $t0, -2
sw $t1, -156($fp)
lw $t0, -156($fp)
addi $t1, $t0, 1
sw $t1, -52($fp)
label3:
lw $t0, -4($fp)
addi $sp, $sp, -4
addi $t1, $t0, 2
sw $t1, -160($fp)
lw $t0, -160($fp)
addi $t1, $t0, 1
sw $t1, -4($fp)
j label1
label2:
lw $t0, -56($fp)
addi $t1, $t0, -12
sw $t1, -124($fp)
label4:
lw $t0, -124($fp)
lw $t1, -56($fp)
bge $t0, $t1, label5
lw $t0, -4($fp)
addi $t1, $t0, 58
sw $t1, -52($fp)
lw $t0, -56($fp)
addi $t1, $t0, -12
sw $t1, -120($fp)
lw $t0, -124($fp)
addi $t0, $t0, 1
sw $t0, -124($fp)
lw $t0, -56($fp)
move $t1, $t0
sw $t1, -120($fp)
lw $t0, -4($fp)
lw $t1, -8($fp)
add $t2, $t0, $t1
sw $t2, -60($fp)
lw $t0, -4($fp)
lw $t1, -8($fp)
add $t2, $t0, $t1
sw $t2, -12($fp)
j label4
label5:
lw $t0, -52($fp)
move $a0, $t0
addi $sp, $sp, -4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t0, -4($fp)
lw $t1, -8($fp)
add $t0, $t0, $t1
sw $t0, -4($fp)
lw $t0, -4($fp)
lw $t1, -8($fp)
add $t1, $t0, $t1
sw $t1, -8($fp)
lw $t0, -4($fp)
lw $t1, -8($fp)
add $t2, $t0, $t1
sw $t2, -12($fp)
lw $t0, -4($fp)
lw $t1, -8($fp)
add $t2, $t0, $t1
sw $t2, -52($fp)
lw $t0, -4($fp)
lw $t1, -8($fp)
add $t2, $t0, $t1
sw $t2, -120($fp)
lw $t0, -12($fp)
lw $t1, -52($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -164($fp)
lw $t0, -164($fp)
lw $t1, -120($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -168($fp)
lw $t0, -168($fp)
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
