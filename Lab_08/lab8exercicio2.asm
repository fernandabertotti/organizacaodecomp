.data
	MAX: .word 3 # tamanho das matrizes é parametrizável
	block_size: .word 10 # tamanho dos blocos é parametrizável (block_size palavras por bloco)
	A: .float 1, 2, 3, 4, 5, 6, 7, 8, 9
	B: .float 9, 8, 7, 6, 5, 4, 3, 2, 1

.text
main:
# Carregar tamanho das matrizes e seus endereços base:
lw $s0, MAX
la $s1, A
la $s2, B

# Carregar tamanho dos blocos
lw $s3, block_size

# Inicializar i:
li $t1, 0 # i

loop_linhas:

# Reinicializar j a cada linha percorrida:
li $t2, 0 # j

loop_colunas:

move $t3, $t1 # ii = i

loop_linhas_bloco:

move $t4, $t2 # jj = j

loop_colunas_bloco:

# A[ii][jj] corresponde a s1 + (((ii*MAX)+jj)*4)
# B[jj][ii] corresponde a s2 + (((jj*MAX)+ii)*4)

mul $t5, $t3, $s0 # t5 = ii * MAX
add $t5, $t5, $t4 # t5 = (ii * MAX) + jj
sll $t5, $t5, 2 # t5 = ((ii * MAX) + jj) * 4
add $t6, $t5, $s1 # t6 = s1 + ((ii * MAX) + jj) * 4

mul $t7, $t4, $s0 # t7 = jj * MAX
add $t7, $t7, $t3 # t7 = (jj * MAX) + ii
sll $t7, $t7, 2 # t7 = ((jj * MAX) + ii) * 4
add $t8, $t7, $s2 # t8 = s2 + ((jj * MAX) + ii) * 4

# t6 e t8 contêm os endereços do elemento A[ii][jj] e B[jj][ii], respectivamente
l.s $f0, ($t6) # carrega elemento de A
l.s $f2, ($t8) # carrega elemento de B

add.s $f0, $f0, $f2 # A[ii][jj] = A[ii][jj] + B[jj][ii]

s.s $f0, ($t6) # armazena novo elemento A[ii][jj]

incrementar_jj:
add $t9, $t2, $s3 # CORRIGIDO ! # soma j com block_size para obter condição de saída do loop (usando $t9) 
addi $t4, $t4, 1 # jj++
blt $t4, $t9, loop_colunas_bloco # repete loop_colunas_bloco enquanto jj < j+block_size

incrementar_ii:
add $s4, $t1, $s3 # soma i com block_size para obter condição de saída do loop 
addi $t3, $t3, 1 # ii++
blt $t3, $s4, loop_linhas_bloco # repete loop_linhas_bloco enquanto ii < i+block_size 

incrementar_j:

add $t2, $t2, $s3 # j += block_size
blt $t2, $s0, loop_colunas # repete loop_colunas enquanto j < MAX

incrementar_i:

add $t1, $t1, $s3 # i += block_size
blt $t1, $s0, loop_linhas # repete loop_linhas enquanto i < MAX


fim: # i = MAX

li $v0, 10
syscall
