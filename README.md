[ **English** ] | [ [Português](README.pt-BR.md) ]



# 🎮 River Raid – Assembly MIPS (MARS)

This project is a **recreation of the classic game River Raid**, originally released for the **Atari** console and considered one of the most popular titles on the platform.

The project was developed **entirely in Assembly MIPS**, using the **MARS (MIPS Assembler and Runtime Simulator)**, with a focus on low-level programming and direct manipulation of simulated resources.

---

## 🛠️ Technologies Used

- **Assembly MIPS**
- **MARS (MIPS Assembler and Runtime Simulator)**
- Bitmap Display
- Keyboard and Display MMIO Simulator

---

## ▶️ How to Play

### 1. Simulator Download

Download the **MARS** simulator from the official link:

🔗 https://github.com/dpetersanderson/MARS/releases/tag/v.4.5.1

---

### 2. Running the Game

1. Open the **MARS** simulator
2. Download the `RiverRaid.asm` file available in this repository
3. In MARS, open the `RiverRaid.asm` file
4. Go to the **Tools** tab and open:
   - **Bitmap Display**
     - `Unit Width`: **4**
     - `Unit Height`: **4**
     - `Display Width`: **512**
     - `Display Height`: **512**
     - Click **Connect to MIPS**
5. Still in the **Tools** tab, open:
   - **Keyboard and Display MMIO Simulator**
     - Click **Connect to MIPS**
6. Go to the **Run** tab:
   - Click **Assemble**
   - Then click **Go**

After completing these steps, the game will start correctly.

---

## 🎮 Controls

- **W** — Shoot  
- **A** — Move left  
- **D** — Move right  

---

## 🕹️ Game Mechanics

- The player controls an aircraft and must **destroy enemy entities** to earn points.
- One of the entities represents **fuel**:
  - Fuel must be collected to prevent the aircraft from running out of energy.
  - If the fuel runs out, the player loses.
- If the player **collides with any entity**, the game ends.
- The player wins by reaching **300 points**.

---

## 📚 What I Learned

During the development of this project, several important low-level programming concepts were reinforced, including:

- Structuring a complete project using **Assembly MIPS**
- Direct manipulation of **registers**, memory, and stack
- Flow control using **branches**, **jumps**, and subroutines
- Implementing **game logic** without high-level data structures
- Collision detection and game state management
- Graphics handling through the **MARS Bitmap Display**
- Input handling using the **Keyboard and Display MMIO Simulator**
- Time management and continuous game updates (game loop)
- Organization and modularization of Assembly code to improve readability and maintainability
- Debugging and testing in a simulated environment

---

## 📌 Notes

This project has an **educational purpose**, aiming to practice and reinforce fundamental concepts of low-level programming, hardware simulation, and game development using Assembly.
