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
addi $sp, $sp, -600
addi $sp, $sp, -4
li $t0, 10
sw $t0, -604($fp)
addi $sp, $sp, -4
li $t0, 5
sw $t0, -608($fp)
addi $sp, $sp, -4
li $t0, 3
sw $t0, -612($fp)
addi $sp, $sp, -4
li $t0, 0
sw $t0, -616($fp)
addi $sp, $sp, -4
li $t0, 0
sw $t0, -620($fp)
addi $sp, $sp, -4
li $t0, 0
sw $t0, -624($fp)
addi $sp, $sp, -4
li $t0, 0
sw $t0, -628($fp)
label1:
lw $t0, -616($fp)
lw $t1, -604($fp)
bge $t0, $t1, label2
li $t0, 0
sw $t0, -620($fp)
label3:
lw $t0, -620($fp)
lw $t1, -608($fp)
bge $t0, $t1, label4
li $t0, 0
sw $t0, -624($fp)
label5:
lw $t0, -624($fp)
lw $t1, -612($fp)
bge $t0, $t1, label6
lw $t0, -616($fp)
li $t1, 60
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -632($fp)
lw $t0, -620($fp)
li $t1, 12
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -636($fp)
lw $t0, -632($fp)
lw $t1, -636($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -640($fp)
lw $t0, -624($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -644($fp)
lw $t0, -640($fp)
lw $t1, -644($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -648($fp)
la $t0, -600($fp)
lw $t1, -648($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -652($fp)
lw $t0, -616($fp)
lw $t1, -604($fp)
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -656($fp)
lw $t0, -620($fp)
lw $t1, -608($fp)
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -660($fp)
lw $t0, -656($fp)
lw $t1, -660($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -664($fp)
lw $t0, -624($fp)
addi $sp, $sp, -4
addi $t1, $t0, 1
sw $t1, -668($fp)
lw $t0, -612($fp)
lw $t1, -668($fp)
div $t0, $t1
addi $sp, $sp, -4
mflo $t2
sw $t2, -672($fp)
lw $t0, -664($fp)
lw $t1, -672($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -676($fp)
lw $t0, -676($fp)
lw $t1, -652($fp)
sw $t0, 0($t1)
sw $t1, -652($fp)
lw $t0, -624($fp)
addi $t0, $t0, 1
sw $t0, -624($fp)
j label5
label6:
lw $t0, -620($fp)
addi $t0, $t0, 1
sw $t0, -620($fp)
j label3
label4:
lw $t0, -616($fp)
addi $t0, $t0, 1
sw $t0, -616($fp)
j label1
label2:
li $t0, 0
sw $t0, -616($fp)
li $t0, 0
sw $t0, -620($fp)
li $t0, 0
sw $t0, -624($fp)
label7:
lw $t0, -616($fp)
lw $t1, -604($fp)
bge $t0, $t1, label8
li $t0, 0
sw $t0, -620($fp)
label9:
lw $t0, -620($fp)
lw $t1, -608($fp)
bge $t0, $t1, label10
li $t0, 0
sw $t0, -624($fp)
label11:
lw $t0, -624($fp)
lw $t1, -612($fp)
bge $t0, $t1, label12
lw $t0, -616($fp)
li $t1, 60
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -680($fp)
lw $t0, -620($fp)
li $t1, 12
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -684($fp)
lw $t0, -680($fp)
lw $t1, -684($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -688($fp)
lw $t0, -624($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -692($fp)
lw $t0, -688($fp)
lw $t1, -692($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -696($fp)
la $t0, -600($fp)
lw $t1, -696($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -700($fp)
la $t0, -600($fp)
addi $sp, $sp, -4
addi $t1, $t0, 0
sw $t1, -704($fp)
lw $t0, -700($fp)
lw $t0, 0($t0)
lw $t1, -704($fp)
lw $t1, 0($t1)
ble $t0, $t1, label13
lw $t0, -616($fp)
li $t1, 60
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -708($fp)
lw $t0, -620($fp)
li $t1, 12
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -712($fp)
lw $t0, -708($fp)
lw $t1, -712($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -716($fp)
lw $t0, -624($fp)
li $t1, 4
addi $sp, $sp, -4
mul $t2, $t0, $t1
sw $t2, -720($fp)
lw $t0, -716($fp)
lw $t1, -720($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -724($fp)
la $t0, -600($fp)
lw $t1, -724($fp)
addi $sp, $sp, -4
add $t2, $t0, $t1
sw $t2, -728($fp)
lw $t0, -628($fp)
lw $t1, -728($fp)
lw $t1, 0($t1)
add $t0, $t0, $t1
sw $t0, -628($fp)
label13:
lw $t0, -624($fp)
addi $t0, $t0, 1
sw $t0, -624($fp)
j label11
label12:
lw $t0, -620($fp)
addi $t0, $t0, 1
sw $t0, -620($fp)
j label9
label10:
lw $t0, -616($fp)
addi $t0, $t0, 1
sw $t0, -616($fp)
j label7
label8:
lw $t0, -628($fp)
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
