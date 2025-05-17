.data

.text
main:

    # Recebe número via teclado
    li $v0, 5
    syscall
    move $a0, $v0        # move valor lido para $a0, para ser argumento do procedimento
   
    jal fatorial         # chama função recursiva
    move $a0, $v0        # guarda resultado em $a0
   
    # Imprime resultado
    li $v0, 1
    syscall

    # Encerrar programa
    li $v0, 10
    syscall

# Função fatorial recursiva
fatorial:
    addi $sp, $sp, -8
    sw $ra, 4($sp) # salva o endereço de retorno na pilha
    sw $a0, 0($sp) # salva o argumento na pilha
    # deve ser necessário salvar na pilha porque é uma função recursiva

    # se a0 é menor que 1, t0 recebe 1
    slti $t0, $a0, 1
    bne $t0, $zero, casobase # se t0 não for igual a 0, vai para o caso base

    # chamada recursiva: return n * fatorial(n - 1)
    addi $a0, $a0, -1
    jal fatorial

    lw $a0, 0($sp)       # restaura n da pilha
    mul $v0, $a0, $v0    # n * fatorial(n-1)
    lw $ra, 4($sp) # restaura registrador com o endereço de retorno da pilha
    addi $sp, $sp, 8
    jr $ra

casobase:
    li $v0, 1 # retorna 1
    lw $ra, 4($sp) # restaura o registrador de endereço da p
    addi $sp, $sp, 8
    jr $ra

