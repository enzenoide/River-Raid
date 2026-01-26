🎮 River Raid – Assembly MIPS (MARS)

Este projeto é uma recriação do jogo clássico River Raid, originalmente lançado para o console Atari, um dos títulos mais populares da época.

A implementação foi desenvolvida integralmente em Assembly MIPS, utilizando o simulador MARS, com foco em baixo nível, manipulação direta de memória e dispositivos de entrada/saída simulados.

🛠️ Tecnologias Utilizadas

Assembly MIPS

MARS (MIPS Assembler and Runtime Simulator)

Bitmap Display

Keyboard and Display MMIO Simulator

▶️ Como Jogar
1. Download do Simulador

Faça o download do simulador MARS pelo link oficial:

🔗 (adicione aqui o link de download do MARS)

2. Executando o Jogo

Abra o simulador MARS

Baixe o arquivo RiverRaid.asm disponível neste repositório

No MARS, abra o arquivo RiverRaid.asm

Vá até a aba Tools e abra:

Bitmap Display

Unit Width: 4

Unit Height: 4

Display Width: 512

Display Height: 512

Clique em Connect to MIPS

Ainda em Tools, abra:

Keyboard and Display MMIO Simulator

Clique em Connect to MIPS

Vá até a aba Run:

Clique em Assemble

Em seguida, clique em Go

O jogo será iniciado após esses passos.

🎮 Controles

W — Atirar

A — Mover para a esquerda

D — Mover para a direita

🕹️ Mecânicas do Jogo

O jogador controla um avião e deve destruir entidades inimigas para ganhar pontos.

Algumas entidades representam combustível:

É obrigatório coletá-lo para evitar que o combustível do avião acabe.

Caso o combustível chegue a zero, o jogador perde.

Se o jogador colidir com qualquer entidade, o jogo termina.

A vitória é alcançada ao atingir 300 pontos.

📚 Coisas que Aprendi

(Em breve)

📌 Observações

Este projeto tem caráter educacional, com o objetivo de praticar conceitos de:

Programação em baixo nível

Manipulação de memória

Interação com dispositivos simulados

Lógica de jogos em Assembly
