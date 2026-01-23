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
    	addi $25,$25,252 # Endereço do combustivel
    	sw $25,400($24) 
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
    	
    	sw $0,1000($24) #Contagem de Pontos
    	sw $0,1100($24) #Navio2
    	sw $0,1200($24) #Floco2
    
    	lui $23,0x1001 # Endereço do Medidor
    	addi $23,$23,57708
    	sw $23,1300($24)
    	
    	sw $0,1400($24) #Contagem para o medidor de combustivel
    	
	
    
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
    
    	li $10,30
    	div $9,$10
    	mfhi $11
    	bne $11,$0,PulaFloco
    	
    	lw $7, 700($24)
    	jal MoveFloco
    	sw $7, 700($24)
PulaFloco:
    	li $10,20
    	div $9,$10
    	mfhi $11
    	bne $11,$0,PulaNavio
    	
    	lw $7,800($24)
    	jal MoveNavio
    	sw $7, 800($24)
PulaNavio:
    	li $10,50
    	div $9,$10
    	mfhi $11
    	bne $11,$0,PulaCasa
    	
    	lw $7,500($24)
    	jal MoveCasa
    	sw $7,500($24)
PulaCasa:
	li $10,30
	div $9,$10
	mfhi $11
	bne $11,$0,PulaCasa2
	
	lw $7,600($24)
    	jal MoveCasa2
    	sw $7,600($24)
PulaCasa2:
	li $10,60
	div $9,$10
	mfhi $11
	bne $11,$0,ChecarNivel
	
	lw $7,400($24)
    	jal MoveCombustivel
    	sw $7,400($24)
######################################
# CHECAGEM DA CONTAGEM DE PONTOS PARA IR PARA A FASE 2
######################################
ChecarNivel:
	lw $8,1000($24)
	addi $10,$0,10
	blt $8,$10,PrepararFim
######################################
#INICIO DA FASE 2
######################################
MoverFase2:
	li $10,20
	div $9,$10
	mfhi $11
	bne $11,$0,PrepararFim
	
	lw $7,1100($24)
	bne $7,$0,SegueNavio2
	
	lw $4,800($24)
	jal RandomizarSeguro
	add $7,$0,$2
SegueNavio2:
	jal MoveNavio
	sw $7,1100($24)
	
	lw $7,1200($24)
	bne $7,$0,SegueFloco2
	
	lw $7,700($24)
	jal RandomizarSeguro
	add $7,$0,$2
SegueFloco2:
	jal MoveFloco
	sw $7,1200($24)
	
PrepararFim:
	li $10,8000
	blt $9,$10,ChecarFrames
	sw $0,300($24) 
ChecarFrames:
	lw $12,1400($24)
    	addi $13,$0,800
    	div $12,$13
    	mfhi $14
    	bne $14,$0,FimCiclo
    
    	jal MoveMedidor
FimCiclo:
	addi $12,$12,1
    	sw $12,1400($24)
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
    bge $25,1000,FimTimerCurto
    addi $25,$25,1
    j LoopTimerCurto
FimTimerCurto:
    jr $ra

	
#---------------------
timer_caveira:
    addi $25,$0,0
LoopTimerCaveira:
    bge $25,30000,FimTimerCaveira
    addi $25,$25,1
    j LoopTimerCaveira
FimTimerCaveira:
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
    	ori $16,0xDCDCDC# Branco
	
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
	
	lw $4,500($24)
	jal RandomizarSeguro
	
	addi $8,$0,0xFFFFFE00
	and $8,$2,$8
	
	addi $2,$0,42
	addi $5,$0,17
	syscall
	sll $4,$4,2
	addi $4,$4,28
	
	add $7,$8,$4
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
    	ori $16,0xDCDCDC# Branco

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
	
	lw $4,600($24)
	jal RandomizarSeguro
	
	addi $8,$0,0xFFFFFE00
	and $8,$2,$8
	
	addi $2,$0,42
	addi $5,$0,15
	syscall
	
	sll $4,$4,2
	addi $4,$4,380
	
	add $7,$8,$4
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
	addi $sp,$sp,-20
	sw $ra,0($sp)
	sw $15,4($sp)
	sw $16,8($sp)
	sw $17,12($sp)
	
	
	addi $15,$0,0xFF4500
	addi $17,$0,0xDCDCDC
	
	add $16,$0,$7
	
	sw $17,-8($16)
	
	sw $17,508($16)
	sw $15,516($16)
	sw $15,520($16)
	
	sw $17,1020($16)
	sw $15,1024($16)
	sw $15,1036($16)
	
	
	sw $15,1532($16)
	sw $15,1536($16)
	sw $15,1540($16)
	sw $15,1544($16)
	sw $15,1548($16)

	

	sw $15,2044($16)
	sw $15,2048($16)
	sw $15,2052($16)
	sw $15,2056($16)
	sw $15,2060($16)

	
	
	sw $15,2556($16)
	sw $15,2560($16)
	sw $15,2564($16)
	sw $15,2568($16)
	sw $15,2572($16)

	
	
	sw $15,3068($16)
	sw $15,3072($16)
	sw $15,3076($16)
	sw $15,3080($16)
	sw $15,3084($16)

	
	sw $15,3580($16)
	sw $15,3584($16)
	sw $15,3588($16)
	sw $15,3592($16)
	sw $15,3596($16)
	
	
	lw $ra,0($sp)
	lw $15,4($sp)
	lw $16,8($sp)
	lw $17,12($sp)
	
	addi $sp,$sp,20
	jr $ra
ApagaCombustivel:
	addi $sp,$sp,-8
	sw $ra,0($sp)
	sw $15,4($sp)
	
	
	addi $15,$0,0x000033FF
	
	sw $15,-8($7)
	
	sw $15,508($7)
	sw $15,516($7)
	sw $15,520($7)
	
	sw $15,1020($7)
	sw $15,1024($7)
	sw $15,1036($7)
	
	
	sw $15,1532($7)
	sw $15,1536($7)
	sw $15,1540($7)
	sw $15,1544($7)
	sw $15,1548($7)

	

	sw $15,2044($7)
	sw $15,2048($7)
	sw $15,2052($7)
	sw $15,2056($7)
	sw $15,2060($7)

	
	
	sw $15,2556($7)
	sw $15,2560($7)
	sw $15,2564($7)
	sw $15,2568($7)
	sw $15,2572($7)

	
	
	sw $15,3068($7)
	sw $15,3072($7)
	sw $15,3076($7)
	sw $15,3080($7)
	sw $15,3084($7)

	
	sw $15,3580($7)
	sw $15,3584($7)
	sw $15,3588($7)
	sw $15,3592($7)
	sw $15,3596($7)
	
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
	
ResetCombustivelEnd: #resetar quando chega no fim
	lw $4,400($24)
	jal RandomizarSeguro
	add $7,$0,$2
	
	j PulaResetCombustivel
ResetCombustivelInimigo: #resetar quando bate no aviao	
	addi $sp,$sp,-4
	sw $ra,0($sp)
		
	lw $4,400($24)
	jal RandomizarSeguro
	add $7,$0,$2
	
	sw $7,400($24)
	jal DesenhaCombustivel
	
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra
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
	lw $12,4($sp)
	lw $ra,0($sp)
	
	addiu $sp,$sp,20
	
	jr $ra
MoveMedidor:
	addi $sp,$sp,-20
	sw $ra,0($sp)
	sw $9,4($sp)
	sw $17,8($sp)
	sw $22,12($sp)
	sw $19,16($sp)
	
	ori $9,0xFFFF00
	lw $22,1300($24)
	addi $17,$0,0
	lui $16,0x1001
	addi $16,$16,57536
LoopMedidor:
	beq $17,9,FimMedidor
	lw $19,-4($22)
	add $20,$22,-4
	beq $20,$16,Game_over
	addi $22,$22,-4
	sw $9,0($22)
	sw $19,4($22)
AtualizaLinha:
	addi $22,$22,516
	addi $17,$17,1
	j LoopMedidor
FimMedidor:	
	addi $22,$22,-4612
	sw $22,1300($24)
	
	lw $ra,0($sp)
	lw $9,4($sp)
	lw $17,8($sp)
	lw $22,12($sp)
	lw $19,16($sp)
	addi $sp,$sp,20
	
	jr $ra
