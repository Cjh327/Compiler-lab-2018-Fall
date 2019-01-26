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
addi $sp, $sp, -32
addi $sp, $sp, -32
addi $sp, $sp, -32
addi $sp, $sp, -32
addi $sp, $sp, -4
li $t0, 0
sw $t0, -132($fp)
addi $sp, $sp, -4
li $t0, 0
sw $t0, -136($fp)
addi $sp, $sp, -4
addi $sp, $sp, -4
sw $ra, 0($sp)
jal read
lw $ra, 0($sp)
addi $sp, $sp, 4
move $t0, $v0
sw $t0, -140($fp)
label1:
lw $t0, -136($fp)
lw $t1, -140($fp)
bge $t0, $t1, label2
lw $t0, -136($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -144($fp)
la $t0, -32($fp)
lw $t1, -144($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -148($fp)
li $t0, -1
lw $t1, -148($fp)
sw $t0, 0($t1)
sw $t1, -148($fp)
lw $t0, -136($fp)
addi $t0, $t0, 1
sw $t0, -136($fp)
j label1
label2:
li $t0, 0
sw $t0, -136($fp)
addi $sp, $sp, -4
li $t0, 1
sw $t0, -152($fp)
label3:
lw $t0, -152($fp)
li $t1, 1
bne $t0, $t1, label4
lw $t0, -136($fp)
lw $t1, -140($fp)
bne $t0, $t1, label5
addi $sp, $sp, -4
li $t0, 1
sw $t0, -156($fp)
addi $sp, $sp, -4
li $t0, 0
sw $t0, -160($fp)
label7:
lw $t0, -160($fp)
lw $t1, -140($fp)
bge $t0, $t1, label8
lw $t0, -160($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -164($fp)
la $t0, -64($fp)
lw $t1, -164($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -168($fp)
li $t0, 1
lw $t1, -168($fp)
sw $t0, 0($t1)
sw $t1, -168($fp)
lw $t0, -160($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -172($fp)
la $t0, -96($fp)
lw $t1, -172($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -176($fp)
li $t0, 1
lw $t1, -176($fp)
sw $t0, 0($t1)
sw $t1, -176($fp)
lw $t0, -160($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -180($fp)
la $t0, -128($fp)
lw $t1, -180($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -184($fp)
li $t0, 1
lw $t1, -184($fp)
sw $t0, 0($t1)
sw $t1, -184($fp)
lw $t0, -160($fp)
addi $t0, $t0, 1
sw $t0, -160($fp)
j label7
label8:
li $t0, 0
sw $t0, -160($fp)
label9:
lw $t0, -160($fp)
lw $t1, -140($fp)
bge $t0, $t1, label10
lw $t0, -160($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -188($fp)
la $t0, -32($fp)
lw $t1, -188($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -192($fp)
lw $t0, -192($fp)
lw $t0, 0($t0)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -196($fp)
la $t0, -64($fp)
lw $t1, -196($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -200($fp)
lw $t0, -200($fp)
lw $t0, 0($t0)
li $t1, 1
bne $t0, $t1, label13
lw $t0, -160($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -204($fp)
la $t0, -32($fp)
lw $t1, -204($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -208($fp)
lw $t0, -208($fp)
lw $t0, 0($t0)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -212($fp)
la $t0, -96($fp)
lw $t1, -212($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -216($fp)
lw $t0, -216($fp)
lw $t0, 0($t0)
li $t1, 1
bne $t0, $t1, label13
lw $t0, -160($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -220($fp)
la $t0, -32($fp)
lw $t1, -220($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -224($fp)
lw $t0, -224($fp)
lw $t0, 0($t0)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -228($fp)
la $t0, -128($fp)
lw $t1, -228($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -232($fp)
lw $t0, -232($fp)
lw $t0, 0($t0)
li $t1, 1
beq $t0, $t1, label11
label13:
li $t0, 0
sw $t0, -156($fp)
lw $t0, -140($fp)
move $t1, $t0
sw $t1, -160($fp)
j label12
label11:
lw $t0, -160($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -236($fp)
la $t0, -32($fp)
lw $t1, -236($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -240($fp)
lw $t0, -240($fp)
lw $t0, 0($t0)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -244($fp)
la $t0, -64($fp)
lw $t1, -244($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -248($fp)
li $t0, 0
lw $t1, -248($fp)
sw $t0, 0($t1)
sw $t1, -248($fp)
addi $sp, $sp, -4
li $t0, 0
sw $t0, -252($fp)
label14:
lw $t0, -140($fp)
addi $sp, $sp, -4
addi $t1, $t0, -1
sw $t1, -256($fp)
lw $t0, -252($fp)
lw $t1, -256($fp)
bge $t0, $t1, label15
lw $t0, -252($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -260($fp)
la $t0, -96($fp)
lw $t1, -260($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -264($fp)
lw $t0, -252($fp)
addi $sp, $sp, -4
addi $t1, $t0, 1
sw $t1, -268($fp)
lw $t0, -268($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -272($fp)
la $t0, -96($fp)
lw $t1, -272($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -276($fp)
lw $t0, -276($fp)
lw $t0, 0($t0)
lw $t1, -264($fp)
sw $t0, 0($t1)
sw $t1, -264($fp)
lw $t0, -252($fp)
addi $t0, $t0, 1
sw $t0, -252($fp)
j label14
label15:
lw $t0, -140($fp)
addi $sp, $sp, -4
addi $t1, $t0, -1
sw $t1, -280($fp)
lw $t0, -280($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -284($fp)
la $t0, -96($fp)
lw $t1, -284($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -288($fp)
li $t0, 1
lw $t1, -288($fp)
sw $t0, 0($t1)
sw $t1, -288($fp)
lw $t0, -160($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -292($fp)
la $t0, -32($fp)
lw $t1, -292($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -296($fp)
lw $t0, -296($fp)
lw $t0, 0($t0)
li $t1, 0
beq $t0, $t1, label16
lw $t0, -160($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -300($fp)
la $t0, -32($fp)
lw $t1, -300($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -304($fp)
lw $t0, -304($fp)
lw $t0, 0($t0)
addi $sp, $sp, -4
addi $t1, $t0, -1
sw $t1, -308($fp)
lw $t0, -308($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -312($fp)
la $t0, -96($fp)
lw $t1, -312($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -316($fp)
li $t0, 0
lw $t1, -316($fp)
sw $t0, 0($t1)
sw $t1, -316($fp)
label16:
lw $t0, -140($fp)
addi $t1, $t0, -1
sw $t1, -252($fp)
label17:
lw $t0, -252($fp)
li $t1, 0
ble $t0, $t1, label18
lw $t0, -252($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -320($fp)
la $t0, -128($fp)
lw $t1, -320($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -324($fp)
lw $t0, -252($fp)
addi $sp, $sp, -4
addi $t1, $t0, -1
sw $t1, -328($fp)
lw $t0, -328($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -332($fp)
la $t0, -128($fp)
lw $t1, -332($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -336($fp)
lw $t0, -336($fp)
lw $t0, 0($t0)
lw $t1, -324($fp)
sw $t0, 0($t1)
sw $t1, -324($fp)
lw $t0, -252($fp)
addi $t0, $t0, -1
sw $t0, -252($fp)
j label17
label18:
la $t0, -128($fp)
addi $sp, $sp, -4
addi $t1, $t0, 0
sw $t1, -340($fp)
li $t0, 1
lw $t1, -340($fp)
sw $t0, 0($t1)
sw $t1, -340($fp)
lw $t0, -160($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -344($fp)
la $t0, -32($fp)
lw $t1, -344($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -348($fp)
lw $t0, -140($fp)
addi $sp, $sp, -4
addi $t1, $t0, -1
sw $t1, -352($fp)
lw $t0, -348($fp)
lw $t0, 0($t0)
lw $t1, -352($fp)
beq $t0, $t1, label19
lw $t0, -160($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -356($fp)
la $t0, -32($fp)
lw $t1, -356($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -360($fp)
lw $t0, -360($fp)
lw $t0, 0($t0)
addi $sp, $sp, -4
addi $t1, $t0, 1
sw $t1, -364($fp)
lw $t0, -364($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -368($fp)
la $t0, -128($fp)
lw $t1, -368($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -372($fp)
li $t0, 0
lw $t1, -372($fp)
sw $t0, 0($t1)
sw $t1, -372($fp)
label19:
lw $t0, -160($fp)
addi $t0, $t0, 1
sw $t0, -160($fp)
label12:
j label9
label10:
lw $t0, -156($fp)
li $t1, 1
bne $t0, $t1, label20
lw $t0, -132($fp)
addi $t0, $t0, 1
sw $t0, -132($fp)
label20:
lw $t0, -136($fp)
addi $t0, $t0, -1
sw $t0, -136($fp)
j label6
label5:
label21:
lw $t0, -136($fp)
li $t1, 0
blt $t0, $t1, label22
lw $t0, -136($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -376($fp)
la $t0, -32($fp)
lw $t1, -376($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -380($fp)
lw $t0, -140($fp)
addi $sp, $sp, -4
addi $t1, $t0, -1
sw $t1, -384($fp)
lw $t0, -380($fp)
lw $t0, 0($t0)
lw $t1, -384($fp)
blt $t0, $t1, label22
lw $t0, -136($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -388($fp)
la $t0, -32($fp)
lw $t1, -388($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -392($fp)
li $t0, -1
lw $t1, -392($fp)
sw $t0, 0($t1)
sw $t1, -392($fp)
lw $t0, -136($fp)
addi $t0, $t0, -1
sw $t0, -136($fp)
j label21
label22:
lw $t0, -136($fp)
li $t1, -1
bne $t0, $t1, label23
li $t0, 0
sw $t0, -152($fp)
j label24
label23:
lw $t0, -136($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -396($fp)
la $t0, -32($fp)
lw $t1, -396($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -400($fp)
lw $t0, -136($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -404($fp)
la $t0, -32($fp)
lw $t1, -404($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -408($fp)
lw $t0, -408($fp)
lw $t0, 0($t0)
addi $sp, $sp, -4
addi $t1, $t0, 1
sw $t1, -412($fp)
lw $t0, -412($fp)
lw $t1, -400($fp)
sw $t0, 0($t1)
sw $t1, -400($fp)
lw $t0, -136($fp)
addi $t0, $t0, 1
sw $t0, -136($fp)
label24:
label6:
j label3
label4:
lw $t0, -132($fp)
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
