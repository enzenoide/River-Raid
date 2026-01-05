_init_:
    	lui  $16, 0x1001
cenario:      

    	jal DesenhaSplash
    	jal DesenhaHUD
    	jal DesenhaMapa
    	lui $3,0x1001  # Endereço do aviao
    	addi $3,$3,45312
    	jal DesenhaAviao 
    
Entidades:
    	
	lui $24,0x1001
    	addi $24,$24,76000
    
    	sw $0,100($24) #Flag do tiro, 1 se estiver ativo, 0 ao contrario
    	
    	lui $25,0x1001
    	addi $25,$25,18176 # Endereço do tiro
    	sw $25,200($24) # Endereço do tiro
    	
    	sw $0,300($24) #Contador de frames
    	
    	
    	lui $25,0x1001
    	addi $25,$25,252 # Endereço do tiro
    	sw $25,400($24) # Endereço do combustivel
    	lw $25,400($24)
    	add $7,$0,$25
    	jal DesenhaCombustivel
    	
    	
    	lui $25,0x1001
    	addi $25,$25,76
    	sw $25,500($24)
    	lw $25,500($24)
    	add $7,$0,$25
    	jal DesenhaCasa
    	
    	lui $25,0x1001
    	addi $25,$25,400
    	sw $25,600($24)
    	lw $25,600($24)
    	add $7,$0,$25
    	jal DesenhaCasa2
    
    	lui $25,0x1001 # Endereço do floco de neve
    	addi $25,$25,184
    	sw $25,700($24)
    	lw $25,700($24)
    	add $7,$0,$25
    	jal DesenhaFloco


    	lui $25,0x1001 # Endereço do Navio
    	addi $25,$25,320
    	sw $25,800($24)
    	lw $25,800($24)
    	add $7,$0,$25
    	jal DesenhaNavio
    
    
LoopJogo:
    	jal AtualizaJogador
    	jal ChecarColisaoInimigo
 
ChecarTiro:
    	lw $8,100($24)
    	beq $8,$0,MoverEntidade
    	jal MoveTiro
ChecaColisao:
    	lw $8,100($24)
    	beq $8,$0,MoverEntidade
    	jal ChecarColisao
MoverEntidade:
    	lw $9,300($24)
    	addi $9,$9,1
    	sw $9,300($24)
    
    	li $10,60
    	div $9,$10
    	mfhi $11
    	bne $11,$0,PulaFloco
    	
    	lw $7, 700($24)
    	jal MoveFloco
    	sw $7, 700($24)
PulaFloco:
    	li $10,60
    	div $9,$10
    	mfhi $11
    	bne $11,$0,PulaNavio
    	
    	lw $7,800($24)
    	jal MoveNavio
    	sw $7, 800($24)
PulaNavio:
    	li $10,60
    	div $9,$10
    	mfhi $11
    	bne $11,$0,PulaCasa
    	
    	lw $7,500($24)
    	jal MoveCasa
    	sw $7,500($24)
PulaCasa:
	li $10,80
	div $9,$10
	mfhi $11
	bne $11,$0,PulaCasa2
	
	lw $7,600($24)
    	jal MoveCasa2
    	sw $7,600($24)
    	
PulaCasa2:
	li $10,8000
	blt $9,$10,FimCiclo
	sw $0,300($24)
    
FimCiclo:
    	jal timer_curto
    
    	j LoopJogo
    
############################   
DesenhaMapa:
  	add $4,$0,$16
   	addi $18,$0,0
LoopLinhaLoop:
    	bge  $18,98,MapaFim # Se o contador das linhas for maior que 50 quer dizer que ele ja passou do mapa inicial, pula pro mapa1

    	add  $5,$0,$18          # $5 = n mero da linha atual
 
	add $22,$0,$ra
    	jal  ConstruirLinhaMAPA
    	add $ra,$0,$22
    	
    	add $22,$0,$ra
    	jal timerMAPA
    	add $ra,$0,$22

    	addi $18,$18,1
    	
    
    	j LoopLinhaLoop

############################ 	
timer:
    addi $25,$0,0
LoopTimer:
    bge $25,60000,fimtimer
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    addi $25,$25,1
    j LoopTimer
fimtimer:
    jr $ra
    
MapaFim:
    jr $ra
############################   

timerMAPA:
    addi $25,$0,0
LoopTimerMAPA:
    bge $25,100,fimtimerMAPA
    nop 
    addi $25,$25,1
    j LoopTimerMAPA
fimtimerMAPA:
    jr $ra
    
    
MapaFimMAPA:
    jr $ra
	
############################ 

timer_curto:
    addi $25,$0,0
LoopTimerCurto:
    bge $25,2000,FimTimerCurto
    addi $25,$25,1
    j LoopTimerCurto
FimTimerCurto:
    jr $ra
	


	












ConstruirLinhaMAPA:
	add $sp,$sp,-36
	sw $10,0($sp)
	sw $11,4($sp)
	sw $12,8($sp)
	sw $13,12($sp)
	sw $14,16($sp)
	sw $15,20($sp)
	sw $19,24($sp)
	sw $20,28($sp)
	sw $ra,32($sp)

    	addi $10,$0,128      # $10 = unidades por linha 128 
    	addi $11,$0,36       # $11 = verde  
    	addi $12,$0,56       # $12 = rio    

   	addi $13,$0,0        # idx geral   
   	addi $14,$0,0        # cont verde  
    	addi $15,$0,0        # cont azul   

    
    	ori  $19,$0,0x8000   # verde  
    	ori  $20,$0,0x33FF   # azul   
    	
    	

LoopMAPA:

    	bge  $13,$10,FimMAPA
 
    	# se verde
    	slt  $2,$14,$11
    	bne  $2,$0,PintaVerde

   	 # se azul
    	slt  $2,$15,$12
    	bne  $2,$0,PintaRio

    	# continua verde
PintaVerdeCont:

   	sw  $19,0($16)
    	addi $14,$14,1
   	j Atualiza

PintaVerde:
    	sw  $19,0($16)
    	addi $14,$14,1
    	j Atualiza

PintaRio:

    	sw  $20,0($16)

    	addi $15,$15,1
    	j Atualiza

Atualiza:

    	addi $16,$16,4      # endere o += 4 bytes
    	addi $13,$13,1   
    	j LoopMAPA

FimMAPA:
    	lw $10,0($sp)
	lw $11,4($sp)
	lw $12,8($sp)
	lw $13,12($sp)
	lw $14,16($sp)
	lw $15,20($sp)
	lw $19,24($sp)
	lw $20,28($sp)
	lw $ra,32($sp)
	addi $sp,$sp,36
    	jr $ra
    
###########################################################################

###########################################################################

DesenhaCasa:
	addi $sp,$sp,-28
	sw $17,0($sp)
	sw $18,4($sp)
	sw $14,8($sp)
	sw $15,12($sp)
	sw $19,16($sp)
	sw $16,20($sp)
	sw $ra,24($sp)
	
    	addi $17,$0,0
    	addi $9,$0,0
    	addi $14,$0,0
    
    	add $23,$0,$7
    	ori  $19,$0,0x8000 # COR VERDE
    	ori  $18,0x98FB98 #Azul
    	ori $14,0x964B00
    	ori $9,0x0000 # Preto
    	ori $17,0xff2400# vermehlo
    	ori $15,0xffff00#amarelo
    	ori $16,0xffffff# Branco
	
    	sw $9,0($23)# inicializa��o da primeira linha
    	sw $9,4($23)
    	sw $9,8($23)
    	sw $9,12($23)
    	sw $9,16($23)
    	sw $9,20($23)
    	sw $9,24($23)
    	sw $9,28($23)
    	sw $9,32($23)
    	sw $9,36($23)
    	sw $9,40($23)
    	sw $9,44($23) 
#########################

    	sw $18,496($23)
	
    	sw $9,508($23) # inicializa��o da segunda linha
    	sw $9,512($23)
    	sw $18,516($23)
    	sw $15,520($23)
    	sw $17,524($23)
    	sw $18,528($23)
    	sw $17,532($23)
    	sw $15,536($23)
    	sw $9,540($23)
    	sw $9,544($23)
    	sw $9,548($23)
    	sw $9,552($23)
    	sw $9,556($23)
    	sw $9,560($23)