IncrementaMedidor:
	addi $sp,$sp,-32
	sw $ra,0($sp)
	sw $9,4($sp)
	sw $17,8($sp)
	sw $22,12($sp)
	sw $19,16($sp)
	sw $18,20($sp)
	sw $16,24($sp)
	sw $20,28($sp)
	
	
	
	ori $9,0xFFFF00
	lw $22,1300($24)
	addi $18,$0,0
	addi $17,$0,0
	lui $16,0x1001
	addi $16,$16,57712
	
LoopExterno:
	beq $18,10,FimLoop
LoopInterno:
	beq $17,9,FimLoopInterno
	lw $19,4($22)
	addi $20,$22,4
	beq $20,$16,FimLoop
	addi $22,$22,4
	sw $9,0($22)
	sw $19,-4($22)
	addi $22,$22,508
	addi $17,$17,1
	j LoopInterno
FimLoopInterno:	
	addi $22,$22,-4604
	addi $18,$18,1
	addi $17,$0,0
	j LoopExterno
FimLoop:
	sw $22,1300($24)
	
	lw $ra,0($sp)
	lw $9,4($sp)
	lw $17,8($sp)
	lw $22,12($sp)
	lw $19,16($sp)
	lw $18,20($sp)
	lw $16,24($sp)
	lw $20,28($sp)
	addi $sp,$sp,32
	
	jr $ra
ChecarColisao:
	addi $sp,$sp,-48
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
	sw $15,44($sp)

	lw $10,200($24)
	beq $10,$0,FimColisao
	
	lw $13,800($24) #Endereço base do navio
	beq $13,$0,TestaNavio2 #Se não houver navio,pula
	
	sub $15,$10,$13 #Diferença total de endereços
	abs $15,$15 # Valor absoluto para não importar quem vem antes
	srl $18,$15,9 #Divide por 512 para pegar a diferença de linhas
	addi $16,$0,4 #Altura do Navio em linhas
	bgt $18,$16,TestaNavio2  #Se estiver muito longe verticalmente,pula
	
	andi $11,$10,0x1FF #X do tiro (endereço do tiro and 511)
	andi $12,$13,0x1FF #X do navio(endereço do navio and 511)
	
	sub $17,$11,$12 #Diferença X = X-tiro - X-navio
	abs $17,$17
	
	addi $16,$0,30 #Largura da caixa de colisao
	bgt $17,$16, TestaNavio2 # Se a distancia X for maior que a largura, não colidiu
	
	j ResetNavio1 #Se passou nos dois testes, colidiu
TestaNavio2:
	lw $13,1100($24)
	beq $13,$0,TestaFloco
	
	sub $15,$10,$13
	abs $15,$15
	srl $18,$15,9
	addi $16,$0,4
	bgt $18,$16,TestaFloco
	
	andi $11,$10,0x1FF
	andi $12,$13,0x1FF
	
	sub $17,$11,$12
	abs $17,$17
	
	addi $16,$0,30
	bgt $17,$16, TestaFloco
	
	
	j ResetNavio2
ResetNavio1:
	addi $15,$24,800
	j ExecutarResetNavio
ResetNavio2:
	addi $15,$24,1100
ExecutarResetNavio:
	lw $7,0($15)
	
	jal ApagaNavio
	jal SomExplosao
	
	lw $8,1000($24)
	addi $8,$8,1
	
	add $6,$0,$8
	jal DesenhaPontos
	
	sw $8,1000($24)
	
	lw $4,0($15)
	jal RandomizarSeguro
	sw $2,0($15)
	
	j ApagarTiroNoFim
TestaFloco:
	lw $13,700($24)
	beq $13,$0,TestaFloco2
	
	sub $15,$10,$13
	abs $15,$15
	srl $18,$15,9
	addi $16,$0,4
	bgt $18,$16,TestaFloco2
	
	andi $11,$10,0x1FF
	andi $12,$13,0x1FF
	
	sub $17,$11,$12
	abs $17,$17
	
	addi $16,$0,20
	bgt $17,$16,TestaFloco2
	
	j ResetFloco1
TestaFloco2:
	lw $13,1200($24)
	beq $13,$0,TestaCombustivel
	
	sub $15,$10,$13
	abs $15,$15
	srl $18,$15,9
	addi $16,$0,4
	bgt $18,$16,TestaCombustivel
	
	andi $11,$10,0x1FF
	andi $12,$13,0x1FF
	
	sub $17,$11,$12
	abs $17,$17
	
	addi $16,$0,20
	bgt $17,$16,TestaCombustivel
	
	j ResetFloco2
ResetFloco1:
	addi $15,$24,700
	j ExecutarResetFloco
ResetFloco2:
	addi $15,$24,1200
	
	j ExecutarResetFloco
ExecutarResetFloco:
	lw $7,0($15)
	jal ApagaFloco
	jal SomExplosao
	
	lw $8,1000($24)
	addi $8,$8,1
	
	
	add $6,$0,$8
	jal DesenhaPontos
	
	sw $8,1000($24)
	
	
	lw $4,0($15)
	jal RandomizarSeguro
	sw $2,0($15)
	
	j ApagarTiroNoFim
TestaCombustivel:
	lw $13,400($24)
	beq $13,$0,FimColisao
	
	sub $15,$10,$13
	abs $15,$15
	srl $18,$15,9
	
	addi $16,$0,8
	bgt $18,$16,FimColisao
	
	andi $11,$10,0x1FF
	andi $12,$13,0x1FF
	
	sub $17,$11,$12
	abs $17,$17
	
	addi $16,$0,20
	bgt $17,$16,FimColisao
	
	lw $7,400($24)
	jal ApagaCombustivel
	jal SomExplosao
	
	lw $4,400($24)
	jal RandomizarSeguro
	sw $2,400($24)
	
	j ApagarTiroNoFim
ApagarTiroNoFim:
	lw $10,200($24)
	beq $10,$0,FimColisao
	addi $12,$0,0x000033ff
	sw $12,0($10)
	sw $12,4($10)
	
	sw $0,100($24)
	sw $0,200($24)
	
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
	lw $15,44($sp)
	
	addi $sp,$sp,48
	jr $ra

SomExplosao:
	addi $sp,$sp,-4
	sw $ra,0($sp)
	
	addi $4, $0, 10		# Nota Sol
	addi $5, $0, 400
    	addi $6, $0, 12		# Instrumento
        addi $7, $0, 300	# Volume
	addi $2, $0, 31		
	syscall
	
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra
ChecarColisaoInimigo:
	addi $sp,$sp,-8
	sw $ra,0($sp)
	
	lw $27,800($24)
	jal ChecaNavio
	
	lw $27,1100($24)
	jal ChecaNavio
	
	
	lw $26,700($24)
	jal ChecaFloco
	
	
	lw $26,1200($24)
	jal ChecaFloco
	
	lw $26,400($24)
	jal ChecaCombustivel
	
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra
ChecaNavio:
	beq $27,$0,Retorno
	
	sub $8,$3,$27 #$8 = (Endereço Avião) - (Endereço Navio)
	abs $8,$8
	li $9,2300    ## 4500 bytes sao quase 9 linhas de distância
	bgt $8,$9,Retorno # Se a diferença > 4500, o avião está muito abaixo do navio
	
	# Teste de colunas
	andi $10,$3,0x1ff # faz um and com endereço do aviao e 0x1ff para obter a coluna do aviao
	andi $11,$27,0x1ff # faz um and com endereço do navio e 0x1ff para obter a coluna do navio
	sub $12,$10,$11 # 12 =  distancia entre as colunas
	
	abs $12,$12 # vira positivo
	li $13,45 # Teste se estão a menos de 45 bytes
	blt $12,$13,Game_over # game_over
	
	jr $ra
ChecaFloco:
	beq $26,$0,Retorno
	
	sub $8,$3,$26
	abs $8,$8
	li $9,2300
	bgt $8,$9,Retorno
	
	andi $10,$3,0x1ff
	andi $11,$26,0x1ff
	sub $12,$10,$11
	abs $12,$12
	li $13,30
	blt $12,$13,Game_over
	
	jr $ra
