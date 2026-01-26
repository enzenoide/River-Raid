# 🎮 River Raid – Assembly MIPS (MARS)

Este projeto é uma **recriação do jogo clássico River Raid**, originalmente lançado para o console **Atari**, sendo um dos títulos mais populares da plataforma.

O projeto foi desenvolvido **inteiramente em Assembly MIPS**, utilizando o simulador **MARS (MIPS Assembler and Runtime Simulator)**, com foco em programação de baixo nível e manipulação direta de recursos simulados.

---

## 🛠️ Tecnologias Utilizadas

- **Assembly MIPS**
- **MARS (MIPS Assembler and Runtime Simulator)**
- Bitmap Display
- Keyboard and Display MMIO Simulator

---

## ▶️ Como Jogar

### 1. Download do Simulador

Faça o download do simulador **MARS** pelo link oficial:

🔗 *(https://github.com/dpetersanderson/MARS/releases/tag/v.4.5.1)*

---

### 2. Executando o Jogo

1. Abra o simulador **MARS**
2. Baixe o arquivo `RiverRaid.asm` disponível neste repositório
3. No MARS, abra o arquivo `RiverRaid.asm`
4. Vá até a aba **Tools** e abra:
   - **Bitmap Display**
     - `Unit Width`: **4**
     - `Unit Height`: **4**
     - `Display Width`: **512**
     - `Display Height`: **512**
     - Clique em **Connect to MIPS**
5. Ainda na aba **Tools**, abra:
   - **Keyboard and Display MMIO Simulator**
     - Clique em **Connect to MIPS**
6. Vá até a aba **Run**:
   - Clique em **Assemble**
   - Em seguida, clique em **Go**

Após esses passos, o jogo será iniciado corretamente.

---

## 🎮 Controles

- **W** — Atirar  
- **A** — Mover para a esquerda  
- **D** — Mover para a direita  

---

## 🕹️ Mecânicas do Jogo

- O jogador controla um avião e deve **destruir as entidades inimigas** para ganhar pontos.
- Uma das entidades representam **combustível**:
  - O combustível deve ser coletado para evitar que o avião fique sem energia.
  - Caso o combustível acabe, o jogador perde.
- Se o jogador **colidir com qualquer entidade**, o jogo termina.
- O jogador vence ao atingir **300 pontos**.

---

## 📚 Coisas que Aprendi

Durante o desenvolvimento deste projeto, foi possível consolidar diversos conceitos importantes relacionados à programação de baixo nível, entre eles:

- Estruturação de um projeto completo utilizando **Assembly MIPS**
- Manipulação direta de **registradores**, memória e pilha
- Controle de fluxo utilizando **branches**, **jumps** e sub-rotinas
- Implementação de **lógica de jogo** sem o uso de estruturas de alto nível
- Detecção de colisões e controle de estado do jogo
- Manipulação gráfica por meio do **Bitmap Display** do MARS
- Comunicação com dispositivos de entrada através do **Keyboard and Display MMIO Simulator**
- Gerenciamento de tempo e atualização contínua do jogo (game loop)
- Organização e modularização de código Assembly para melhorar legibilidade e manutenção
- Depuração e testes em ambiente de simulação

---

## 📌 Observações

Este projeto possui caráter **educacional**, tendo como objetivo principal o aprendizado e a prática de conceitos fundamentais de programação em baixo nível, simulação de hardware e desenvolvimento de jogos utilizando Assembly.

