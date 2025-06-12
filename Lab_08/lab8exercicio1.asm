.data
	MAX: .word 5
	A: .float 1, 2, 3, 4,1, 2, 3, 4,1, 9, 3, 4,1, 2, 65, 4,1, 2, 3, 4,1, 2, 3,5,6
	B: .float 9, 8, 7, 6,1, 2, 9, 4,1, 2, 3, 4,1, 0, 3, 4,1, 2, 3, 4,1, 2, 3, 4,5
	
.text
main:
	# Carregar tamanho das matrizes e seus endereços base:
	lw $s0, MAX
	la $s1, A
	la $s2, B
	
	# Inicializar i:
	li $t1, 0 # i
	
loop_linhas:
	
	# Reinicializar j a cada linha percorrida:
	li $t2, 0 # j
	
loop_colunas:

	# A[i][j] corresponde a s1 + (((i*MAX)+j)*4)
	# B[j][i] corresponde a s2 + (((j*MAX)+i)*4)
	
	mul $t3, $t1, $s0 # t2 = i * MAX
	add $t3, $t3, $t2 # t2 = (i * MAX) + j
	sll $t3, $t3, 2 # t2 = ((i * MAX) + j) * 8 
	add $t4, $t3, $s1 # t4 = s1 + ((i * MAX) + j) * 8 
	
	mul $t5, $t2, $s0 # t5 = j * MAX
	add $t5, $t5, $t1 # t5 = (j * MAX) + i
	sll $t5, $t5, 2 # t5 = ((j * MAX) + i) * 8 
	add $t6, $t5, $s2 # t6 = s2 + ((j * MAX) + i) * 8 
	
	# t4 e t5 contêm os endereços do elemento A[i][j] e B[j][i], respectivamente
	l.s $f0, ($t4) # carrega elemento de A
	l.s $f2, ($t6) # carrega elemento de B
	
	add.s $f0, $f0, $f2 # A[i][j] = A[i][j] + B[j][i]
	
	s.s $f0, ($t4) # armazena novo elemento A[i][j]
	
incrementar_j:
	
	addi $t2, $t2, 1 # j++
	blt $t2, $s0, loop_colunas # repete loop_colunas enquanto j < MAX
	
incrementar_i:
	
	addi $t1, $t1, 1 # i++
	blt $t1, $s0, loop_linhas
	

fim: # i = MAX

	li $v0, 10
	syscall

		
	
