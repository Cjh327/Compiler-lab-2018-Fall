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

calculate:
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
li $t0, 50
sw $t0, -12($fp)
label1:
lw $t0, -8($fp)
lw $t1, -12($fp)
bge $t0, $t1, label2
lw $t0, -8($fp)
li $t1, 8
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -16($fp)
lw $t0, -16($fp)
addi $sp, $sp, -4
addi $t1, $t0, 4
sw $t1, -20($fp)
lw $t0, 8($fp)
lw $t1, -20($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -24($fp)
lw $t0, -4($fp)
lw $t1, -24($fp)
lw $t1, 0($t1)
add $t0, $t0, $t1
sw $t0, -4($fp)
lw $t0, -8($fp)
addi $t0, $t0, 1
sw $t0, -8($fp)
j label1
label2:
lw $t0, 8($fp)
addi $sp, $sp, -4
addi $t1, $t0, 400
sw $t1, -28($fp)
lw $t0, -4($fp)
lw $t1, -12($fp)
div $t0, $t1
addi $sp, $sp, -4
mflo $t2
sw $t2, -32($fp)
lw $t0, -32($fp)
lw $t1, -28($fp)
sw $t0, 0($t1)
sw $t1, -28($fp)
lw $t0, -4($fp)
lw $t1, -12($fp)
div $t0, $t1
addi $sp, $sp, -4
mflo $t2
sw $t2, -36($fp)
lw $t0, -36($fp)
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
addi $sp, $sp, -4040
addi $sp, $sp, -4
li $t0, 0
sw $t0, -4044($fp)
addi $sp, $sp, -4
li $t0, 0
sw $t0, -4048($fp)
addi $sp, $sp, -4
li $t0, 50
sw $t0, -4052($fp)
addi $sp, $sp, -4
li $t0, 10
sw $t0, -4056($fp)
label3:
lw $t0, -4044($fp)
lw $t1, -4056($fp)
bge $t0, $t1, label4
li $t0, 0
sw $t0, -4048($fp)
label5:
lw $t0, -4048($fp)
lw $t1, -4052($fp)
bge $t0, $t1, label6
lw $t0, -4044($fp)
li $t1, 404
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -4060($fp)
lw $t0, -4060($fp)
addi $sp, $sp, -4
addi $t1, $t0, 0
sw $t1, -4064($fp)
lw $t0, -4048($fp)
li $t1, 8
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -4068($fp)
lw $t0, -4064($fp)
lw $t1, -4068($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -4072($fp)
lw $t0, -4072($fp)
addi $sp, $sp, -4
addi $t1, $t0, 4
sw $t1, -4076($fp)
la $t0, -4040($fp)
lw $t1, -4076($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -4080($fp)
lw $t0, -4048($fp)
li $t1, 5
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -4084($fp)
lw $t0, -4044($fp)
lw $t1, -4084($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -4088($fp)
lw $t0, -4088($fp)
lw $t1, -4080($fp)
sw $t0, 0($t1)
sw $t1, -4080($fp)
lw $t0, -4048($fp)
addi $t0, $t0, 1
sw $t0, -4048($fp)
j label5
label6:
lw $t0, -4044($fp)
addi $t0, $t0, 1
sw $t0, -4044($fp)
j label3
label4:
li $t0, 0
sw $t0, -4048($fp)
li $t0, 0
sw $t0, -4044($fp)
label7:
lw $t0, -4044($fp)
lw $t1, -4056($fp)
bge $t0, $t1, label8
lw $t0, -4044($fp)
li $t1, 404
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -4092($fp)
la $t0, -4040($fp)
lw $t1, -4092($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -4096($fp)
lw $t0, -4096($fp)
addi $sp, $sp, -4
sw $t0, -4100($fp)
addi $sp, $sp, -4
lw $t9, -4100($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal calculate
lw $ra, 0($sp)
addi $sp, $sp, 4
addi $sp, $sp, -4
move $t0, $v0
sw $t0, -4104($fp)
lw $t0, -4048($fp)
lw $t1, -4104($fp)
add $t0, $t0, $t1
sw $t0, -4048($fp)
lw $t0, -4044($fp)
addi $t0, $t0, 1
sw $t0, -4044($fp)
j label7
label8:
lw $t0, -4048($fp)
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