ChecaCombustivel:
	beq $26,$0,Retorno
	
	sub $8,$3,$26
	abs $8,$8
	li $9,4100
	bgt $8,$9,Retorno
	
	andi $10,$3,0x1ff
	andi $11,$26,0x1ff
	sub $12,$10,$11
	abs $12,$12
	li $13,30
	blt $12,$13,ReiniciaCombustivel
	
	
	jr $ra
ReiniciaCombustivel:
	addi $sp,$sp,-4
	sw $ra,0($sp)
	
	add $7,$0,$26
	
	jal ApagaCombustivel
	jal ResetCombustivelInimigo
	jal IncrementaMedidor
	lw $ra,0($sp)
	addi $sp,$sp,4
	
	jr $ra
Retorno:
	jr $ra

	
#################################
AtualizaJogador:
	addiu $sp, $sp,-36
	sw $14,32($sp)
	sw $15,28($sp)
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
	bne $19,$0,continue
	
	addi $19,$0,1
	sw $19,100($24)
	
	addi $13,$3,-512
	
	sw $13,200($24)
continue:
	lw $14,32($sp)
	lw $15,28($sp)
	lw $13,24($sp)
	lw $17,20($sp)  #status register
	lw $20,16($sp)  # leitura da tecla pressionada
	lw $21,12($sp)  # tecla
	lw $ra,8($sp)
	lw $8,4($sp)
	lw $19,0($sp)
	
	addiu $sp,$sp,36
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
DesenhaPontos:
	addi $sp,$sp,-40
	sw $ra,0($sp)
	sw $8,4($sp)
	sw $9,8($sp)
	sw $16,12($sp)
	sw $11,16($sp)
	sw $12,20($sp)
	sw $13,24($sp)
	sw $21,28($sp)
	sw $22,32($sp)
	sw $5,36($sp)
	add $21,$0,$6 # Pontos
	
	lui $8,0x1001
	lui $16,0x1001
	lui $22,0x1001
	addi $8,$8,51032 #Endereço do primeiro numero
	addi $16,$16,51000 #Endereço do segundo numero
	addi $22,$22,50972 # Endereço do terceiro numero
	
	ori $11,$0,0x404040 #Cinza
	ori $9,$0,0xFFFF00 #Amarel
	
ApagarTerceiro:
	beq $21,20,ApagaTerceiroPonto
	beq $21,30,ApagaTerceiroPonto
	
ApagarSegundo:
	j ApagaSegundoPonto
	
# PARTE OBSCURA DO CÓDIGO
ChecaPontos:
	beq $21,1,p_10
	beq $21,2,p_20
	beq $21,3,p_30
	beq $21,4,p_40
	beq $21,5,p_50
	beq $21,6,p_60
	beq $21,7,p_70
	beq $21,8,p_80
	beq $21,9,p_90
	beq $21,10,p_100
	beq $21,11,p_110
	beq $21,12,p_120
	beq $21,13,p_130
	beq $21,14,p_140
	beq $21,15,p_150
	beq $21,16,p_160
	beq $21,17,p_170
	beq $21,18,p_180
	beq $21,19,p_190
	beq $21,20,p_200
	beq $21,21,p_210
	beq $21,22,p_220
	beq $21,23,p_230
	beq $21,24,p_240
	beq $21,25,p_250
	beq $21,26,p_260
	beq $21,27,p_270
	beq $21,28,p_280
	beq $21,29,p_290
	beq $21,30,p_300
	
	
	
d_numero0:
	
	sw $9,0($5)
	sw $9,4($5)
	sw $9,8($5)
	sw $9,12($5)
	
	
	sw $9,508($5)
	sw $9,528($5)
	
	sw $9,1020($5)
	sw $9,1040($5)
	
	
	sw $9,1532($5)
	sw $9,1552($5)
	
	sw $9,2044($5)
	sw $9,2064($5)
	
	sw $9,2556($5)
	sw $9,2576($5)
	
	sw $9,3068($5)
	sw $9,3088($5)
	
	sw $9,3580($5)
	sw $9,3600($5)
	
	sw $9,4096($5)
	sw $9,4100($5)
	sw $9,4104($5)
	sw $9,4108($5)
	
	
	
	jr $ra
d_numero1:
	
	sw $9,4($5)
	
	sw $9,512($5)
	sw $9,516($5)
	
	sw $9,1028($5)
	
	sw $9,1540($5)
	
	sw $9,2052($5)
	
	sw $9,2564($5)
	
	sw $9,3076($5)
	
	sw $9,3588($5)

	sw $9,4096($5)
	sw $9,4100($5)
	sw $9,4104($5)
	sw $9,4108($5)
	
	
	jr $ra
d_numero2:
	
	sw $9,0($5)
	sw $9,4($5)
	sw $9,8($5)
	sw $9,12($5)
	sw $9,16($5)
	sw $9,20($5)
	
	sw $9,532($5)

	sw $9,1044($5)

	sw $9,1556($5)
	
	sw $9,2068($5)
	sw $9,2064($5)
	sw $9,2060($5)
	sw $9,2056($5)
	sw $9,2052($5)
	sw $9,2048($5)
	
	sw $9,2560($5)
	sw $9,3072($5)
	sw $9,3584($5)
	sw $9,4096($5)
	
	sw $9,4100($5)
	sw $9,4104($5)
	sw $9,4108($5)
	sw $9,4112($5)
	sw $9,4116($5)
	
	
	
	jr $ra
d_numero3:
	
	
	sw $9,512($5)
	
	sw $9,4($5)
	sw $9,8($5)
	sw $9,12($5)
	sw $9,16($5)
	
	sw $9,532($5)
	
	sw $9,1044($5)
	
	sw $9,1556($5)
	
	sw $9,2064($5)
	sw $9,2060($5)
	sw $9,2056($5)
	sw $9,2052($5)
	
	sw $9,2580($5)
	sw $9,3092($5)
	sw $9,3604($5)
	
	sw $9,4112($5)
	sw $9,4108($5)
	sw $9,4104($5)
	sw $9,4100($5)
	
	sw $9,3584($5)
	
	
	
	jr $ra
d_numero4:
	
	
	sw $9,0($5)
	sw $9,20($5)
	
	sw $9,532($5)
	sw $9,1044($5)
	sw $9,1556($5)
	
	sw $9,512($5)
	sw $9,1024($5)
	sw $9,1536($5)
	
	sw $9,1540($5)
	sw $9,1544($5)
	sw $9,1548($5)
	sw $9,1552($5)
	
	sw $9,2068($5)
	sw $9,2580($5)
	sw $9,3092($5)
	sw $9,3604($5)
	sw $9,4116($5)
	
	
	
	jr $ra
d_numero5:
	
	
	sw $9,0($5)
	sw $9,4($5)
	sw $9,8($5)
	sw $9,12($5)
	sw $9,16($5)
	sw $9,20($5)
	
	sw $9,512($5)
	sw $9,1024($5)
	sw $9,1536($5)
	sw $9,2048($5)
	
	sw $9,2052($5)
	sw $9,2056($5)
	sw $9,2060($5)
	sw $9,2064($5)
	sw $9,2068($5)

	sw $9,2580($5)
	sw $9,3092($5)
	sw $9,3604($5)
	sw $9,4116($5)
	
	sw $9,4112($5)
	sw $9,4108($5)
	sw $9,4104($5)
	sw $9,4100($5)
	sw $9,4096($5)
	
	
	
	jr $ra
d_numero6:
	
	
	sw $9,0($5)
	sw $9,4($5)
	sw $9,8($5)
	sw $9,12($5)
	sw $9,16($5)
	sw $9,20($5)
	
	sw $9,512($5)
	sw $9,1024($5)
	sw $9,1536($5)
	sw $9,2048($5)
	sw $9,2560($5)
	sw $9,3072($5)
	sw $9,3584($5)
	sw $9,4096($5)
	
	sw $9,4100($5)
	sw $9,4104($5)
	sw $9,4108($5)
	sw $9,4112($5)
	sw $9,4116($5)
	
	sw $9,3604($5)
	sw $9,3092($5)
	sw $9,2580($5)
	sw $9,2068($5)
	
	sw $9,2064($5)
	sw $9,2060($5)
	sw $9,2056($5)
	sw $9,2052($5)
	sw $9,2048($5)
	
	
	
	jr $ra
