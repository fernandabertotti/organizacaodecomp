.data

#área para dados na memória principal

a: .word 0
b: .word 20
c: .word 0
d: .word 2
e: .word 15

.text
main:

#área para instruções do programa

#  a = b + 35
#  c = d^3 − (a + e)

lw $t0, b #carrega b em t0
lw $t1, a #carrega a em t1

addi $t1, $t0, 35 #a = b + 35
# sw $t1, a -> posso omitir se não for usar "a" da memória depois em outra função

lw $t2, e #carrega e em t2
add $t3, $t2, $t1 #armazena a + e em t3

lw $t4, d #carrega d em t4
sll $t4, $t4, 2 #carrega d ao cubo nele mesmo (d só pode ser 2)

lw $t5, c #carrega c em t5
sub $t5, $t4, $t3 #carrega a subtração em t5 
sw $t5, c #salva o valor de t5 em c

#para usar o syscall:
li $v0, 1 #instrução para impressão de inteiro (conteúdo de $a0)
move $a0, $t5 #move o conteúdo de $t5 para $a0
syscall #imprime o que está dentro do registrador $a0 ($a0 é argumento da função syscall)