#########################

    
    	sw $18,1004($23)
    	sw $15,1008($23)
    	sw $17,1012($23)
    
    
    	sw $18,1024($23)
    	sw $15,1028($23)
    	sw $18,1032($23)
    	sw $18,1036($23)
    	sw $16,1040($23)
    	sw $16,1044($23)
    	sw $16,1048($23)
    	sw $16,1052($23)
    	sw $16,1056($23)
    	sw $16,1060($23)
    	sw $16,1064($23)
    	sw $16,1068($23)
#########################

    	sw $18,1512($23)
    	sw $17,1516($23)
    	sw $18,1520($23)
    	sw $18,1524($23)
	sw $15,1528($23)
    
    	sw $16,1536($23) # inicializa��o da quarta linha
    	#sw $3,-13812($24) janela
    	#sw $3,-13808($24) janela
    	sw $16,1548($23)
    	sw $16,1552($23)
    	#sw $3,-13796($24) janela
    	#sw $3,-13792($24) janela
    	sw $16,1564($23)
    	#sw $3,-13784($24) janela
    	#sw $3,-13780($24) janela
    	sw $16,1576($23)
    	sw $16,1580($23)


#########################
   	sw $14,2032($23)
   
   	sw $16,2048($23)
   	sw $16,2052($23)
   	sw $16,2056($23)
   	sw $16,2060($23)
   	sw $16,2064($23)
   	sw $16,2068($23)
   	sw $16,2072($23)
   	sw $16,2076($23)
   	sw $16,2080($23)
   	sw $16,2084($23)
   	sw $16,2088($23)
   	sw $16,2092($23)
   	
   	lw $17,0($sp)
	lw $18,4($sp)
	lw $14,8($sp)
	lw $15,12($sp)
	lw $19,16($sp)
	lw $16,20($sp)
	lw $ra,24($sp)
	
	addi $sp,$sp,28
   
   	jr $ra
ApagaCasa:

	addi $sp,$sp,-8
	sw $ra,0($sp)
	sw $19,4($sp)
	
	addi $19,$0,0
	ori  $19,$0,0x8000 # COR VERDE
	
   	sw $19,0($7)# inicializa��o da primeira linha
    	sw $19,4($7)
    	sw $19,8($7)
    	sw $19,12($7)
    	sw $19,16($7)
    	sw $19,20($7)
    	sw $19,24($7)
    	sw $19,28($7)
    	sw $19,32($7)
    	sw $19,36($7)
    	sw $19,40($7)
    	sw $19,44($7) 
#########################

    	sw $19,496($7)
	
    	sw $19,508($7) # inicializa��o da segunda linha
    	sw $19,512($7)
    	sw $19,516($7)
    	sw $19,520($7)
    	sw $19,524($7)
    	sw $19,528($7)
    	sw $19,532($7)
    	sw $19,536($7)
    	sw $19,540($7)
    	sw $19,544($7)
    	sw $19,548($7)
    	sw $19,552($7)
    	sw $19,556($7)
    	sw $19,560($7)


#########################

    
    	sw $19,1004($7)
    	sw $19,1008($7)
    	sw $19,1012($7)
    
    
    	sw $19,1024($7)
    	sw $19,1028($7)
    	sw $19,1036($7)
    	sw $19,1040($7)
    	sw $19,1044($7)
    	sw $19,1048($7)
    	sw $19,1052($7)
    	sw $19,1056($7)
    	sw $19,1060($7)
    	sw $19,1064($7)
    	sw $19,1068($7)
#########################

    	sw $19,1512($7)
    	sw $19,1516($7)
    	sw $19,1520($7)
    	sw $19,1524($7)
	sw $19,1528($7)
    
    	sw $19,1536($7) # inicializa��o da quarta linha
    	#sw $3,-13812($24) janela
    	#sw $3,-13808($24) janela
    	sw $19,1548($7)
    	sw $19,1552($7)
    	#sw $3,-13796($24) janela
    	#sw $3,-13792($24) janela
    	sw $19,1564($7)
    	#sw $3,-13784($24) janela
    	#sw $3,-13780($24) janela
    	sw $19,1576($7)
    	sw $19,1580($7)


#########################
   	sw $19,2032($7)
   
   	sw $19,2048($7)
   	sw $19,2052($7)
   	sw $19,2056($7)
   	sw $19,2060($7)
   	sw $19,2064($7)
   	sw $19,2068($7)
   	sw $19,2072($7)
   	sw $19,2076($7)
   	sw $19,2080($7)
   	sw $19,2084($7)
   	sw $19,2088($7)
   	sw $19,2092($7)
   	
   	lw $ra,0($sp)
	lw $19,4($sp)
	addi $sp,$sp,8
   	
   	jr $ra
MoveCasa:
	addiu $sp,$sp,-12
	sw $ra,0($sp)
	sw $9,4($sp)
	sw $8,8($sp)
	
	jal ApagaCasa
	addi $7,$7,512
	
	lui $8,0x1001
	ori $8,$8,45000
	
	slt $9,$7,$8
	bne $9,$0,PulaResetCasa
	
	lui $11,0x1001
	addi $7,$11,76
PulaResetCasa:
	jal DesenhaCasa
	lw $ra,0($sp)
	lw $9,4($sp)
	lw $8,8($sp)
	addiu $sp,$sp,12
	jr $ra
#######################
DesenhaCasa2:
	addi $sp,$sp,-28
	sw $17,0($sp)
	sw $18,4($sp)
	sw $14,8($sp)
	sw $15,12($sp)
	sw $19,16($sp)
	sw $16,20($sp)
	sw $ra,24($sp)
	
    	addi $17,$0,0
    	addi $9,$0,0
    	addi $14,$0,0
    
    	add $6,$0,$7
    	ori  $19,$0,0x8000 # COR VERDE
    	ori  $18,0x98FB98 #Azul
    	ori $14,0x964B00
    	ori $9,0x0000 # Preto
    	ori $17,0xff2400# vermehlo
    	ori $15,0xffff00#amarelo
    	ori $16,0xffffff# Branco

    	sw $9,0($6) # inicializa��o da primeira linha
    	sw $9,4($6)
    	sw $9,8($6)
    	sw $9,12($6)
    	sw $9,16($6)
    	sw $9,20($6)
    	sw $9,24($6)
    	sw $9,28($6)
    	sw $9,32($6)
    	sw $9,36($6)
    	sw $9,40($6)
    	sw $9,44($6)

#########################

    	sw $9,508($6) # inicializa��o da segunda linha
    	sw $9,512($6)
    	sw $18,516($6)
    	sw $15,520($6)
    	sw $17,524($6)
    	sw $18,528($6)
    	sw $17,532($6)
    	sw $15,536($6)
    	sw $9,540($6)
    	sw $9,544($6)
    	sw $9,548($6)
    	sw $9,552($6)
    	sw $9,556($6)
    	sw $9,560($6)

    	sw $18,576($6)

#########################

    	sw $15,1024($6) # inicializa��o da terceira linha
    	sw $16,1028($6)
    	sw $16,1032($6)
    	sw $16,1036($6)
   	sw $16,1040($6)
    	sw $16,1044($6)
    	sw $16,1048($6)
    	sw $18,1052($6)
    	sw $17,1056($6)
    	sw $15,1060($6)
    	sw $18,1064($6)
    	sw $17,1068($6)

    	sw $17,1084($6)
    	sw $15,1088($6)
    	sw $18,1092($6)

#########################

    	sw $16,1536($6) # inicializa��o da quarta linha
    	#sw $3,-3692($24) janela
    	#sw $3,-3688($24) janela
    	sw $16,1548($6)
    	sw $16,1552($6)
    	#sw $3,-3676($24) janela
    	#sw $3,-3672($24) janela
    	sw $16,1564($6)
    	#sw $3,-3664($24) janela
    	#sw $3,-3660($24) janela
    	sw $16,1576($6)
    	sw $15,1580($6)

    	sw $18,1592($6)
    	sw $18,1596($6)
    	sw $18,1600($6)
    	sw $17,1604($6)
    	sw $18,1608($6)

#########################

    	sw $16,2048($6) # inicializa��o da quinta linha
    	sw $16,2052($6)
    	sw $16,2056($6)
    	sw $16,2060($6)
    	sw $16,2064($6)
   	sw $16,2068($6)
    	sw $16,2072($6)
    	sw $16,2076($6)
    	sw $16,2080($6)
    	sw $16,2084($6)
    	sw $16,2088($6)
   	sw $16,2092($6)
    
    	sw $14,2112($6)


	lw $17,0($sp)
	lw $18,4($sp)
	lw $14,8($sp)
	lw $15,12($sp)
	lw $19,16($sp)
	lw $16,20($sp)
	lw $ra,24($sp)
	addi $sp,$sp,28

    	jr $ra