d_numero7:
	
	
	sw $9,0($5)
	sw $9,4($5)
	sw $9,8($5)
	sw $9,12($5)
	sw $9,16($5)
	sw $9,20($5)
	
	sw $9,532($5)
	sw $9,1044($5)
	sw $9,1556($5)
	sw $9,2068($5)
	
	sw $9,2068($5)
	sw $9,2064($5)
	sw $9,2060($5)
	sw $9,2056($5)
	sw $9,2052($5)
	
	sw $9,2580($5)
	sw $9,3092($5)
	sw $9,3604($5)
	sw $9,4116($5)
	
	
	
	jr $ra
d_numero8:
	
	
	sw $9,512($5)
	sw $9,1024($5)
	sw $9,1536($5)
	
	sw $9,4($5)
	sw $9,8($5)
	sw $9,12($5)
	sw $9,16($5)
	
	sw $9,532($5)
	sw $9,1044($5)
	sw $9,1556($5)
	
	sw $9,2052($5)
	sw $9,2056($5)
	sw $9,2060($5)
	sw $9,2064($5)
	
	sw $9,2580($5)
	sw $9,3092($5)
	sw $9,3604($5)
	
	sw $9,2560($5)
	sw $9,3072($5)
	sw $9,3584($5)
	
	sw $9,4100($5)
	sw $9,4104($5)
	sw $9,4108($5)
	sw $9,4112($5)
	
	
	
	jr $ra
d_numero9:
	
	
	sw $9,0($5)
	sw $9,4($5)
	sw $9,8($5)
	sw $9,12($5)
	sw $9,16($5)
	sw $9,20($5)
	
	sw $9,512($5)
	sw $9,1024($5)
	sw $9,1536($5)
	sw $9,2048($5)
	
	sw $9,2052($5)
	sw $9,2056($5)
	sw $9,2060($5)
	sw $9,2064($5)
	sw $9,2068($5)
	
	sw $9,532($5)
	sw $9,1044($5)
	sw $9,1556($5)
	sw $9,2068($5)
	sw $9,2580($5)
	sw $9,3092($5)
	sw $9,3604($5)
	sw $9,4116($5)
	
	
	
	
	jr $ra
p_10:
	add $5,$0,$8
	jal d_numero0
	add $5,$0,$16
	jal d_numero1
	j FimPontuacao
p_20:
	add $5,$0,$16
	jal d_numero2
	j FimPontuacao
p_30:
	add $5,$0,$16
	jal d_numero3
	j FimPontuacao
p_40:
	add $5,$0,$16
	jal d_numero4
	j FimPontuacao
p_50:
	add $5,$0,$16
	jal d_numero5
	j FimPontuacao
p_60:
	add $5,$0,$16
	jal d_numero6
	j FimPontuacao
p_70:
	add $5,$0,$16
	jal d_numero7
	j FimPontuacao
p_80:
	add $5,$0,$16
	jal d_numero8
	j FimPontuacao
p_90:
	add $5,$0,$16
	jal d_numero9
	j FimPontuacao
p_100:
	add $5,$0,$16
	jal d_numero0
	add $5,$0,$22
	jal d_numero1
	j FimPontuacao
p_110:
	add $5,$0,$16
	jal d_numero1
	j FimPontuacao
p_120:
	add $5,$0,$16
	jal d_numero2
	j FimPontuacao
p_130:
	add $5,$0,$16
	jal d_numero3
	j FimPontuacao
p_140:
	add $5,$0,$16
	jal d_numero4
	j FimPontuacao
p_150:
	add $5,$0,$16
	jal d_numero5
	j FimPontuacao
p_160:
	add $5,$0,$16
	jal d_numero6
	j FimPontuacao
p_170:
	add $5,$0,$16
	jal d_numero7
	j FimPontuacao
p_180:
	add $5,$0,$16
	jal d_numero8
	j FimPontuacao
p_190:
	add $5,$0,$16
	jal d_numero9
	j FimPontuacao
p_200:
	add $5,$0,$22
	jal d_numero2
	add $5,$0,$16
	jal d_numero0
	j FimPontuacao
p_210:
	add $5,$0,$16
	jal d_numero1
	j FimPontuacao
p_220:
	add $5,$0,$16
	jal d_numero2
	j FimPontuacao
p_230:
	add $5,$0,$16
	jal d_numero3
	j FimPontuacao
p_240:
	add $5,$0,$16
	jal d_numero4
	j FimPontuacao
p_250:
	add $5,$0,$16
	jal d_numero5
	j FimPontuacao
p_260:
	add $5,$0,$16
	jal d_numero6
	j FimPontuacao
p_270:
	add $5,$0,$16
	jal d_numero7
	j FimPontuacao
p_280:
	add $5,$0,$16
	jal d_numero8
	j FimPontuacao
p_290:
	add $5,$0,$16
	jal d_numero9
	j FimPontuacao
p_300:
	add $5,$0,$22
	jal d_numero3
	add $5,$0,$16
	jal d_numero0
	j Game_win

FimPontuacao:
	lw $ra,0($sp)
	lw $8,4($sp)
	lw $9,8($sp)
	lw $16,12($sp)
	lw $11,16($sp)
	lw $12,20($sp)
	lw $13,24($sp)
	lw $21,28($sp)
	lw $22,32($sp)
	lw $5,36($sp)
	addi $sp,$sp,40
	jr $ra
ApagaSegundoPonto:
	add $13,$0,$16
	addi $13,$13,-4
	addi $12,$0,0
ApagaSegundoPontoLoop:
	beq $12,9,ChecaPontos
	
	sw $11,0($13)
	sw $11,4($13)
	sw $11,8($13)
	sw $11,12($13)
	sw $11,16($13)
	sw $11,20($13)
	sw $11,24($13)
	sw $11,28($13)
	
	addi $13,$13,512
	addi $12,$12,1
	
	j ApagaSegundoPontoLoop
ApagaTerceiroPonto:
	add $13,$0,$22
	add $13,$13,-4
	addi $12,$0,0
ApagaTerceiroPontoLoop:
	beq $12,9,ApagarSegundo
	
	sw $11,0($13)
	sw $11,4($13)
	sw $11,8($13)
	sw $11,12($13)
	sw $11,16($13)
	sw $11,20($13)
	sw $11,24($13)
	sw $11,28($13)
	
	addi $13,$13,512
	addi $12,$12,1
	
	j ApagaTerceiroPontoLoop
	
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
	addi $sp,$sp,-36
	sw $ra,0($sp)
	sw $5,4($sp)
	sw $6,8($sp)
	sw $8,12($sp)
	sw $9,16($sp)
	sw $17,20($sp)
	sw $18,24($sp)
	sw $19,28($sp)
	sw $10,32($sp)
	

	lui $5,0x1001         # fazer do hud algo separado do background
	lui $6,0x1001
	
	addi $5,$5,49152   # pula pra linha 50
	addi $6,$6,56000
	
	
	ori $8,$0,0x404040	#cinzinha ne pai
	ori $9,$0,0x000000
	ori $10,$0,0xFFFF00
	addi $18,$0,0 		# Contador de linhas
LoopAltura:
	addi $17,$0,0
LoopLargura:
	sw $8,0($5)
	addi $5,$5,4
	addi $17,$17,1
	bne $17,512,LoopLargura
	
	addi $18,$18,1
	blt $18,40,LoopAltura
	
	addi $18,$18,1
	blt $18,45,LoopAltura
HUD:
	addi $17,$0,0
	addi $18,$0,0
LinhaSuperior:
	sw $9,0($6)
	addi $6,$6,4
	addi $17,$17,1
	bne $17,45,LinhaSuperior
Detalhes:
	addi $6,$6,332
	
	sw $9,0($6)
	
	sw $9,16($6)
	sw $9,20($6)
	
	sw $9,84($6)
	sw $9,88($6)
	
	sw $9,156($6)
	sw $9,160($6)
	
	sw $9,176($6)
#---------------------
	sw $9,512($6)
	
	sw $9,528($6)
	sw $9,532($6)
	
	sw $9,596($6)
	sw $9,600($6)
	
	sw $9,668($6)
	sw $9,672($6)
	
	sw $9,688($6)
