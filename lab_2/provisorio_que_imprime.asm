.data
A:      .word 1, 2, 3, 4, 5, 6, 7, 8, 9    # Matriz A 3x3
B:      .word 9, 8, 7, 6, 5, 4, 3, 2, 1    # Matriz B 3x3
C:      .space 36                           # Resultado A·Bᵀ (3x3)
size:   .word 3                             # Tamanho das matrizes
space:  .asciiz " "                         # Espaço entre números
newline:.asciiz "\n"                        # Quebra de linha

.text
main:
    la $a0, A                               # Endereço de A
    la $a1, B                               # Endereço de B
    la $a2, C                               # Endereço de C
    lw $a3, size                            # Tamanho das matrizes (3)
    jal PROC_MUL_ABT                        # Chama a multiplicação A·Bᵀ

    # ---- Imprimir a matriz resultante C ----
    la $t0, C                               # Carrega endereço de C
    lw $t1, size                            # Tamanho da matriz (N=3)
    li $t2, 0                               # i = 0

print_loop_i:
    li $t3, 0                               # j = 0

print_loop_j:
    # Calcula endereço de C[i][j] = C + (i * N + j) * 4
    mul $t4, $t2, $t1                       # i * N
    add $t4, $t4, $t3                       # + j
    sll $t4, $t4, 2                         # ×4 (bytes)
    add $t4, $t0, $t4                       # Endereço de C[i][j]
    lw $a0, 0($t4)                          # Carrega C[i][j]

    # Imprime o número
    li $v0, 1                               # Syscall para imprimir inteiro
    syscall

    # Imprime espaço
    li $v0, 4
    la $a0, space
    syscall

    addi $t3, $t3, 1                        # j++
    blt $t3, $t1, print_loop_j              # Se j < N, repete

    # Imprime nova linha
    li $v0, 4
    la $a0, newline
    syscall

    addi $t2, $t2, 1                        # i++
    blt $t2, $t1, print_loop_i              # Se i < N, repete

    # Finaliza o programa
    li $v0, 10
    syscall

# --- Procedimento de multiplicação (igual ao anterior) ---
PROC_MUL_ABT:
    move $t0, $a0                           # A
    move $t1, $a1                           # B
    move $t2, $a2                           # C
    li $t3, 0                               # i = 0

loop_i:
    li $t4, 0                               # j = 0
loop_j:
    li $t5, 0                               # k = 0
    li $t6, 0                               # Soma = 0

loop_k:
    # Calcula endereço de A[i][k]
    mul $t7, $t3, $a3                       # i * N
    add $t7, $t7, $t5                       # + k
    sll $t7, $t7, 2                         # ×4 (bytes)
    add $t7, $t0, $t7
    lw $t8, 0($t7)                          # $t8 = A[i][k]

    # Calcula endereço de B[j][k]
    mul $t7, $t4, $a3                       # j * N
    add $t7, $t7, $t5                       # + k
    sll $t7, $t7, 2                         # ×4 (bytes)
    add $t7, $t1, $t7
    lw $t9, 0($t7)                          # $t9 = B[j][k]

    mul $t7, $t8, $t9                       # A[i][k] * B[j][k]
    add $t6, $t6, $t7                       # Soma += ...

    addi $t5, $t5, 1                        # k++
    blt $t5, $a3, loop_k                    # Se k < N, repete

    # Armazena C[i][j] = soma
    mul $t7, $t3, $a3                       # i * N
    add $t7, $t7, $t4                       # + j
    sll $t7, $t7, 2                         # ×4 (bytes)
    add $t7, $t2, $t7
    sw $t6, 0($t7)                          # Armazena o resultado

    addi $t4, $t4, 1                        # j++
    blt $t4, $a3, loop_j                    # Se j < N, repete

    addi $t3, $t3, 1                        # i++
    blt $t3, $a3, loop_i                    # Se i < N, repete

    jr $ra                                  # Retorna