ApagaCasa2:
	addi $sp,$sp,-8
	sw $ra,0($sp)
	sw $19,4($sp)
	
	addi $19,$0,0
	ori  $19,$0,0x8000 # COR VERDE
	
   	sw $19,0($7) # inicializa��o da primeira linha
    	sw $19,4($7)
    	sw $19,8($7)
    	sw $19,12($7)
    	sw $19,16($7)
    	sw $19,20($7)
    	sw $19,24($7)
    	sw $19,28($7)
    	sw $19,32($7)
    	sw $19,36($7)
    	sw $19,40($7)
    	sw $19,44($7)

#########################

    	sw $19,508($7) # inicializa��o da segunda linha
    	sw $19,512($7)
    	sw $19,516($7)
    	sw $19,520($7)
    	sw $19,524($7)
    	sw $19,528($7)
    	sw $19,532($7)
    	sw $19,536($7)
    	sw $19,540($7)
    	sw $19,544($7)
    	sw $19,548($7)
    	sw $19,552($7)
    	sw $19,556($7)
    	sw $19,560($7)

    	sw $19,576($7)

#########################

    	sw $19,1024($7) # inicializa��o da terceira linha
    	sw $19,1028($7)
    	sw $19,1032($7)
    	sw $19,1036($7)
   	sw $19,1040($7)
    	sw $19,1044($7)
    	sw $19,1048($7)
    	sw $19,1052($7)
    	sw $19,1056($7)
    	sw $19,1060($7)
    	sw $19,1064($7)
    	sw $19,1068($7)

    	sw $19,1084($7)
    	sw $19,1088($7)
    	sw $19,1092($7)

#########################

    	sw $19,1536($7) # inicializa��o da quarta linha
    	#sw $3,-3692($24) janela
    	#sw $3,-3688($24) janela
    	sw $19,1548($7)
    	sw $19,1552($7)
    	#sw $3,-3676($24) janela
    	#sw $3,-3672($24) janela
    	sw $19,1564($7)
    	#sw $3,-3664($24) janela
    	#sw $3,-3660($24) janela
    	sw $19,1576($7)
    	sw $19,1580($7)

    	sw $19,1592($7)
    	sw $19,1596($7)
    	sw $19,1600($7)
    	sw $19,1604($7)
    	sw $19,1608($7)

#########################

    	sw $19,2048($7) # inicializa��o da quinta linha
    	sw $19,2052($7)
    	sw $19,2056($7)
    	sw $19,2060($7)
    	sw $19,2064($7)
   	sw $19,2068($7)
    	sw $19,2072($7)
    	sw $19,2076($7)
    	sw $19,2080($7)
    	sw $19,2084($7)
    	sw $19,2088($7)
   	sw $19,2092($7)
    
    	sw $19,2112($7)
	
	sw $ra,0($sp)
	sw $19,4($sp)
	addi $sp,$sp,8
   	
   	jr $ra
MoveCasa2:
	addiu $sp,$sp,-12
	sw $ra,0($sp)
	sw $9,4($sp)
	sw $8,8($sp)
	
	jal ApagaCasa2
	addi $7,$7,512

	lui $8,0x1001
	ori $8,$8,45000
	
	slt $9,$7,$8
	bne $9,$0,PulaResetCasa2
	
	lui $6,0x1001
	addi $7,$6,400
PulaResetCasa2:
	jal DesenhaCasa2
	lw $ra,0($sp)
	lw $9,4($sp)
	lw $8,8($sp)
	addiu $sp,$sp,12
	jr $ra
    	
DesenhaAviao:
	addi $sp,$sp,-8
	sw $15,0($sp)
	sw $ra,4($sp)
	
	addi $15,$0,0
	ori $15,0xffff00
	
	
	
	sw $15, 0($3) 
	sw $15, 4($3) 
	
	sw $15, 512($3) 
	sw $15, 516($3) 
	
	sw $15, 1016($3) 
	sw $15, 1020($3) 
	sw $15, 1024($3) 
	sw $15, 1028($3) 
	sw $15, 1032($3) 
	sw $15, 1036($3)
	
	sw $15, 1520($3) 
	sw $15, 1524($3) 
	sw $15, 1528($3) 
	sw $15, 1532($3) 
	sw $15, 1536($3) 
	sw $15, 1540($3)
	sw $15, 1544($3) 
	sw $15, 1548($3) 
	sw $15, 1552($3) 
	sw $15, 1556($3) 

	sw $15, 2028($3)
	sw $15, 2032($3)
	sw $15, 2036($3)
	
	sw $15, 2048($3)
	sw $15, 2052($3)

	sw $15, 2064($3)
	sw $15, 2068($3)
	sw $15, 2072($3)
	
	sw $15, 2560($3)
	sw $15, 2564($3)
	
	sw $15, 3072($3)
	sw $15, 3076($3)
	
	sw $15, 3576($3) 
	sw $15, 3580($3) 
	sw $15, 3584($3) 
	sw $15, 3588($3) 
	sw $15, 3592($3) 
	sw $15, 3596($3)
	
	sw $15, 4088($3) 

	sw $15, 4096($3) 
	sw $15, 4100($3) 

	sw $15, 4108($3)
	
	lw $15,0($sp)
	lw $ra,4($sp)
	addi $sp,$sp,8
	
    	jr $ra
    
DesenhaNavio:
	addi $sp,$sp,-16
	sw $9,0($sp)
	sw $17,4($sp)
	sw $ra,8($sp)
	sw $27,12($sp)
	
	addi $17,$0,0
	ori $17,0xff0000
	
	add $27,$0,$7
	
	addi $9,$0,0
	ori $9,0x0000
	
	sw $9,0($27)
	
	sw $9, 512($27)
	sw $9, 516($27)
	
	sw $9, 1024($27)
	sw $9, 1028($27)
	sw $9, 1032($27)
	
	sw $17, 1524($27)
	sw $17, 1528($27)
	sw $17, 1532($27)
	sw $17, 1536($27)
	sw $17, 1540($27)
	sw $17, 1544($27)
	sw $17, 1548($27)
	sw $17, 1552($27)
	sw $17, 1556($27)
	
	sw $9, 2036($27)
	sw $9, 2040($27)
	sw $9, 2044($27)
	sw $9, 2048($27)
	sw $9, 2052($27)
	sw $9, 2056($27)
	sw $17, 2060($27)
	sw $17, 2064($27)
	sw $17, 2068($27)
	
	sw $9, 2552($27)
	sw $9, 2556($27)
	sw $9, 2560($27)
	sw $9, 2564($27)
	sw $9, 2568($27)
	sw $9, 2572($27)
	sw $9, 2576($27)

	lw $9,0($sp)
	lw $17,4($sp)
	lw $ra,8($sp)
	lw $27,12($sp)
	addi $sp,$sp,16
	
	jr $ra
MoveNavio:
	addiu $sp,$sp,-12
	sw $ra,0($sp)
	sw $9,4($sp)
	sw $8,8($sp)
	
	
	jal ApagaNavio
	addi $7,$7,512

	lui $8,0x1001
	ori $8,$8,45312
	
	slt $9,$7,$8
	bne $9,$0,PulaResetNavio
	
	lw $4,700($24)
	jal RandomizarSeguro
	add $7,$0,$2
PulaResetNavio:
        
	jal DesenhaNavio
	lw $ra,0($sp)
	lw $9,4($sp)
	lw $8,8($sp)
	addiu $sp,$sp,12
	jr $ra
	