#---------------------
	sw $9,1024($6)
	
	sw $9,1128($6)
	
	sw $9,1200($6)
#--------------------
	sw $9,1536($6)
	
	sw $9,1552($6)
	sw $9,1556($6)
	sw $9,1560($6)
	sw $9,1564($6)
	
	sw $9,1608($6)
	
	sw $9,1636($6)
	
	sw $9,1680($6)
	sw $9,1684($6)
	sw $9,1688($6)
	sw $9,1692($6)
	
	sw $9,1712($6)
#--------------------
	sw $9,2048($6)
	
	sw $9,2064($6)
	
	sw $9,2116($6)
	sw $9,2120($6)
	
	sw $9,2144($6)
	
	sw $9,2192($6)
	
	sw $9,2224($6)
#--------------------
	sw $9,2560($6)
	
	sw $9,2576($6)
	sw $9,2580($6)
	sw $9,2584($6)
	
	sw $9,2632($6)
	
	sw $9,2652($6)
	
	sw $9,2704($6)
	sw $9,2708($6)
	sw $9,2712($6)
	
	
	sw $9,2736($6)
#--------------------
	sw $9,3072($6)
	
	sw $9,3088($6)
	
	sw $9,3140($6)
	sw $9,3144($6)
	sw $9,3148($6)
	
	sw $9,3160($6)
	
	sw $9,3172($6)
	sw $9,3176($6)
	sw $9,3180($6)
	
	sw $9,3216($6)
	
	sw $9,3248($6)
#----------------------
	sw $9,3584($6)
	
	sw $9,3600($6)
	sw $9,3604($6)
	sw $9,3608($6)
	sw $9,3612($6)
	
	sw $9,3668($6)
	
	sw $9,3692($6)
	
	sw $9,3728($6)
	
	sw $9,3760($6)
#----------------------
	sw $9,4096($6)
	
	sw $9,4176($6)
	
	sw $9,4196($6)
	sw $9,4200($6)
	sw $9,4204($6)
	
	sw $9,4272($6)
#----------------------
	sw $9,4608($6)
	
	sw $4,4684($6)
	
	sw $9,4708($6)
	
	sw $9,4784($6)
#----------------------
	sw $9,5120($6)
	
	sw $9,5220($6)
	sw $9,5224($6)
	sw $9,5228($6)
	
	sw $9,5296($6)
#---------------------
HUD2:
	addi $6,$6,5632
	addi $17,$0,0
	addi $18,$0,0
LinhaInferior:
	sw $9,0($6)
	addi $6,$6,4
	addi $17,$17,1
	bne $17,45,LinhaInferior
MedidorCombustivel:
	addi $6,$6,-4616
	sw $10,0($6)
	sw $10,512($6)
	sw $10,1024($6)
	sw $10,1536($6)
	sw $10,2048($6)
	sw $10,2560($6)
	sw $10,3072($6)
	sw $10,3584($6)
	sw $10,4096($6)
FimBackground:
	lw $ra,0($sp)
	lw $5,4($sp)
	lw $6,8($sp)
	lw $8,12($sp)
	lw $9,16($sp)
	lw $17,20($sp)
	lw $18,24($sp)
	lw $19,28($sp)
	lw $10,32($sp)
	addi $sp,$sp,36
	
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
#---------------------------
Game_over:
	addi $sp,$sp,-20
	sw $ra,0($sp)
	sw $15,4($sp)
	sw $16,8($sp)
	sw $17,12($sp)
	sw $18,16($sp)
	
	lui $15,0x1001
	addi $15,$15,20172
	ori $16,$0,0x7F7F7F #cinza
	ori $17,$0,0x880015 #vermelho
	ori $18,$0,0x000000
	
	
	sw $18,16($15)
	sw $18,20($15)
	sw $18,24($15)
	sw $18,28($15)
	sw $18,32($15)
	sw $18,36($15)
	sw $18,40($15)
	sw $18,44($15)
	sw $18,48($15)
	sw $18,52($15)
	sw $18,56($15)
	sw $18,60($15)
	sw $18,64($15)
	sw $18,68($15)
	sw $18,72($15)
	sw $18,76($15)
	jal timer_caveira
	sw $18,520($15)
	sw $18,524($15)
	sw $18,528($15)
	sw $16,532($15)
	sw $16,536($15)
	sw $16,540($15)
	sw $16,544($15)
	sw $16,548($15)
	sw $16,552($15)
	sw $16,556($15)
	sw $16,560($15)
	sw $16,564($15)
	sw $16,568($15)
	sw $16,572($15)
	sw $16,576($15)
	sw $16,580($15)
	sw $16,584($15)
	sw $18,588($15)
	sw $18,592($15)
	sw $18,596($15)
	#-------------
	jal timer_caveira
	
	sw $18,1028($15)
	sw $16,1032($15)
	sw $16,1036($15)
	sw $16,1040($15)
	sw $16,1044($15)
	sw $16,1048($15)
	sw $16,1052($15)
	sw $16,1056($15)
	sw $16,1060($15)
	sw $16,1064($15)
	sw $16,1068($15)
	sw $16,1072($15)
	sw $16,1076($15)
	sw $16,1080($15)
	sw $16,1084($15)
	sw $16,1088($15)
	sw $16,1092($15)
	sw $16,1096($15)
	sw $16,1100($15)
	sw $16,1104($15)
	sw $16,1108($15)
	sw $18,1112($15)
	#---------------
	jal timer_caveira
	sw $18,1540($15)
	sw $16,1544($15)
	sw $16,1548($15)
	sw $16,1552($15)
	sw $16,1556($15)
	sw $16,1560($15)
	sw $16,1564($15)
	sw $16,1568($15)
	sw $16,1572($15)
	sw $16,1576($15)
	sw $16,1580($15)
	sw $16,1584($15)
	sw $16,1588($15)
	sw $16,1592($15)
	sw $16,1596($15)
	sw $16,1600($15)
	sw $16,1604($15)
	sw $16,1608($15)
	sw $16,1612($15)
	sw $16,1616($15)
	sw $16,1620($15)
	sw $18,1624($15)
	#---------------
	jal timer_caveira
	sw $18,2052($15)
	sw $16,2056($15)
	sw $16,2060($15)
	sw $16,2064($15)
	sw $16,2068($15)
	sw $16,2072($15)
	sw $16,2076($15)
	sw $16,2080($15)
	sw $16,2084($15)
	sw $16,2088($15)
	sw $16,2092($15)
	sw $16,2096($15)
	sw $16,2100($15)
	sw $16,2104($15)
	sw $16,2108($15)
	sw $16,2112($15)
	sw $16,2116($15)
	sw $16,2120($15)
	sw $16,2124($15)
	sw $16,2128($15)
	sw $16,2132($15)
	sw $18,2136($15)
	#---------------
	jal timer_caveira	
	sw $18,2564($15)
	sw $16,2568($15)
	sw $16,2572($15)
	sw $16,2576($15)
	sw $16,2580($15)
	sw $16,2584($15)
	sw $16,2588($15)
	sw $16,2592($15)
	sw $16,2596($15)
	sw $16,2600($15)
	sw $16,2604($15)
	sw $16,2608($15)
	sw $16,2612($15)
	sw $16,2616($15)
	sw $16,2620($15)
	sw $16,2624($15)
	sw $16,2628($15)
	sw $16,2632($15)
	sw $16,2636($15)
	sw $16,2640($15)
	sw $16,2644($15)
	sw $18,2648($15)
	#---------------
	jal timer_caveira
	sw $18,3072($15)
	sw $16,3076($15)
	sw $16,3080($15)
	sw $16,3084($15)
	sw $16,3088($15)
	sw $16,3092($15)
	sw $16,3096($15)
	sw $16,3100($15)
	sw $16,3104($15)
	sw $16,3108($15)
	sw $16,3112($15)
	sw $16,3116($15)
	sw $16,3120($15)
	sw $16,3124($15)
	sw $16,3128($15)
	sw $16,3132($15)
	sw $16,3136($15)
	sw $16,3140($15)
	sw $16,3144($15)
	sw $16,3148($15)
	sw $16,3152($15)
	sw $16,3156($15)
	sw $16,3160($15)
	sw $18,3164($15)
	#----------------
	jal timer_caveira
	sw $18,3584($15)
	sw $16,3588($15)
	sw $16,3592($15)
	sw $16,3596($15)
	sw $16,3600($15)
	sw $16,3604($15)
	sw $16,3608($15)
	sw $16,3612($15)
	sw $16,3616($15)
	sw $16,3620($15)
	sw $16,3624($15)
	sw $16,3628($15)
	sw $16,3632($15)
	sw $16,3636($15)
	sw $16,3640($15)
	sw $16,3644($15)
	sw $16,3648($15)
	sw $16,3652($15)
	sw $16,3656($15)
	sw $16,3660($15)
	sw $16,3664($15)
	sw $16,3668($15)
	sw $16,3672($15)
	sw $18,3676($15)
	#----------------
	jal timer_caveira
	sw $18,4096($15)
	sw $16,4100($15)
	sw $16,4104($15)
	sw $16,4108($15)
	sw $16,4112($15)
	sw $16,4116($15)
	sw $16,4120($15)
	sw $16,4124($15)
	sw $16,4128($15)
	sw $16,4132($15)
	sw $16,4136($15)
	sw $16,4140($15)
	sw $16,4144($15)
	sw $16,4148($15)
	sw $16,4152($15)
	sw $16,4156($15)
	sw $16,4160($15)
	sw $16,4164($15)
	sw $16,4168($15)
	sw $16,4172($15)
	sw $16,4176($15)
	sw $16,4180($15)
	sw $16,4184($15)
	sw $18,4188($15)
	#----------------
	jal timer_caveira
	sw $18,4608($15)
	sw $16,4612($15)
	sw $16,4616($15)
	sw $18,4620($15)
	sw $18,4624($15)
	sw $18,4628($15)
	sw $18,4632($15)
	sw $18,4636($15)
	sw $18,4640($15)
	sw $16,4644($15)
	sw $16,4648($15)
	sw $16,4652($15)
	sw $16,4656($15)
	sw $16,4660($15)
	sw $16,4664($15)
	sw $18,4668($15)
	sw $18,4672($15)
	sw $18,4676($15)
	sw $18,4680($15)
	sw $18,4684($15)
	sw $18,4688($15)
	sw $16,4692($15)
	sw $16,4696($15)
	sw $18,4700($15)
	#---------------
	jal timer_caveira
	sw $18,5116($15)
	sw $16,5120($15)
	sw $16,5124($15)
	sw $18,5128($15)
	sw $17,5132($15)
	sw $17,5136($15)
	sw $17,5140($15)
	sw $17,5144($15)
	sw $17,5148($15)
	sw $18,5152($15)
	sw $16,5156($15)
	sw $16,5160($15)
	sw $16,5164($15)
	sw $16,5168($15)
	sw $16,5172($15)
	sw $16,5176($15)
	sw $18,5180($15)
	sw $17,5184($15)
	sw $17,5188($15)
	sw $17,5192($15)
	sw $17,5196($15)
	sw $17,5200($15)
	sw $18,5204($15)
	sw $16,5208($15)
	sw $16,5212($15)
	sw $18,5216($15)
