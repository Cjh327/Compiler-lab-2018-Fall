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

display:
addi $sp, $sp, -4
sw $fp, 0($sp)
move $fp, $sp
addi, $sp, $sp, -40
addi $sp, $sp, -400
addi $sp, $sp, -4
li $t0, 0
sw $t0, -404($fp)
addi $sp, $sp, -4
li $t0, 0
sw $t0, -408($fp)
addi $sp, $sp, -4
li $t0, 1
sw $t0, -412($fp)
lw $t0, 12($fp)
addi $sp, $sp, -4
addi $t1, $t0, 0
sw $t1, -416($fp)
lw $t0, -416($fp)
lw $t0, 0($t0)
li $t1, 1
bne $t0, $t1, label1
label2:
lw $t0, -404($fp)
lw $t1, 16($fp)
bge $t0, $t1, label3
li $t0, 0
sw $t0, -408($fp)
li $t0, 1
sw $t0, -412($fp)
label4:
lw $t0, -408($fp)
lw $t1, 16($fp)
bge $t0, $t1, label5
lw $t0, -404($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -420($fp)
lw $t0, 8($fp)
lw $t1, -420($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -424($fp)
lw $t0, -408($fp)
lw $t1, -424($fp)
lw $t1, 0($t1)
bne $t0, $t1, label6
lw $t0, -404($fp)
li $t1, 40
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -428($fp)
lw $t0, -408($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -432($fp)
lw $t0, -428($fp)
lw $t1, -432($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -436($fp)
la $t0, -400($fp)
lw $t1, -436($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -440($fp)
li $t0, 1
lw $t1, -440($fp)
sw $t0, 0($t1)
sw $t1, -440($fp)
lw $t0, -412($fp)
li $t1, 10
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -444($fp)
lw $t0, -444($fp)
addi $t1, $t0, 1
sw $t1, -412($fp)
j label7
label6:
lw $t0, -404($fp)
li $t1, 40
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -448($fp)
lw $t0, -408($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -452($fp)
lw $t0, -448($fp)
lw $t1, -452($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -456($fp)
la $t0, -400($fp)
lw $t1, -456($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -460($fp)
li $t0, 0
lw $t1, -460($fp)
sw $t0, 0($t1)
sw $t1, -460($fp)
lw $t0, -412($fp)
li $t1, 10
mul $t0, $t0, $t1
sw $t0, -412($fp)
label7:
lw $t0, -408($fp)
addi $t0, $t0, 1
sw $t0, -408($fp)
j label4
label5:
lw $t0, -412($fp)
move $a0, $t0
addi $sp, $sp, -4
sw $ra, 0($sp)
jal write
lw $ra, 0($sp)
addi $sp, $sp, 4
lw $t0, -404($fp)
addi $t0, $t0, 1
sw $t0, -404($fp)
j label2
label3:
label1:
li $t0, 0
move $v0, $t0
move $sp, $fp
lw $fp, 0($sp)
addi $sp, $sp, 4
jr $ra

dfs:
addi $sp, $sp, -4
sw $fp, 0($sp)
move $fp, $sp
addi, $sp, $sp, -40
addi $sp, $sp, -4
li $t0, 0
sw $t0, -4($fp)
addi $sp, $sp, -40
addi $sp, $sp, -40
lw $t0, 24($fp)
lw $t1, 28($fp)
bne $t0, $t1, label8
lw $t0, 32($fp)
addi $sp, $sp, -4
addi $t1, $t0, 0
sw $t1, -88($fp)
lw $t0, 32($fp)
addi $sp, $sp, -4
addi $t1, $t0, 0
sw $t1, -92($fp)
lw $t0, -92($fp)
lw $t0, 0($t0)
addi $sp, $sp, -4
addi $t1, $t0, 1
sw $t1, -96($fp)
lw $t0, -96($fp)
lw $t1, -88($fp)
sw $t0, 0($t1)
sw $t1, -88($fp)
lw $t0, 28($fp)
addi $sp, $sp, -4
sw $t0, -100($fp)
lw $t0, 32($fp)
addi $sp, $sp, -4
sw $t0, -104($fp)
lw $t0, 8($fp)
addi $sp, $sp, -4
sw $t0, -108($fp)
addi $sp, $sp, -4
lw $t9, -100($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
lw $t9, -104($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
lw $t9, -108($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal display
lw $ra, 0($sp)
addi $sp, $sp, 4
addi $sp, $sp, -4
move $t0, $v0
sw $t0, -112($fp)
li $t0, 0
move $v0, $t0
move $sp, $fp
lw $fp, 0($sp)
addi $sp, $sp, 4
jr $ra
label8:
label9:
lw $t0, -4($fp)
lw $t1, 28($fp)
bge $t0, $t1, label10
lw $t0, -4($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -116($fp)
lw $t0, 12($fp)
lw $t1, -116($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -120($fp)
lw $t0, -120($fp)
lw $t0, 0($t0)
li $t1, 1
bne $t0, $t1, label11
lw $t0, -4($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -124($fp)
lw $t0, 16($fp)
lw $t1, -124($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -128($fp)
lw $t0, -128($fp)
lw $t0, 0($t0)
li $t1, 1
bne $t0, $t1, label11
lw $t0, -4($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -132($fp)
lw $t0, 20($fp)
lw $t1, -132($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -136($fp)
lw $t0, -136($fp)
lw $t0, 0($t0)
li $t1, 1
bne $t0, $t1, label11
lw $t0, 24($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -140($fp)
lw $t0, 8($fp)
lw $t1, -140($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -144($fp)
lw $t0, -4($fp)
lw $t1, -144($fp)
sw $t0, 0($t1)
sw $t1, -144($fp)
lw $t0, -4($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -148($fp)
lw $t0, 12($fp)
lw $t1, -148($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -152($fp)
li $t0, 0
lw $t1, -152($fp)
sw $t0, 0($t1)
sw $t1, -152($fp)
addi $sp, $sp, -4
li $t0, 0
sw $t0, -156($fp)
label12:
lw $t0, 28($fp)
addi $sp, $sp, -4
addi $t1, $t0, -1
sw $t1, -160($fp)
lw $t0, -156($fp)
lw $t1, -160($fp)
bge $t0, $t1, label13
lw $t0, -156($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -164($fp)
la $t0, -44($fp)
lw $t1, -164($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -168($fp)
lw $t0, -156($fp)
addi $sp, $sp, -4
addi $t1, $t0, 1
sw $t1, -172($fp)
lw $t0, -172($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -176($fp)
lw $t0, 16($fp)
lw $t1, -176($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -180($fp)
lw $t0, -180($fp)
lw $t0, 0($t0)
lw $t1, -168($fp)
sw $t0, 0($t1)
sw $t1, -168($fp)
lw $t0, -156($fp)
addi $t0, $t0, 1
sw $t0, -156($fp)
j label12
label13:
lw $t0, 28($fp)
addi $sp, $sp, -4
addi $t1, $t0, -1
sw $t1, -184($fp)
lw $t0, -184($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -188($fp)
la $t0, -44($fp)
lw $t1, -188($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -192($fp)
li $t0, 1
lw $t1, -192($fp)
sw $t0, 0($t1)
sw $t1, -192($fp)
lw $t0, -4($fp)
li $t1, 0
beq $t0, $t1, label14
lw $t0, -4($fp)
addi $sp, $sp, -4
addi $t1, $t0, -1
sw $t1, -196($fp)
lw $t0, -196($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -200($fp)
la $t0, -44($fp)
lw $t1, -200($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -204($fp)
li $t0, 0
lw $t1, -204($fp)
sw $t0, 0($t1)
sw $t1, -204($fp)
label14:
lw $t0, 28($fp)
addi $t1, $t0, -1
sw $t1, -156($fp)
label15:
lw $t0, -156($fp)
li $t1, 0
ble $t0, $t1, label16
lw $t0, -156($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -208($fp)
la $t0, -84($fp)
lw $t1, -208($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -212($fp)
lw $t0, -156($fp)
addi $sp, $sp, -4
addi $t1, $t0, -1
sw $t1, -216($fp)
lw $t0, -216($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -220($fp)
lw $t0, 20($fp)
lw $t1, -220($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -224($fp)
lw $t0, -224($fp)
lw $t0, 0($t0)
lw $t1, -212($fp)
sw $t0, 0($t1)
sw $t1, -212($fp)
lw $t0, -156($fp)
addi $t0, $t0, -1
sw $t0, -156($fp)
j label15
label16:
la $t0, -84($fp)
addi $sp, $sp, -4
addi $t1, $t0, 0
sw $t1, -228($fp)
li $t0, 1
lw $t1, -228($fp)
sw $t0, 0($t1)
sw $t1, -228($fp)
lw $t0, 28($fp)
addi $sp, $sp, -4
addi $t1, $t0, -1
sw $t1, -232($fp)
lw $t0, -4($fp)
lw $t1, -232($fp)
beq $t0, $t1, label17
lw $t0, -4($fp)
addi $sp, $sp, -4
addi $t1, $t0, 1
sw $t1, -236($fp)
lw $t0, -236($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -240($fp)
la $t0, -84($fp)
lw $t1, -240($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -244($fp)
li $t0, 0
lw $t1, -244($fp)
sw $t0, 0($t1)
sw $t1, -244($fp)
label17:
lw $t0, 32($fp)
addi $sp, $sp, -4
sw $t0, -248($fp)
lw $t0, 28($fp)
addi $sp, $sp, -4
sw $t0, -252($fp)
lw $t0, 24($fp)
addi $sp, $sp, -4
addi $t1, $t0, 1
sw $t1, -256($fp)
lw $t0, -256($fp)
addi $sp, $sp, -4
sw $t0, -260($fp)
la $t0, -84($fp)
addi $sp, $sp, -4
sw $t0, -264($fp)
la $t0, -44($fp)
addi $sp, $sp, -4
sw $t0, -268($fp)
lw $t0, 12($fp)
addi $sp, $sp, -4
sw $t0, -272($fp)
lw $t0, 8($fp)
addi $sp, $sp, -4
sw $t0, -276($fp)
addi $sp, $sp, -4
lw $t9, -248($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
lw $t9, -252($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
lw $t9, -260($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
lw $t9, -264($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
lw $t9, -268($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
lw $t9, -272($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
lw $t9, -276($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal dfs
lw $ra, 0($sp)
addi $sp, $sp, 4
addi $sp, $sp, -4
move $t0, $v0
sw $t0, -280($fp)
lw $t0, -4($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -284($fp)
lw $t0, 12($fp)
lw $t1, -284($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -288($fp)
li $t0, 1
lw $t1, -288($fp)
sw $t0, 0($t1)
sw $t1, -288($fp)
label11:
lw $t0, -4($fp)
addi $t0, $t0, 1
sw $t0, -4($fp)
j label9
label10:
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
addi $sp, $sp, -40
addi $sp, $sp, -40
addi $sp, $sp, -40
addi $sp, $sp, -4
li $t0, 0
sw $t0, -168($fp)
addi $sp, $sp, -4
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
lw $ra, 0($sp)
addi $sp, $sp, 4
move $t0, $v0
sw $t0, -172($fp)
lw $t0, -172($fp)
li $t1, 0
beq $t0, $t1, label19
lw $t0, -172($fp)
li $t1, 10
ble $t0, $t1, label18
label19:
li $t0, 0
move $v0, $t0
move $sp, $fp
lw $fp, 0($sp)
addi $sp, $sp, 4
jr $ra
label18:
label20:
lw $t0, -168($fp)
lw $t1, -172($fp)
bge $t0, $t1, label21
lw $t0, -168($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -176($fp)
la $t0, -84($fp)
lw $t1, -176($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -180($fp)
li $t0, 1
lw $t1, -180($fp)
sw $t0, 0($t1)
sw $t1, -180($fp)
lw $t0, -168($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -184($fp)
la $t0, -124($fp)
lw $t1, -184($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -188($fp)
li $t0, 1
lw $t1, -188($fp)
sw $t0, 0($t1)
sw $t1, -188($fp)
lw $t0, -168($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -192($fp)
la $t0, -164($fp)
lw $t1, -192($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -196($fp)
li $t0, 1
lw $t1, -196($fp)
sw $t0, 0($t1)
sw $t1, -196($fp)
lw $t0, -168($fp)
addi $t0, $t0, 1
sw $t0, -168($fp)
j label20
label21:
la $t0, -44($fp)
addi $sp, $sp, -4
addi $t1, $t0, 0
sw $t1, -200($fp)
li $t0, 0
lw $t1, -200($fp)
sw $t0, 0($t1)
sw $t1, -200($fp)
la $t0, -44($fp)
addi $sp, $sp, -4
sw $t0, -204($fp)
lw $t0, -172($fp)
addi $sp, $sp, -4
sw $t0, -208($fp)
li $t0, 0
addi $sp, $sp, -4
sw $t0, -212($fp)
la $t0, -164($fp)
addi $sp, $sp, -4
sw $t0, -216($fp)
la $t0, -124($fp)
addi $sp, $sp, -4
sw $t0, -220($fp)
la $t0, -84($fp)
addi $sp, $sp, -4
sw $t0, -224($fp)
la $t0, -40($fp)
addi $sp, $sp, -4
sw $t0, -228($fp)
addi $sp, $sp, -4
lw $t9, -204($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
lw $t9, -208($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
lw $t9, -212($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
lw $t9, -216($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
lw $t9, -220($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
lw $t9, -224($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
lw $t9, -228($fp)
sw $t9, 0($sp)
addi $sp, $sp, -4
sw $ra, 0($sp)
jal dfs
lw $ra, 0($sp)
addi $sp, $sp, 4
addi $sp, $sp, -4
move $t0, $v0
sw $t0, -232($fp)
la $t0, -44($fp)
addi $sp, $sp, -4
addi $t1, $t0, 0
sw $t1, -236($fp)
lw $t0, -236($fp)
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