ApagaNavio:

	addi $sp,$sp,-8
	sw $20,0($sp)
	sw $ra,4($sp)
	addi $20,$0,0
	 
    	ori  $20,$0,0x33FF   # azul   
	
	sw $20,0($7)
	
	sw $20, 512($7)
	sw $20, 516($7)
	
	sw $20, 1024($7)
	sw $20, 1028($7)
	sw $20, 1032($7)
	
	sw $20, 1524($7)
	sw $20, 1528($7)
	sw $20, 1532($7)
	sw $20, 1536($7)
	sw $20, 1540($7)
	sw $20, 1544($7)
	sw $20, 1548($7)
	sw $20, 1552($7)
	sw $20, 1556($7)
	
	sw $20, 2036($7)
	sw $20, 2040($7)
	sw $20, 2044($7)
	sw $20, 2048($7)
	sw $20, 2052($7)
	sw $20, 2056($7)
	sw $20, 2060($7)
	sw $20, 2064($7)
	sw $20, 2068($7)
	
	sw $20, 2552($7)
	sw $20, 2556($7)
	sw $20, 2560($7)
	sw $20, 2564($7)
	sw $20, 2568($7)
	sw $20, 2572($7)
	sw $20, 2576($7)
	
	lw $20,0($sp)
	lw $ra,4($sp)
	addi $sp,$sp,8
	
	jr $ra
	
DesenhaFloco:
	
	addi $sp,$sp,-8
	sw $19,0($sp)
	sw $ra,4($sp)
	
	addi $19,$0,0
	ori $19,0xF0F8FF
	
	add $26,$0,$7
	
	sw $19, 0($26)
	sw $19, 8($26)
	sw $19, 16($26)
	
	sw $19, 516($26)
	sw $19, 520($26)
	sw $19, 524($26)
	
	sw $19, 1024($26)
	sw $19, 1028($26)
	sw $19, 1032($26)
	sw $19, 1036($26)
	sw $19, 1040($26)
	
	sw $19, 1540($26)
	sw $19, 1544($26)
	sw $19, 1548($26)
	
	sw $19, 2048($26)
	sw $19, 2056($26)
	sw $19, 2064($26)
	
	lw $19,0($sp)
	lw $ra,4($sp)
	
	addi $sp,$sp,8
	
	jr $ra
MoveFloco:
	addiu $sp,$sp,-12
	sw $ra,0($sp)
	sw $9,4($sp)
	sw $8,8($sp)
	
	jal ApagaFloco
	addi $7,$7,512
	
	lui $8,0x1001
	addi $8,$8,45312
	
	slt $9,$7,$8
	bne $9,$0,PulaResetFloco
	
	lw $4,800($24)
	jal RandomizarSeguro
	add $7,$0,$2
PulaResetFloco:
	jal DesenhaFloco
	lw $ra,0($sp)
	lw $9,4($sp)
	lw $8,8($sp)
	addiu $sp,$sp,12
	jr $ra
ApagaFloco:
	addi $19,$0,0
	 
    	ori  $19,$0,0x33FF
    	
	sw $19, 0($7)
	sw $19, 8($7)
	sw $19, 16($7)
	
	sw $19, 516($7)
	sw $19, 520($7)
	sw $19, 524($7)
	
	sw $19, 1024($7)
	sw $19, 1028($7)
	sw $19, 1032($7)
	sw $19, 1036($7)
	sw $19, 1040($7)
	
	sw $19, 1540($7)
	sw $19, 1544($7)
	sw $19, 1548($7)
	
	sw $19, 2048($7)
	sw $19, 2056($7)
	sw $19, 2064($7)
	
	jr $ra
DesenhaCombustivel:
	addi $sp,$sp,-12
	sw $ra,0($sp)
	sw $15,4($sp)
	sw $16,8($sp)
	
	addi $15,$0,0xFF4500
	
	add $16,$0,$7
	
	sw $15,0($16)
	sw $15,4($16)
	
	sw $15,512($16)
	sw $15,516($16)
	
	sw $15,1024($16)
	sw $15,1028($16)
	
	lw $ra,0($sp)
	lw $15,4($sp)
	lw $16,8($sp)
	
	addi $sp,$sp,12
	jr $ra
ApagaCombustivel:
	addi $sp,$sp,-8
	sw $ra,0($sp)
	sw $15,4($sp)
	
	
	addi $15,$0,0x000033FF
	
	sw $15,0($7)
	sw $15,4($7)
	
	sw $15,512($7)
	sw $15,516($7)
	
	sw $15,1024($7)
	sw $15,1028($7)
	
	lw $ra,0($sp)
	lw $15,4($sp)
	addi $sp,$sp,8
	jr $ra
MoveCombustivel:
	addi $sp,$sp,-12
	sw $ra,0($sp)
	sw $8,4($sp)
	sw $9,8($sp)
	
	jal ApagaCombustivel
	
	addi $7,$7,512
	
	lui $8,0x1001
	ori $8,$8,45312
	
	slt $9,$7,$8
	bne $9,$0,PulaResetCombustivel
	
	lw $4,400($24)
	jal RandomizarSeguro
	add $7,$0,$2
PulaResetCombustivel:
	sw $7,400($24)
	jal DesenhaCombustivel
	
	lw $ra,0($sp)
	lw $8,4($sp)
	lw $9,8($sp)
	
	addi $sp,$sp,12
	jr $ra
MoveTiro:
	
	addiu $sp,$sp,-20
	sw $25,16($sp)
	sw $15,12($sp)
	sw $24,8($sp)
	sw $12,4($sp)
	sw $ra,0($sp)
	
	lw $25,200($24)
	beq $25,$0,FimMoveTiro
	
	addi $12,$0,0x000033ff
	sw $12,0($25)
	sw $12,4($25)
	

	addi $25,$25,-512

	li $8,0x10010400
	slt $9,$25,$8
	bne $9,$0,DesativarTiro
	
	addi $15,$0,0xffff0000
	sw $15,0($25)
	sw $15,4($25)
	
	sw $25,200($24)
	
	j FimMoveTiro
DesativarTiro:
	sw $0,100($24)
	sw $0,200($24)
FimMoveTiro:
	lw $25,16($sp)
	lw $15,12($sp)
	lw $24,8($sp)
	lw $12,4($sp)
	lw $ra,0($sp)
	
	addiu $sp,$sp,20
	
	jr $ra
	
ChecarColisao:
	addi $sp,$sp,-44
	sw $ra,0($sp)
	sw $9,4($sp)
	sw $10,8($sp)
	sw $11,12($sp)
	sw $12,16($sp)
	sw $14,20($sp)
	sw $4,24($sp)
	sw $5,28($sp)
	sw $6,32($sp)
	sw $7,36($sp)
	sw $2,40($sp)
	
	addi $8,$0,0xffff0000
	addi $9,$0,0x000033ff
	addi $12,$0,0x00000000
	addi $13,$0,0x00f0f8ff
	
	
	
	lw $10,200($24)
	beq $10,$0,FimColisao
	
	lw $11,-512($10)
	
	
	beq $11,$9,FimColisao
	
	beq $11,$13,ColidiuFloco
	
	
	j ColidiuNavio
	
ColidiuNavio:
	lw $7,800($24)

	addi $4, $0, 10		# Nota Sol
	addi $5, $0, 400
    	addi $6, $0, 12		# Instrumento
        addi $7, $0, 300	# Volume
	addi $2, $0, 31		
	syscall
	
	lw $7,800($24)
	
	jal ApagaNavio
	
	lw $4,800($24)
	jal RandomizarSeguro
	sw $2,800($24)
	
	lw $10,200($24)
	beq $10,$0,PularApagaTiro
	
	addi $12,$0,0x000033ff
	sw $12,0($10)
	sw $12,4($10)
PularApagaTiro:
	sw $0,100($24)
	sw $0,200($24)
	j FimColisao
ColidiuFloco:
	lw $7,700($24)
	
	addi $4, $0, 10		# Nota Sol
	addi $5, $0,400
    	addi $6, $0, 12		# Instrumento
        addi $7, $0, 300	# Volume
	addi $2, $0, 31		
	syscall
	
	lw $7,700($24)
	
	jal ApagaFloco
	
	lw $4,700($24)
	jal RandomizarSeguro
	sw $2,700($24)
	
	lw $10,200($24)
	beq $10,$0,PularApagaFloco
	
	addi $12,$0,0x000033ff
	sw $12,0($10)
	sw $12,4($10)
PularApagaFloco:
	sw $0,100($24)
	sw $0,200($24)
	j FimColisao
FimColisao:
	lw $ra,0($sp)
	lw $9,4($sp)
	lw $10,8($sp)
	lw $11,12($sp)
	lw $12,16($sp)
	lw $14,20($sp)
	lw $4,24($sp)
	lw $5,28($sp)
	lw $6,32($sp)
	lw $7,36($sp)
	lw $2,40($sp)
	
	addi $sp,$sp,44
	jr $ra

	
	
