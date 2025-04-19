.data
	b: .word 0
	d: .word 0
	e: .word 0
	c: .word 0

.text

#  a = b + 35
#  c = d^3 − (a + e)

li $v0, 5 #comando (5) para ler inteiro (b)
syscall
move $t0, $v0 #resultado salvo em $t0
sw $t0, b #armazena o dado lido em b

addi $t1, $t0, 35 #a = b + 35

li $v0, 5 #comando (5) para ler inteiro (d)
syscall
move $t2, $v0 #resultado salvo em $t2
sw $v0, d #armazena o dado lido em d na memória

sll $t2, $t2, 2 #se d = 2, d = d^3

li $v0, 5 #comando (5) para ler inteiro (e)
syscall
move $t3, $v0
sw $t3, e

add $t1, $t1, $t3 #(a + e)

sub $t4, $t2, $t1 # d^3 - (a + e)

sw $t4, c #salva o resultado c na memória

li $v0, 1
move $a0, $t4
syscall