#---------------------
	jal timer_caveira
	sw $18,5628($15)
	sw $16,5632($15)
	sw $16,5636($15)
	sw $18,5640($15)
	sw $17,5644($15)
	sw $17,5648($15)
	sw $17,5652($15)
	sw $17,5656($15)
	sw $17,5660($15)
	sw $18,5664($15)
	sw $16,5668($15)
	sw $16,5672($15)
	sw $16,5676($15)
	sw $16,5680($15)
	sw $16,5684($15)
	sw $16,5688($15)
	sw $18,5692($15)
	sw $17,5696($15)
	sw $17,5700($15)
	sw $17,5704($15)
	sw $17,5708($15)
	sw $17,5712($15)
	sw $18,5716($15)
	sw $16,5720($15)
	sw $16,5724($15)
	sw $18,5728($15)
#---------------
	jal timer_caveira
	sw $18,6140($15)
	sw $16,6144($15)
	sw $16,6148($15)
	sw $18,6152($15)
	sw $17,6156($15)
	sw $17,6160($15)
	sw $17,6164($15)
	sw $17,6168($15)
	sw $17,6172($15)
	sw $18,6176($15)
	sw $16,6180($15)
	sw $16,6184($15)
	sw $16,6188($15)
	sw $16,6192($15)
	sw $16,6196($15)
	sw $16,6200($15)
	sw $18,6204($15)
	sw $17,6208($15)
	sw $17,6212($15)
	sw $17,6216($15)
	sw $17,6220($15)
	sw $17,6224($15)
	sw $18,6228($15)
	sw $16,6232($15)
	sw $16,6236($15)
	sw $18,6240($15)
	jal timer_caveira

	sw $18,6652($15)
	sw $16,6656($15)
	sw $16,6660($15)
	sw $18,6664($15)
	sw $17,6668($15)
	sw $17,6672($15)
	sw $17,6676($15)
	sw $17,6680($15)
	sw $17,6684($15)
	sw $18,6688($15)
	sw $16,6692($15)
	sw $16,6696($15)
	sw $16,6700($15)
	sw $16,6704($15)
	sw $16,6708($15)
	sw $16,6712($15)
	sw $18,6716($15)
	sw $17,6720($15)
	sw $17,6724($15)
	sw $17,6728($15)
	sw $17,6732($15)
	sw $17,6736($15)
	sw $18,6740($15)
	sw $16,6744($15)
	sw $16,6748($15)
	sw $18,6752($15)
	jal timer_caveira

	sw $18,7164($15)
	sw $16,7168($15)
	sw $16,7172($15)
	sw $18,7176($15)
	sw $17,7180($15)
	sw $17,7184($15)
	sw $17,7188($15)
	sw $17,7192($15)
	sw $17,7196($15)
	sw $18,7200($15)
	sw $16,7204($15)
	sw $16,7208($15)
	sw $16,7212($15)
	sw $16,7216($15)
	sw $16,7220($15)
	sw $16,7224($15)
	sw $18,7228($15)
	sw $17,7232($15)
	sw $17,7236($15)
	sw $17,7240($15)
	sw $17,7244($15)
	sw $17,7248($15)
	sw $18,7252($15)
	sw $16,7256($15)
	sw $16,7260($15)
	sw $18,7264($15)
#---------------
	jal timer_caveira
	sw $18,7676($15)
	sw $16,7680($15)
	sw $16,7684($15)
	sw $18,7688($15)
	sw $18,7692($15)
	sw $18,7696($15)
	sw $18,7700($15)
	sw $18,7704($15)
	sw $18,7708($15)
	sw $16,7712($15)
	sw $16,7716($15)
	sw $16,7720($15)
	sw $16,7724($15)
	sw $16,7728($15)
	sw $16,7732($15)
	sw $16,7736($15)
	sw $16,7740($15)
	sw $18,7744($15)
	sw $18,7748($15)
	sw $18,7752($15)
	sw $18,7756($15)
	sw $18,7760($15)
	sw $18,7764($15)
	sw $16,7768($15)
	sw $16,7772($15)
	sw $18,7776($15)
#---------------
	jal timer_caveira
	sw $18,8192($15)
	sw $16,8196($15)
	sw $16,8200($15)
	sw $16,8204($15)
	sw $16,8208($15)
	sw $16,8212($15)
	sw $16,8216($15)
	sw $16,8220($15)
	sw $16,8224($15)
	sw $16,8228($15)
	sw $16,8232($15)
	sw $16,8236($15)
	sw $16,8240($15)
	sw $16,8244($15)
	sw $16,8248($15)
	sw $16,8252($15)
	sw $16,8256($15)
	sw $16,8260($15)
	sw $16,8264($15)
	sw $16,8268($15)
	sw $16,8272($15)
	sw $16,8276($15)
	sw $16,8280($15)
	sw $18,8284($15)