ChecarColisaoInimigo:
	addi $sp,$sp,-4
	sw $ra,0($sp)
	
	lw $27,800($24)
	lw $26,700($24)
	
	sub $8,$3,$27 #$8 = (Endereço Avião) - (Endereço Navio)
	abs $8,$8
	# Testa se o navio está muito acima
	
	li $9,3500    ## 4500 bytes sao quase 9 linhas de distância
	bgt $8,$9,ChecaFloco # Se a diferença > 4500, o avião está muito abaixo do navio
	
	
	# SE O CODIGO CHEGOU AQUI ELES ESTAO NA MESA FAIXA DE LINHAS
	
	# Teste de colunas
	andi $10,$3,0x1ff # faz um and com endereço do aviao e 0x1ff para obter a coluna do aviao
	andi $11,$27,0x1ff # faz um and com endereço do navio e 0x1ff para obter a coluna do navio
	sub $12,$10,$11 # 12 =  distancia entre as colunas
	
	abs $12,$12 # vira positivo
	li $13,45 # Teste se estão a menos de 45 bytes
	blt $12,$13,Game_over # game_over
ChecaFloco:
	sub $8,$3,$26
	abs $8,$8
	li $9,3500
	bgt $8,$9,FimColisaoInimigo
	
	andi $10,$3,0x1ff
	andi $11,$26,0x1ff
	sub $12,$10,$11
	abs $12,$12
	li $13,30
	blt $12,$13,Game_over
FimColisaoInimigo:
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra
Game_over:
	addi $2,$0,10
	syscall
	
#################################
AtualizaJogador:
	addiu $sp, $sp,-28
	sw $13,24($sp)
	sw $17,20($sp)  #status register
	sw $20,16($sp)  # leitura da tecla pressionada
	sw $21,12($sp)  # tecla
	sw $ra,8($sp)
	sw $8,4($sp)
	sw $19,0($sp)
	ori $15, 0xffff00#amarelo 
	ori $14,0x33FF #azul


	lui $17,0xffff
AtualizaJogadorLoop:
	
	lw $18,0($17)
	beq $18,$0,continue
	lw $20,4($17)
	addi $21,$0,' '
	beq $21,$20,fimJogo
	addi $21,$0,'d'
	beq $21,$20,moveR
	addi $21,$0,'a'
	beq $21,$20,moveL
	addi $21,$0,'w'
	beq $21,$20,shoot

moveR:
	
	andi $8,$3,0x1FF
	li $9,340
	bge $8,$9,continue
	
	

	sw $14, 0($3) 
	sw $14, 4($3) 
	
	sw $14, 512($3) 
	sw $14, 516($3) 
	
	sw $14, 1016($3) 
	sw $14, 1020($3) 
	sw $14, 1024($3) 
	sw $14, 1028($3) 
	sw $14, 1032($3) 
	sw $14, 1036($3)
	
	sw $14, 1520($3) 
	sw $14, 1524($3) 
	sw $14, 1528($3) 
	sw $14, 1532($3) 
	sw $14, 1536($3) 
	sw $14, 1540($3)
	sw $14, 1544($3) 
	sw $14, 1548($3) 
	sw $14, 1552($3) 
	sw $14, 1556($3) 

	sw $14, 2028($3)
	sw $14, 2032($3)
	sw $14, 2036($3)
	
	sw $14, 2048($3)
	sw $14, 2052($3)

	sw $14, 2064($3)
	sw $14, 2068($3)
	sw $14, 2072($3)
	
	sw $14, 2560($3)
	sw $14, 2564($3)
	
	sw $14, 3072($3)
	sw $14, 3076($3)
	
	sw $14, 3576($3) 
	sw $14, 3580($3) 
	sw $14, 3584($3) 
	sw $14, 3588($3) 
	sw $14, 3592($3) 
	sw $14, 3596($3)
	
	sw $14, 4088($3) 

	sw $14, 4096($3) 
	sw $14, 4100($3) 

	sw $14, 4108($3)
	
	
	
	addi $3,$3,4 #SALVAR A POSI��O 4 BYTES ATRAS
	################
	sw $15, 0($3) 
	sw $15, 4($3) 
	
	sw $15, 512($3) 
	sw $15, 516($3) 
	
	sw $15, 1016($3) 
	sw $15, 1020($3) 
	sw $15, 1024($3) 
	sw $15, 1028($3) 
	sw $15, 1032($3) 
	sw $15, 1036($3)
	
	sw $15, 1520($3) 
	sw $15, 1524($3) 
	sw $15, 1528($3) 
	sw $15, 1532($3) 
	sw $15, 1536($3) 
	sw $15, 1540($3)
	sw $15, 1544($3) 
	sw $15, 1548($3) 
	sw $15, 1552($3) 
	sw $15, 1556($3) 

	sw $15, 2028($3)
	sw $15, 2032($3)
	sw $15, 2036($3)
	
	sw $15, 2048($3)
	sw $15, 2052($3)

	sw $15, 2064($3)
	sw $15, 2068($3)
	sw $15, 2072($3)
	
	sw $15, 2560($3)
	sw $15, 2564($3)
	
	sw $15, 3072($3)
	sw $15, 3076($3)
	
	sw $15, 3576($3) 
	sw $15, 3580($3) 
	sw $15, 3584($3) 
	sw $15, 3588($3) 
	sw $15, 3592($3) 
	sw $15, 3596($3)
	
	sw $15, 4088($3) 

	sw $15, 4096($3) 
	sw $15, 4100($3) 

	sw $15, 4108($3)
	
	
    	j continue
moveL:

	andi $8,$3,0x1FF
	li $9,160
	ble $8,$9,continue
	
	sw $14, 0($3) 
	sw $14, 4($3) 
	
	sw $14, 512($3) 
	sw $14, 516($3) 
	
	sw $14, 1016($3) 
	sw $14, 1020($3) 
	sw $14, 1024($3) 
	sw $14, 1028($3) 
	sw $14, 1032($3) 
	sw $14, 1036($3)
	
	sw $14, 1520($3) 
	sw $14, 1524($3) 
	sw $14, 1528($3) 
	sw $14, 1532($3) 
	sw $14, 1536($3) 
	sw $14, 1540($3)
	sw $14, 1544($3) 
	sw $14, 1548($3) 
	sw $14, 1552($3) 
	sw $14, 1556($3) 

	sw $14, 2028($3)
	sw $14, 2032($3)
	sw $14, 2036($3)
	
	sw $14, 2048($3)
	sw $14, 2052($3)

	sw $14, 2064($3)
	sw $14, 2068($3)
	sw $14, 2072($3)
	
	sw $14, 2560($3)
	sw $14, 2564($3)
	
	sw $14, 3072($3)
	sw $14, 3076($3)
	
	sw $14, 3576($3) 
	sw $14, 3580($3) 
	sw $14, 3584($3) 
	sw $14, 3588($3) 
	sw $14, 3592($3) 
	sw $14, 3596($3)
	
	sw $14, 4088($3) 

	sw $14, 4096($3) 
	sw $14, 4100($3) 

	sw $14, 4108($3)
	
	addi $3,$3,-4 #SALVAR A POSI��O 4 BYTES ATRAS
	################
	sw $15, 0($3) 
	sw $15, 4($3) 
	
	sw $15, 512($3) 
	sw $15, 516($3) 
	
	sw $15, 1016($3) 
	sw $15, 1020($3) 
	sw $15, 1024($3) 
	sw $15, 1028($3) 
	sw $15, 1032($3) 
	sw $15, 1036($3)
	
	sw $15, 1520($3) 
	sw $15, 1524($3) 
	sw $15, 1528($3) 
	sw $15, 1532($3) 
	sw $15, 1536($3) 
	sw $15, 1540($3)
	sw $15, 1544($3) 
	sw $15, 1548($3) 
	sw $15, 1552($3) 
	sw $15, 1556($3) 

	sw $15, 2028($3)
	sw $15, 2032($3)
	sw $15, 2036($3)
	
	sw $15, 2048($3)
	sw $15, 2052($3)

	sw $15, 2064($3)
	sw $15, 2068($3)
	sw $15, 2072($3)
	
	sw $15, 2560($3)
	sw $15, 2564($3)
	
	sw $15, 3072($3)
	sw $15, 3076($3)
	
	sw $15, 3576($3) 
	sw $15, 3580($3) 
	sw $15, 3584($3) 
	sw $15, 3588($3) 
	sw $15, 3592($3) 
	sw $15, 3596($3)
	
	sw $15, 4088($3) 

	sw $15, 4096($3) 
	sw $15, 4100($3) 

	sw $15, 4108($3)
	
    	j continue
	
