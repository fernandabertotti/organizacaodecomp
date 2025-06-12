.data

	matriz: .space 1024 # Espaço para matriz 16x16 na memória
	tam: .word 16 # Tamanho da matriz

.text
main:

	la $s0, matriz # Carrega endereço-base da matriz em s0
	lw $s1, tam # Carrega tamanho da matriz quadrada em s1
	
	li $t1, 0 # j = 0
	li $t4, 0 # value = 0
	
loop_colunas:

	# Reiniciar i a cada nova linha
	li $t0, 0 # i = 0
	
loop_linhas:

	# matriz[i][j] corresponde a s0 + (((i*tam)+j)*4)
	mul $t2, $t0, $s1 # t2 = i * tam
	add $t2, $t2, $t1 # t2 = (i * tam) + j
	sll $t2, $t2, 2 # t2 = ((i * tam) + j) * 4 
	add $t3, $t2, $s0 # t3 = s0 + ((i * tam) + j) * 4 
	
	# t3 contém o endereço do elemento [i][j] na matriz
	sw $t4, 0($t3) # armazena value no elemento [i][j] da matriz
	addi $t4, $t4, 1 # value++ para a próxima iteração
	
incrementar_i: 

	addi $t0, $t0, 1 # i++
	blt $t0, $s1, loop_linhas
	
incrementar_j:

	addi $t1, $t1, 1 # j++
	blt $t1, $s1, loop_colunas # repete loop_colunas enquanto j < 16
	
fim: # j = 16
	li $v0, 10
	syscall
