.data
	
	
.text
	
	li $v0, 5 #leitura de inteiro no teclado
	syscall
	move $t0, $v0 # registrador temporário recebe valor lido do teclado
	
	li $t1, 1
	ble $t0, $t1, imprime_resultado # mostrar o resultado se o valor lido é igual a 1 ou 0
	
	fatorial:
	
	mul $t1, $t1, $t0
	addi $t0, $t0, -1
	bne $t0, 1, fatorial
	
	imprime_resultado:
	
	move $a0, $t1 #argumento syscall
	li $v0, 1 #imprime inteiro
	syscall
	
	fim: 
	li $v0, 10
	syscall
	
		