shoot:	
	
	addi $8,$0,0xffff0000
	
	lw $19,100($24)
	bne $19,$0,FimMoveTiro
	
	addi $19,$0,1
	sw $19,100($24)
	
	addi $13,$3,-512
	
	sw $13,200($24)
continue:
	lw $13,24($sp)
	lw $17,20($sp)  #status register
	lw $20,16($sp)  # leitura da tecla pressionada
	lw $21,12($sp)  # tecla
	lw $ra,8($sp)
	lw $8,4($sp)
	lw $19,0($sp)
	
	addiu $sp,$sp,28
	jr $ra
	

AtualizarLinhas:

	add $22,$0,$ra
	jal MoveNavio
	add $ra,$0,$22
fimJogo:
	addiu $sp, $sp, 28
	jr $ra
	
FimAtualizacao:
	jr $ra
	
##########################################
Randomizar:
	addi $sp,$sp,-16
	sw $ra,0($sp)
	sw $8,4($sp)
	sw $5,8($sp)
	sw $4,12($sp)

	
	addi $5,$0,44
	addi $4,$0,0
	addi $2,$0,42
	syscall
	
	addi $4,$4,40
	
	sll $8,$4,2
	
	
	lui $2,0x1001
	addu $2,$2,$8

	
	lw $ra,0($sp)
	lw $8,4($sp)
	lw $5,8($sp)
	lw $4,12($sp)
	addi $sp,$sp,16
	
	jr $ra
	
RandomizarSeguro:
	addi $sp,$sp,-8
	sw $ra,0($sp)
	sw $16,4($sp)
	
	add $16,$0,$4
LoopSeguro:
	jal Randomizar
	sub $8,$2,$16
	
	abs $8,$8
	
	li $9,52
	blt $8,$9,LoopSeguro
	
	lw $ra,0($sp)
	lw $16,4($sp)
	addi $sp,$sp,8
	jr $ra
	
###########################################
# Fun  o: DesenhaHUD
#
# REGISTRADORES UTILIZADOS:
# $5  - Endere o base atual na memoria (varia a cada pixel)
# $6  - Endere o inicial do HUD (passado da main)
# $8  - Cor cinza do HUD (0x404040)
# $17 - Contador de linhas (0..63)
# $18 - Contador de pixeis (0..127)
#
# OBS: N o precisa preservar nenhum registrador
# porque nenhum deles precisa manter valor ap s retorno
###########################################

	
DesenhaHUD:
	addi $sp,$sp,-32
	sw $ra,0($sp)
	sw $5,4($sp)
	sw $6,8($sp)
	sw $8,12($sp)
	sw $9,16($sp)
	sw $17,20($sp)
	sw $18,24($sp)
	sw $19,28($sp)
	

	lui $5,0x1001         # fazer do hud algo separado do background
	lui $6,0x1001
	
	addi $5,$5,49152   # pula pra linha 50
	
	
	ori $8,$0,0x404040	#cinzinha ne pai
	ori $9,$0,0x000000
	addi $17,$0,0 		# Contador de linhas
	
Loop:
	bge $17,40,FimLoop
	addi $18,$0,0
LoopLinha:
	bge $18,128,AtualizaLinha
	sw $8,0($5)
	
	addi $5,$5,4
	addi $18,$18,1
	j LoopLinha
AtualizaLinha:
	addi $17,$17,1
	j Loop
FimLoop:
	addi $6,$6,56320
	addi $6,$6,180
	ori $9,0x232323
Loopi:
	bge $19,38,Fimm
	
	sw $9,0($6)
	
	addi $19,$19,1
	addi $6,$6,4
	j Loopi
Fimm:
	add $6,$6,360 # quando chegar no ultimo ponto do hud, adicionar 360 para voltar para o priemrio ponto na proxima linha
	sw $9,0($6)
	
	add $6,$6,12
	
	sw $9,0($6)
	
	add $6,$6,4
	
	sw $9,0($6)
	
	add $6,$6,20
	add $6,$6,20
	add $6,$6,20
	
	sw $9,0($6)
	add $6,$6,-4
	sw $9,0($6)
	
	add $6,$6,20
	add $6,$6,20
	add $6,$6,20
	
	sw $9,0($6)
	add $6,$6,4
	sw $9,0($6)
	
	add $6,$6,4
	add $6,$6,4
	add $6,$6,4
	
	sw $9,0($6)
	############
	add $6,$6,360
	add $6,$6,4
	
	sw $9,0($6)
	
	add $6,$6,12
	
	sw $9,0($6)
	
	add $6,$6,4
	
	sw $9,0($6)
	
	add $6,$6,20
	add $6,$6,20
	add $6,$6,20
	
	sw $9,0($6)
	add $6,$6,-4
	sw $9,0($6)
	
	add $6,$6,20
	add $6,$6,20
	add $6,$6,20
	
	sw $9,0($6)
	add $6,$6,4
	sw $9,0($6)
	
	add $6,$6,4
	add $6,$6,4
	add $6,$6,4
	
	sw $9,0($6)
	###########
	add $6,$6,360
	add $6,$6,4
	
	sw $9,0($6)
	
	add $6,$6,20
	add $6,$6,20
	add $6,$6,20
	
	sw $9,0($6)
	
	add $6,$6,20
	add $6,$6,4
	add $6,$6,4
	
	
	sw $9,0($6)
	
	add $6,$6,20
	add $6,$6,20
	add $6,$6,20
	
	
	sw $9,0($6)
	
	
	##########
	add $6,$6,360
	add $6,$6,4
	
	sw $9,0($6)
	
	add $6,$6,12
	
	sw $9,0($6)
	
	add $6,$6,4
	
	sw $9,0($6)
	
	add $6,$6,4
	
	sw $9,0($6)
	
	add $6,$6,4
	
	sw $9,0($6)
	
	add $6,$6,20
	add $6,$6,20
	addi $6,$6,-4
	addi $6,$6,-4
	
	sw $9,0($6)
	
	add $6,$6,4
	
	sw $9,0($6)
	
	add $6,$6,4
	add $6,$6,4
	add $6,$6,4
	add $6,$6,4
	add $6,$6,4
	add $6,$6,4
	
	sw $9,0($6)
	
	add $6,$6,20
	add $6,$6,20
	add $6,$6,-4
	
	sw $9,0($6)
	
	add $6,$6,4
	
	sw $9,0($6)
	
	add $6,$6,4
	
	sw $9,0($6)
	
	add $6,$6,4
	
	sw $9,0($6)
	
	add $6,$6,4
	
	sw $9,0($6)
	
	add $6,$6,12
	
	sw $9,0($6)
	##########
	add $6,$6,364
	
	sw $9,0($6)
	
	add $6,$6,12
	
	sw $9,0($6)
	
	add $6,$6,20
	add $6,$6,20
	addi $6,$6,4
	addi $6,$6,4
	
	sw $9,0($6)
	
	add $6,$6,20
	
	sw $9,0($6)
	
	add $6,$6,20
	add $6,$6,20
	sw $9,0($6)
	
	add $6,$6,20
	addi $6,$6,4
	addi $6,$6,4
	sw $9,0($6)
	############
	add $6,$6,364
	
	sw $9,0($6)
	
	add $6,$6,12
	
	sw $9,0($6)
	
	addi $6,$6,4
	
	sw $9,0($6)
	
	addi $6,$6,4
	
	sw $9,0($6)
	
	add $6,$6,20
	
	add $6,$6,20
	
	sw $9,0($6)
	
	addi $6,$6,-4
	
	sw $9,0($6)
	
	addi $6,$6,4
	addi $6,$6,4
	
	sw $9,0($6)
	
	addi $6,$6,4
	addi $6,$6,4
	addi $6,$6,4
	
	sw $9,0($6)
	
	add $6,$6,16
	
	sw $9,0($6)
	
	addi $6,$6,4
	
	sw $9,0($6)

	addi $6,$6,4

	sw $9,0($6)
	
	addi $6,$6,4

	sw $9,0($6)
	
	addi $6,$6,4
	addi $6,$6,4
	addi $6,$6,4
	addi $6,$6,4
	
	sw $9,0($6)
	
	addi $6,$6,4

	sw $9,0($6)
	
	addi $6,$6,4
	
	sw $9,0($6)
	
	add $6,$6,20
	
	sw $9,0($6)
	############ 
	add $6,$6,364
	
	sw $9,0($6)
	
	add $6,$6,12
	
	sw $9,0($6)
	
	add $6,$6,20
	add $6,$6,20
	add $6,$6,20
	
	sw $9,0($6)
	
	add $6,$6,20
	addi $6,$6,4
	addi $6,$6,4
	addi $6,$6,4

	sw $9,0($6)
	
	addi $6,$6,4
	addi $6,$6,4
	addi $6,$6,4
	addi $6,$6,4
	
	sw $9,0($6)
	
	add $6,$6,20
	
	addi $6,$6,4
	addi $6,$6,4
	
	sw $9,0($6)
	###########
	add $6,$6,364
	
	sw $9,0($6)
	
	add $6,$6,12
	
	sw $9,0($6)
	
	addi $6,$6,4
	
	sw $9,0($6)
	
	addi $6,$6,4
	
	sw $9,0($6)
	
	addi $6,$6,4
	
	sw $9,0($6)
	
	add $6,$6,20
	add $6,$6,20
	addi $6,$6,4
	
	sw $9,0($6)
	
	add $6,$6,20
	addi $6,$6,4
	
	sw $9,0($6)
	
	addi $6,$6,4
	
	sw $9,0($6)
	
	addi $6,$6,4
	
	sw $9,0($6)
	
	addi $6,$6,4
	
	sw $9,0($6)
	
	add $6,$6,20
	addi $6,$6,-4
	
	sw $9,0($6)
	
	add $6,$6,28
	
	sw $9,0($6)
	###########
	add $6,$6,364
	
	sw $9,0($6)
	
	add $6,$6,20
	add $6,$6,20
	add $6,$6,20
	add $6,$6,20
	
	add $6,$6,8
	addi $6,$6,4
	sw $9,0($6)
	
	add $6,$6,20
	add $6,$6,20
	add $6,$6,16
	sw $9,0($6)
	###########
	add $6,$6,364

	sw $9,0($6)
	
	add $6,$6,20
	add $6,$6,20
	add $6,$6,20
	add $6,$6,20
	add $6,$6,12
	
	sw $9,0($6)
	
	addi $6,$6,4
	
	sw $9,0($6)
	
	addi $6,$6,4
	
	sw $9,0($6)
	
	addi $6,$6,4
	
	sw $9,0($6)
	
	add $6,$6,20
	add $6,$6,20
	addi $6,$6,4
	
	sw $9,0($6)
	###########
	add $6,$6,364
	sw $9,0($6)
	
	add $19,$0,0