#---------------
	jal timer_caveira
	sw $18,8708($15)
	sw $16,8712($15)
	sw $16,8716($15)
	sw $16,8720($15)
	sw $16,8724($15)
	sw $16,8728($15)
	sw $16,8732($15)
	sw $16,8736($15)
	sw $16,8740($15)
	sw $18,8744($15)
	sw $18,8748($15)
	sw $18,8752($15)
	sw $18,8756($15)
	sw $16,8760($15)
	sw $16,8764($15)
	sw $16,8768($15)
	sw $16,8772($15)
	sw $16,8776($15)
	sw $16,8780($15)
	sw $16,8784($15)
	sw $16,8788($15)
	sw $18,8792($15)
#----------------
	jal timer_caveira
	sw $18,9224($15)
	sw $16,9228($15)
	sw $16,9232($15)
	sw $16,9236($15)
	sw $16,9240($15)
	sw $16,9244($15)
	sw $16,9248($15)
	sw $16,9252($15)
	sw $18,9256($15)
	sw $18,9260($15)
	sw $18,9264($15)
	sw $18,9268($15)
	sw $16,9272($15)
	sw $16,9276($15)
	sw $16,9280($15)
	sw $16,9284($15)
	sw $16,9288($15)
	sw $16,9292($15)
	sw $16,9296($15)
	sw $18,9300($15)
#---------------
	jal timer_caveira
	sw $18,9740($15)
	sw $16,9744($15)
	sw $16,9748($15)
	sw $16,9752($15)
	sw $16,9756($15)
	sw $16,9760($15)
	sw $16,9764($15)
	sw $18,9768($15)
	sw $18,9772($15)
	sw $18,9776($15)
	sw $18,9780($15)
	sw $16,9784($15)
	sw $16,9788($15)
	sw $16,9792($15)
	sw $16,9796($15)
	sw $16,9800($15)
	sw $16,9804($15)
	sw $18,9808($15)
#----------------
	jal timer_caveira
	sw $18,10256($15)
	sw $16,10260($15)
	sw $16,10264($15)
	sw $16,10268($15)
	sw $16,10272($15)
	sw $16,10276($15)
	sw $16,10280($15)
	sw $16,10284($15)
	sw $16,10288($15)
	sw $16,10292($15)
	sw $16,10296($15)
	sw $16,10300($15)
	sw $16,10304($15)
	sw $16,10308($15)
	sw $16,10312($15)
	sw $18,10316($15)
	jal timer_caveira

	sw $18,10768($15)
	sw $16,10772($15)
	sw $16,10776($15)
	sw $16,10780($15)
	sw $16,10784($15)
	sw $16,10788($15)
	sw $16,10792($15)
	sw $16,10796($15)
	sw $16,10800($15)
	sw $16,10804($15)
	sw $16,10808($15)
	sw $16,10812($15)
	sw $16,10816($15)
	sw $16,10820($15)
	sw $16,10824($15)
	sw $18,10828($15)
	jal timer_caveira

	sw $18,11280($15)
	sw $16,11284($15)
	sw $16,11288($15)
	sw $16,11292($15)
	sw $16,11296($15)
	sw $18,11300($15)
	sw $16,11304($15)
	sw $16,11308($15)
	sw $16,11312($15)
	sw $16,11316($15)
	sw $18,11320($15)
	sw $16,11324($15)
	sw $16,11328($15)
	sw $16,11332($15)
	sw $16,11336($15)
	sw $18,11340($15)
	jal timer_caveira
	sw $18,11792($15)
	sw $16,11796($15)
	sw $16,11800($15)
	sw $16,11804($15)
	sw $16,11808($15)
	sw $18,11812($15)
	sw $16,11816($15)
	sw $16,11820($15)
	sw $16,11824($15)
	sw $16,11828($15)
	sw $18,11832($15)
	sw $16,11836($15)
	sw $16,11840($15)
	sw $16,11844($15)
	sw $16,11848($15)
	sw $18,11852($15)
#-----------------
	jal timer_caveira
	sw $18,12308($15)
	sw $18,12312($15)
	sw $18,12316($15)
	sw $18,12320($15)
	sw $18,12324($15)
	sw $18,12328($15)
	sw $18,12332($15)
	sw $18,12336($15)
	sw $18,12340($15)
	sw $18,12344($15)
	sw $18,12348($15)
	sw $18,12352($15)
	sw $18,12356($15)
	sw $18,12360($15)
	jal timer_caveira
	
	lw $ra,0($sp)
	lw $15,4($sp)
	lw $16,8($sp)
	lw $17,12($sp)
	lw $18,16($sp)
	addi $sp,$sp,20
	addi $2,$0,10
	syscall
#--------------------------
Game_win:
	addi $sp,$sp,24
	sw $ra,0($sp)
	sw $8,4($sp)
	sw $12,8($sp)
	sw $15,12($sp)
	sw $16,16($sp)
	sw $17,20($sp)
	sw $18,24($sp)
	
	lui $8,0x1001
	addi $8,$8,12484
	ori $12,$0,0x000000
	lui $15,0x1001
	addi $15,$15,20172
	
	ori $16,$0,0xFFF980 #mais claro
	ori $17,$0,0xFFF200 #medio 
	ori $18,$0,0xFFC90E #mais escuro
	# 6 de largura e 9 de altura
	#0
	sw $12,0($8)
	
	sw $12,0($8)

	sw $12,12($8)

	sw $12,24($8)

	sw $12,40($8)
	sw $12,44($8)
	sw $12,48($8)
	sw $12,52($8)
	sw $12,56($8)

	sw $12,72($8)
	sw $12,76($8)

	sw $12,100($8)

	sw $12,124($8)
#-------------
	sw $12,512($8)

	sw $12,524($8)

	sw $12,536($8)


	sw $12,560($8)


	sw $12,584($8)

	sw $12,592($8)

	sw $12,612($8)

	sw $12,636($8)
#------------
	sw $12,1024($8)

	sw $12,1036($8)

	sw $12,1048($8)

	sw $12,1072($8)

	sw $12,1096($8)

	sw $12,1108($8)

	sw $12,1124($8)

	sw $12,1148($8)
#--------------
	sw $12,1536($8)

	sw $12,1548($8)

	sw $12,1560($8)

	sw $12,1584($8)

	sw $12,1608($8)

	sw $12,1624($8)

	sw $12,1636($8)

	sw $12,1660($8)
#-------------
	sw $12,2048($8)

	sw $12,2060($8)

	sw $12,2072($8)
	
	sw $12,2096($8)

	sw $12,2120($8)

	sw $12,2140($8)

	sw $12,2148($8)

	sw $12,2172($8)
#--------------
	sw $12,2560($8)

	sw $12,2572($8)

	sw $12,2584($8)

	sw $12,2608($8)

	sw $12,2632($8)

	sw $12,2656($8)
	sw $12,2660($8)

	sw $12,2684($8)
#---------------
	sw $12,3072($8)

	sw $12,3084($8)

	sw $12,3096($8)

	sw $12,3120($8)

	sw $12,3144($8)


	sw $12,3172($8)



	sw $12,3584($8)
	sw $12,3588($8)
	sw $12,3592($8)
	sw $12,3596($8)
	sw $12,3600($8)
	sw $12,3604($8)
	sw $12,3608($8)

	sw $12,3624($8)
	sw $12,3628($8)
	sw $12,3632($8)
	sw $12,3636($8)
	sw $12,3640($8)

	sw $12,3656($8)

	sw $12,3684($8)

	sw $12,3708($8)
