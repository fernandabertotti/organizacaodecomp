.data
	#inicialização das matrizes A e B com seus respectivos valores
	
	A: .word 1, 2, 3	#equivalente a declarar a matriz em uma única linha (é unidimensional)
	   .word 0, 1, 4
	   .word 0, 0, 1
	   
	B: .word 1, -2, 5
	   .word 0, 1, -4
	   .word 0, 0, 1
	   
	BT: .space 36 # armazena 9 x 4 bytes de espaço para alocar a transposta de B
	   
	# ambas são triangulares (não sei se isso ajuda)
.text
main:

# cálculo da matriz transposta de B:

# para acessar um elemento da matriz, deve-se calcular o seu endereço:
# endereço_elemento = endereço_base + (((linha * 3) + coluna) * 4) 
# row major ^

# endereço_elemento = endereço_base + (((coluna * 3) + linha) * 4)
# column major ^ (para a transposta)

	la $t0, B #endereço base de B
	la $t1, BT #endereço base de B transposta
	
	li $t2, 0 # $t2 = i = 0 = linha de B
	
	loop_i:
		li $t3, 0 # coluna j = 0
	
	loop_j:
		li $t4, 3 # carrega a ordem da matriz
		
		mul $t5, $t4, $t2 # i * 3 e armazena em t5
		add $t5, $t5, $t3 # t5 + j
		sll $t5, $t5, 2 # * 4 bytes
		
		add $t5, $t5, $t0 # endereço final de B[i][j]
		lw $t7, 0($t5) # carrega o valor de B[i][j]
	
		
		mul $t6, $t4, $t3 # j * 3 e armazena em t5
		add $t6, $t6, $t2 # t6 + i
		sll $t6, $t6, 3 # * 4 bytes
		
		add $t6, $t6, $t1 # endereço final de BT[j][i]
		sw $t7, 0($t6) # guarda B[i][j] em BT[j][i]
		
		addi $t3, $t3, 1 # j++
		
		blt $t3, $t4, loop_j # se j < 3, goto loop_j
		
		#else if (j >= 3):
		
		addi $t2, $t2, 1 # i++
		blt $t2, $t4, loop_i # se i < 3, goto loop_i
		
		
		