Loopis:
	
	bge $19,38,Fimmm
	
	sw $9,0($6)
	
	addi $19,$19,1
	addi $6,$6,4
	j Loopis
Fimmm:
	lw $ra,0($sp)
	lw $5,4($sp)
	lw $6,8($sp)
	lw $8,12($sp)
	lw $9,16($sp)
	lw $17,20($sp)
	lw $18,24($sp)
	lw $19,28($sp)
	
	addi $sp,$sp,32
	jr $ra
##############################################
	

ApagaEntidade:

	sw $19,0($24) #inicializa��o da primeira linha
    	sw $19,4($24)
    	sw $19, 8($24) 
    	sw $19,12($24)
    	sw $19, 16($24)
    	sw $19, 20($24)
    	sw $19,24($24)
    	sw $19, 28($24)
    	sw $19, 32($24)
    	sw $19,36($24)
    	sw $19, 40($24)
    	sw $19, 44($24)

#########################
    	    	
    	sw $19,508($24) #inicializa��o da segunda linha
    	sw $19,512($24) 
    	sw $19,516($24)
    	sw $19,520($24)
    	sw $19,524($24)
    	sw $19,528($24) 
    	sw $19,532($24)
    	sw $19,536($24)
    	sw $19,540($24)
    	sw $19,544($24) 
    	sw $19,548($24)
    	sw $19,552($24)
    	sw $19,556($24)
    	sw $19,560($24)
    	
    	sw $19,576($24)

#########################
    		
    	sw $19,1024($24) #inicializa��o da terceira linha
    	sw $19,1028($24)
    	sw $19,1032($24)
    	sw $19,1036($24)
    	sw $19,1040($24) 
    	sw $19,1044($24)
    	sw $19,1048($24)
    	sw $19,1052($24)
    	sw $19,1056($24) 
    	sw $19,1060($24)
    	sw $19,1064($24)
    	sw $19,1068($24)
    	
    	sw $19,1084($24)
    	sw $19,1088($24)
    	sw $19,1092($24)
    	

#########################
    	
    	sw $19,1536($24) #inicializa��o da quarta linha
    	#sw $3, 1540($24) janela
	#sw $3, 1544($24) janela
    	sw $19,1548($24)
    	sw $19,1552($24)
    	#sw $3,1556($24) janela
	#sw $3,1560($24) janela
    	sw $19,1564($24)
	#sw $3,1568($24) janela
	#sw $3,1572($24) janela
    	sw $19,1576($24)
    	sw $19, 1580($24)
    	
    	sw $19,1592($24)
    	sw $19,1596($24)
    	sw $19,1600($24)
    	sw $19,1604($24)
    	sw $19,1608($24)
    
########################
    
    	sw $19,2048($24) #inicializa��o da quinta linha
    	sw $19,2052($24)
    	sw $19,2056($24)
    	sw $19,2060($24)
    	sw $19,2064($24) 
    	sw $19,2068($24)
    	sw $19,2072($24)
    	sw $19,2076($24)
    	sw $19,2080($24) 
    	sw $19,2084($24)
    	sw $19,2088($24)
    	sw $19,2092($24)
    	
    	sw $19,2112($24)
##############################
	
