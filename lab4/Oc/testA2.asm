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
lw $t0, -4($fp)
li $t1, 100
ble $t0, $t1, label1
lw $t0, -8($fp)
li $t1, 50
bge $t0, $t1, label3
lw $t0, -8($fp)
lw $t1, -4($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -12($fp)
lw $t0, -12($fp)
move $a0, $t0
addi $sp, $sp, -4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
j label4
label3:
lw $t0, -8($fp)
lw $t1, -4($fp)
addi $sp, $sp, -4
sub $t2, $t0, $t1
sw $t2, -16($fp)
lw $t0, -16($fp)
move $a0, $t0
addi $sp, $sp, -4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
label4:
j label2
label1:
lw $t0, -4($fp)
li $t1, 100
bne $t0, $t1, label5
lw $t0, -8($fp)
li $t1, 100
bge $t0, $t1, label7
lw $t0, -8($fp)
move $a0, $t0
addi $sp, $sp, -4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
j label8
label7:
lw $t0, -8($fp)
addi $sp, $sp, -4
addi $t1, $t0, -100
sw $t1, -20($fp)
lw $t0, -20($fp)
move $a0, $t0
addi $sp, $sp, -4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
label8:
j label6
label5:
lw $t0, -4($fp)
li $t1, 100
bge $t0, $t1, label9
lw $t0, -8($fp)
lw $t1, -4($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -24($fp)
lw $t0, -24($fp)
li $t1, 100
ble $t0, $t1, label10
lw $t0, -4($fp)
addi $sp, $sp, -4
addi $t1, $t0, 100
sw $t1, -28($fp)
lw $t0, -28($fp)
move $a0, $t0
addi $sp, $sp, -4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
j label11
label10:
li $t0, 100
move $a0, $t0
addi $sp, $sp, -4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
label11:
label9:
label6:
label2:
lw $t0, -4($fp)
lw $t1, -8($fp)
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
