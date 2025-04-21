.data
A:      .word 1, 2, 3, 4, 5, 6, 7, 8, 9    # Matriz A 3x3
B:      .word 9, 8, 7, 6, 5, 4, 3, 2, 1    # Matriz B 3x3
C:      .space 36                           # Resultado A·Bᵀ (3x3)
size:   .word 3                             # Tamanho das matrizes

.text
main:
    la $a0, A                               # Endereço de A
    la $a1, B                               # Endereço de B (não precisa de Bᵀ!)
    la $a2, C                               # Endereço de C
    lw $a3, size                            # Tamanho das matrizes (3)
    jal PROC_MUL_ABT                        # Chama a multiplicação A·Bᵀ

    li $v0, 10                              # Exit
    syscall

PROC_MUL_ABT:
    # Inputs:
    # $a0 = A, $a1 = B, $a2 = C, $a3 = size (N)
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
    # Calcula endereço de A[i][k] = A + (i * N + k) * 4
    mul $t7, $t3, $a3                       # i * N
    add $t7, $t7, $t5                       # + k
    sll $t7, $t7, 2                         # ×4 (bytes)
    add $t7, $t0, $t7                       # Endereço de A[i][k]
    lw $t8, 0($t7)                          # $t8 = A[i][k]

    # Calcula endereço de B[j][k] = B + (j * N + k) * 4 (equivale a Bᵀ[k][j])
    mul $t7, $t4, $a3                       # j * N
    add $t7, $t7, $t5                       # + k
    sll $t7, $t7, 2                         # ×4 (bytes)
    add $t7, $t1, $t7                       # Endereço de B[j][k]
    lw $t9, 0($t7)                          # $t9 = B[j][k]

    mul $t7, $t8, $t9                       # A[i][k] * B[j][k]
    add $t6, $t6, $t7                       # Soma += ...

    addi $t5, $t5, 1                        # k++
    blt $t5, $a3, loop_k                    # Se k < N, repete

    # Armazena C[i][j] = soma
    mul $t7, $t3, $a3                       # i * N
    add $t7, $t7, $t4                       # + j
    sll $t7, $t7, 2                         # ×4 (bytes)
    add $t7, $t2, $t7                       # Endereço de C[i][j]
    sw $t6, 0($t7)                          # Armazena o resultado

    addi $t4, $t4, 1                        # j++
    blt $t4, $a3, loop_j                    # Se j < N, repete

    addi $t3, $t3, 1                        # i++
    blt $t3, $a3, loop_i                    # Se i < N, repete

    jr $ra                                  # Retorna