DesenhaSplash:
	addi $sp,$sp,-12
	sw $15,8($sp)
	sw $27,4($sp)
	sw $ra,0($sp)
	
	ori $15,0x964B00
	
	lui $27,0x1001
	
	
	addi $27,$27,4288
	
	sw $15,0($27)
	sw $15,4($27)
	sw $15,8($27)
	sw $15,12($27)
	
	
	sw $15,32($27)
	
	sw $15,48($27)
	
	sw $15,72($27)
	
	sw $15,88($27)
	sw $15,92($27)
	sw $15,96($27)
	sw $15,100($27)
	sw $15,104($27)
	
	sw $15,116($27)
	sw $15,120($27)
	sw $15,124($27)
	sw $15,128($27)
	
	
	sw $15,512($27)
	sw $15,528($27)
	
	sw $15,544($27)
	
	sw $15,560($27)
	sw $15,584($27)
	
	sw $15,600($27)
	
	sw $15,628($27)
	
	sw $15,644($27)
	##############
	sw $15,1024($27)
	
	sw $15,1040($27)
	
	sw $15,1056($27)
	
	sw $15,1076($27)
	
	sw $15,1092($27)
	
	sw $15,1112($27)
	
	sw $15,1140($27)
	
	sw $15,1156($27)
	##############
	sw $15,1536($27)
	sw $15,1540($27)
	sw $15,1544($27)
	sw $15,1548($27)
	
	
	sw $15,1568($27)
	
	sw $15,1588($27)
	
	sw $15,1604($27)
	
	sw $15,1624($27)
	sw $15,1628($27)
	sw $15,1632($27)
	sw $15,1636($27)
	
	sw $15,1652($27)
	sw $15,1656($27)
	sw $15,1660($27)
	sw $15,1664($27)
	
	##############
	
	sw $15,2048($27)
	sw $15,2052($27)
	
	sw $15,2080($27)
	
	sw $15,2104($27)
	
	sw $15,2112($27)

	sw $15,2136($27)
	
	sw $15,2164($27)
	sw $15,2168($27)
	
	##############
	
	sw $15,2560($27)
	
	sw $15,2568($27)
	
	sw $15,2592($27)
	
	sw $15,2560($27)
	
	sw $15,2620($27)
	
	sw $15,2648($27)
	sw $15,2652($27)
	sw $15,2656($27)
	sw $15,2660($27)
	sw $15,2664($27)
	
	sw $15,2676($27)
	sw $15,2684($27)
	##############
	sw $15,6164($27)
	sw $15,6168($27)
	sw $15,6172($27)
	sw $15,6176($27)
	
	sw $15,6204($27)
	
	sw $15,6228($27)
	
	sw $15,6240($27)
	sw $15,6244($27)
	sw $15,6248($27)
	##############
	sw $15,6676($27)
	
	sw $15,6692($27)
	
	sw $15,6712($27)
	sw $15,6720($27)
	
	sw $15,6740($27)
	
	sw $15,6752($27)
	
	sw $15,6764($27)
	sw $15,6768($27)
	##############
	sw $15,7188($27)
	
	sw $15,7204($27)
	
	sw $15,7224($27)
	sw $15,7232($27)
	
	sw $15,7252($27)
	
	sw $15,7264($27)
	
	sw $15,7280($27)
	##############
	sw $15,7700($27)
	sw $15,7704($27)
	sw $15,7708($27)
	sw $15,7712($27)
	
	sw $15,7732($27)
	
	sw $15,7748($27)
	
	sw $15,7764($27)
	
	sw $15,7776($27)
	
	sw $15,7792($27)
	##############
	sw $15,8212($27)
	sw $15,8216($27)
	
	sw $15,8244($27)
	sw $15,8248($27)
	sw $15,8252($27)
	sw $15,8256($27)
	sw $15,8260($27)
	
	sw $15,8276($27)
	
	sw $15,8288($27)
	
	sw $15,8304($27)
	##############
	sw $15,8724($27)
	
	sw $15,8732($27)
	
	sw $15,8752($27)
	
	
	sw $15,8776($27)
	
	sw $15,8788($27)
	
	sw $15,8800($27)
	
	sw $15,8804($27)
	sw $15,8808($27)
	sw $15,8812($27)
	##############
	sw $15,10292($27)
	sw $15,10296($27)
	
	sw $15,10308($27)
	
	sw $15,10316($27)
	##############
	sw $15,10804($27)
	
	sw $15,10812($27)
	
	sw $15,10824($27)
	
	###############
	sw $15,11316($27)
	sw $15,11320($27)
	
	sw $15,11336($27)
	###############
	sw $15,11828($27)

	sw $15,11836($27)
	
	sw $15,11848($27)
	###############
	sw $15,12340($27)
	sw $15,12344($27)
	
	sw $15,12360($27)
	###############
	
	#AUTORIA
	################
	sw $15,15352($27)
	
	sw $15,15364($27)
	
	
	sw $15, 15372($27)
	sw $15,15376($27)
	sw $15,15380($27)
	sw $15,15384($27)
	
	sw $15,15392($27)
	
	sw $15,15408($27)
	
	sw $15,15416($27)
	sw $15,15420($27)
	sw $15,15424($27)
	sw $15,15428($27)
	sw $15,15432($27)
	
	sw $15,15440($27)
	sw $15,15444($27)
	sw $15,15448($27)
	sw $15,15452($27)
	
	sw $15,15476($27)
	sw $15,15480($27)
	sw $15,15484($27)
	sw $15,15488($27)
	
	################
	
	sw $15,15864($27)
	
	sw $15,15876($27)
	
	sw $15, 15884($27)
	
	sw $15, 15904($27)
	sw $15, 15908($27)
	sw $15, 15920($27)
	
	sw $15, 15940($27)
	
	sw $15, 15952($27)
	
	sw $15, 15988($27)
	
	################
	
	sw $15, 16376($27)
	sw $15, 16380($27)
	sw $15, 16384($27)
	sw $15, 16388($27)
	
	sw $15, 16396($27)
	
	sw $15, 16416($27)
	sw $15, 16424($27)
	sw $15, 16432($27)
	
	sw $15, 16448($27)
	
	sw $15, 16464($27)
	
	sw $15,16500($27)
	
	################
	
	sw $15, 16888($27)
	
	sw $15, 16900($27)
	
	sw $15, 16908($27)
	sw $15, 16912($27)
	sw $15, 16916($27)
	
	sw $15, 16928($27)
	
	sw $15, 16940($27)
	sw $15, 16944($27)
	
	sw $15, 16956($27)
	
	sw $15, 16976($27)
	sw $15, 16980($27)
	sw $15, 16984($27)
	
	sw $15, 17012($27)
	sw $15, 17016($27)
	sw $15, 17020($27)
	
	###################
	
	sw $15,17400($27)
	sw $15,17412($27)
	
	sw $15,17420($27)
	
	sw $15,17440($27)
	
	sw $15,17456($27)
	
	sw $15,17464($27)
	
	sw $15,17488($27)	
	
	sw $15,17524($27)
	
	###################
	
	sw $15,17912($27)
	
	sw $15,17924($27)
	
	sw $15,17932($27)
	sw $15,17936($27)
	sw $15,17940($27)
	sw $15,17944($27)
	
	sw $15,17952($27)
	sw $15,17968($27)
	
	sw $15,17976($27)
	sw $15,17980($27)
	sw $15,17984($27)
	sw $15,17988($27)
	
	sw $15,18000($27)
	sw $15,18004($27)
	sw $15,18008($27)
	sw $15,18012($27)
	
	sw $15,18024($27)
	
	sw $15,18036($27)
	
	#####################
	#Eltao agr
	#######################
	
	sw $15, 19960($27)
	sw $15, 19964($27)
	sw $15, 19968($27)
	sw $15, 19972($27)
	
	sw $15, 19980($27)
	
	sw $15, 20000($27)
	sw $15, 20004($27)
	sw $15, 20008($27)
	sw $15, 20012($27)
	sw $15, 20016($27)
	
	sw $15, 20028($27)
	sw $15, 20032($27)
	sw $15, 20036($27)
	
	sw $15, 20048($27)
	
	sw $15, 20064($27)
	
	sw $15, 20084($27)
	sw $15, 20088($27)
	sw $15, 20092($27)
	
	#################
	
	sw $15,20472($27)
	
	sw $15,20492($27)
	
	sw $15,20520($27)
	
	sw $15,20536($27)
		
	sw $15,20552($27)
	
	sw $15, 20560($27)
	sw $15, 20564($27)
	
	sw $15, 20576($27)
	
	sw $15, 20596($27)
	
	sw $15, 20608($27)
	
	################
	
	sw $15, 20984($27)
	
	sw $15, 21004($27)
	
	sw $15, 21032($27)
	
	sw $15, 21048($27)

	sw $15, 21064($27)
	
	sw $15,21072($27)
	
	sw $15, 21080($27)
	sw $15, 21088($27)
	
	sw $15, 21108($27)
	
	sw $15, 21120($27)
	
	################
	
	sw $15, 21496($27)
	sw $15, 21500($27)
	sw $15, 21504($27)
	
	sw $15, 21516($27)
	
	sw $15, 21544($27)
	
	sw $15, 21560($27)
	
	sw $15, 21576($27)
	
	sw $15,21584($27)
	
	sw $15, 21596($27)
	sw $15, 21600($27)
	
	sw $15, 21620($27)
	sw $15, 21624($27)
	sw $15, 21628($27)
	
	###############
	sw $15, 22008($27)
	
	sw $15, 22028($27)
	
	sw $15, 22056($27)
	
	sw $15, 22072($27)
	
	sw $15, 22088($27)
	
	sw $15,22096($27)
	
	sw $15, 22112($27)
		
	sw $15, 22132($27)	
	
	sw $15, 22144($27)
	
	################
	
	sw $15, 22520($27)
	sw $15, 22524($27)
	sw $15, 22528($27)
	sw $15, 22532($27)
	
	sw $15, 22540($27)
	sw $15, 22544($27)
	sw $15, 22548($27)
	sw $15, 22552($27)
	
	sw $15, 22568($27)
	
	sw $15, 22588($27)
	sw $15, 22592($27)
	sw $15, 22596($27)
	
	sw $15, 22608($27)
	
	sw $15, 22624($27)
	
	sw $15, 22632($27)
	
	sw $15, 22644($27)
	sw $15, 22648($27)
	sw $15, 22652($27)
	
	################
	addi $t1,$0,5

	sw $15,8($sp)
	sw $27,4($sp)
	sw $ra,0($sp)
	addi $sp,$sp,12
	
	jr $ra
	
	
	
	
	
	
	
	
	
	

	
	
	