#----------------

	sw $12,16($15)
	sw $12,20($15)
	sw $12,24($15)
	sw $12,28($15)
	sw $12,32($15)
	sw $12,36($15)
	sw $12,40($15)
	sw $12,44($15)
	sw $12,48($15)
	sw $12,52($15)
	sw $12,56($15)
	sw $12,60($15)
	sw $12,64($15)
	sw $12,68($15)
	sw $12,72($15)
	sw $12,76($15)



	sw $12,520($15)
	sw $12,524($15)
	sw $12,528($15)
	sw $16,532($15)
	sw $16,536($15)
	sw $16,540($15)
	sw $17,544($15)
	sw $17,548($15)
	sw $17,552($15)
	sw $17,556($15)
	sw $17,560($15)
	sw $17,564($15)
	sw $17,568($15)
	sw $18,572($15)
	sw $18,576($15)
	sw $18,580($15)
	sw $18,584($15)
	sw $12,588($15)
	sw $12,592($15)
	sw $12,596($15)



	sw $12,1028($15)
	sw $17,1032($15)
	sw $17,1036($15)
	sw $12,1040($15)
	sw $16,1044($15)
	sw $16,1048($15)
	sw $17,1052($15)
	sw $17,1056($15)
	sw $17,1060($15)
	sw $17,1064($15)
	sw $17,1068($15)
	sw $17,1072($15)
	sw $17,1076($15)
	sw $17,1080($15)
	sw $18,1084($15)
	sw $18,1088($15)
	sw $18,1092($15)
	sw $18,1096($15)
	sw $12,1100($15)
	sw $17,1104($15)
	sw $17,1108($15)
	sw $12,1112($15)


	sw $12,1536($15)
	sw $17,1540($15)
	sw $17,1544($15)
	sw $12,1548($15)
	sw $12,1552($15)
	sw $16,1556($15)
	sw $16,1560($15)
	sw $17,1564($15)
	sw $17,1568($15)
	sw $17,1572($15)
	sw $17,1576($15)
	sw $17,1580($15)
	sw $17,1584($15)
	sw $17,1588($15)
	sw $17,1592($15)
	sw $18,1596($15)
	sw $18,1600($15)
	sw $18,1604($15)
	sw $18,1608($15)
	sw $12,1612($15)
	sw $12,1616($15)
	sw $17,1620($15)
	sw $18,1624($15)
	sw $12,1628($15)

	sw $12,2048($15)
	sw $17,2052($15)
	sw $12,2056($15)

	sw $12,2064($15)
	sw $16,2068($15)
	sw $16,2072($15)
	sw $17,2076($15)
	sw $17,2080($15)
	sw $17,2084($15)
	sw $17,2088($15)
	sw $17,2092($15)
	sw $17,2096($15)
	sw $17,2100($15)
	sw $17,2104($15)
	sw $18,2108($15)
	sw $18,2112($15)
	sw $18,2116($15)
	sw $18,2120($15)
	sw $12,2124($15)

	sw $12,2132($15)
	sw $17,2136($15)
	sw $12,2140($15)

	sw $12,2560($15)
	sw $18,2564($15)
	sw $12,2568($15)

	sw $12,2576($15)
	sw $16,2580($15)
	sw $16,2584($15)
	sw $17,2588($15)
	sw $17,2592($15)
	sw $17,2596($15)
	sw $17,2600($15)
	sw $17,2604($15)
	sw $17,2608($15)
	sw $17,2612($15)
	sw $17,2616($15)
	sw $18,2620($15)
	sw $18,2624($15)
	sw $18,2628($15)
	sw $18,2632($15)
	sw $12,2636($15)

	sw $12,2644($15)
	sw $17,2648($15)
	sw $12,2652($15)

	sw $12,3072($15)
	sw $18,3076($15)
	sw $12,3080($15)

	sw $12,3088($15)
	sw $16,3092($15)
	sw $16,3096($15)
	sw $16,3100($15)
	sw $17,3104($15)
	sw $17,3108($15)
	sw $17,3112($15)
	sw $17,3116($15)
	sw $17,3120($15)
	sw $17,3124($15)
	sw $17,3128($15)
	sw $18,3132($15)
	sw $18,3136($15)
	sw $18,3140($15)
	sw $18,3144($15)
	sw $12,3148($15)

	sw $12,3156($15)
	sw $17,3160($15)
	sw $12,3164($15)

	sw $12,3584($15)
	sw $16,3588($15)
	sw $16,3592($15)
	sw $12,3596($15)
	sw $12,3600($15)
	sw $16,3604($15)
	sw $16,3608($15)
	sw $16,3612($15)
	sw $16,3616($15)
	sw $17,3620($15)
	sw $17,3624($15)
	sw $17,3628($15)
	sw $17,3632($15)
	sw $17,3636($15)
	sw $18,3640($15)
	sw $18,3644($15)
	sw $18,3648($15)
	sw $18,3652($15)
	sw $18,3656($15)
	sw $12,3660($15)
	sw $12,3664($15)
	sw $18,3668($15)
	sw $17,3672($15)
	sw $12,3676($15)


	sw $12,4100($15)
	sw $18,4104($15)
	sw $17,4108($15)
	sw $12,4112($15)
	sw $12,4116($15)
	sw $16,4120($15)
	sw $16,4124($15)
	sw $16,4128($15)
	sw $16,4132($15)
	sw $17,4136($15)
	sw $17,4140($15)
	sw $17,4144($15)
	sw $18,4148($15)
	sw $18,4152($15)
	sw $18,4156($15)
	sw $18,4160($15)
	sw $18,4164($15)
	sw $12,4168($15)
	sw $12,4172($15)
	sw $17,4176($15)
	sw $17,4180($15)
	sw $12,4184($15)




	sw $12,4620($15)
	sw $17,4624($15)
	sw $17,4628($15)
	sw $12,4632($15)
	sw $12,4636($15)
	sw $16,4640($15)
	sw $16,4644($15)
	sw $16,4648($15)
	sw $17,4652($15)
	sw $17,4656($15)
	sw $18,4660($15)
	sw $18,4664($15)
	sw $18,4668($15)
	sw $12,4672($15)
	sw $12,4676($15)
	sw $17,4680($15)
	sw $17,4684($15)
	sw $12,4688($15)


	sw $12,5144($15)
	sw $12,5148($15)
	sw $12,5152($15)
	sw $12,5156($15)
	sw $12,5160($15)
	sw $12,5164($15)
	sw $12,5168($15)
	sw $12,5172($15)
	sw $12,5176($15)
	sw $12,5180($15)
	sw $12,5184($15)
	sw $12,5188($15)


	sw $12,5664($15)
	sw $12,5668($15)
	sw $12,5672($15)
	sw $12,5676($15)
	sw $12,5680($15)
	sw $12,5684($15)
	sw $12,5688($15)
	sw $12,5692($15)


	sw $12,6180($15)
	sw $12,6184($15)
	sw $12,6188($15)
	sw $12,6192($15)
	sw $12,6196($15)
	sw $12,6200($15)



	sw $12,6696($15)
	sw $17,6700($15)
	sw $17,6704($15)
	sw $12,6708($15)



	sw $12,7208($15)
	sw $17,7212($15)
	sw $18,7216($15)
	sw $12,7220($15)



	sw $12,7720($15)
	sw $17,7724($15)
	sw $18,7728($15)
	sw $12,7732($15)



	sw $12,8232($15)
	sw $18,8236($15)
	sw $18,8240($15)
	sw $12,8244($15)



	sw $12,8744($15)
	sw $17,8748($15)
	sw $18,8752($15)
	sw $12,8756($15)
	


	sw $12,9256($15)
	sw $17,9260($15)
	sw $18,9264($15)
	sw $12,9268($15)



	sw $12,9768($15)
	sw $17,9772($15)
	sw $18,9776($15)
	sw $12,9780($15)



	sw $12,10276($15)
	sw $18,10280($15)
	sw $18,10284($15)
	sw $17,10288($15)
	sw $18,10292($15)
	sw $12,10296($15)


	sw $12,10784($15)
	sw $12,10788($15)
	sw $12,10792($15)
	sw $12,10796($15)
	sw $12,10800($15)
	sw $12,10804($15)
	sw $12,10808($15)
	sw $12,10812($15)


	sw $12,11292($15)
	sw $17,11296($15)
	sw $17,11300($15)
	sw $18,11304($15)
	sw $18,11308($15)
	sw $17,11312($15)
	sw $18,11316($15)
	sw $17,11320($15)
	sw $17,11324($15)
	sw $12,11328($15)



	sw $12,11804($15)
	sw $12,11808($15)
	sw $12,11812($15)
	sw $12,11816($15)
	sw $12,11820($15)
	sw $12,11824($15)
	sw $12,11828($15)
	sw $12,11832($15)
	sw $12,11836($15)
	sw $12,11840($15)
	
	lw $ra,0($sp)
	lw $8,4($sp)
	lw $12,8($sp)
	lw $15,12($sp)
	lw $16,16($sp)
	lw $17,20($sp)
	lw $18,24($sp)	
	
	addi $sp,$sp,28
	
	addi $2,$0,10
	syscall
	
	
	
	
	
	
	
	
	

	
	
	
