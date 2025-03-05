# Boulder Dash (Assembly Language Project)

## Overview  
This project is a simplified version of the classic DOS game **Boulder Dash**, developed in assembly language using **NASM**. The game involves navigating underground caves, collecting diamonds, and avoiding boulders while trying to reach the exit.  

## Features  
- Reads the cave structure from a text file (`cave1.txt`).  
- Displays the game layout with **title, headers, footers, and cave internals**.  
- Implements file handling with error detection for:  
  - **Missing file**.  
  - **Insufficient file size (<1600 bytes)**.  
- Keeps the program visible until the user exits with **Esc key**.  
- Accepts **arrow key inputs** to move Rockford.  
- Restricts movement into walls and boulders.  
- Implements game conditions:  
  - **Collecting diamonds increases score**.  
  - **Reaching the target exits the game**.  
  - **Moving under a boulder results in game over**.  
  

## Installation & Usage  
1. Clone the repository:  
   ```bash
   git clone https://github.com/your-username/boulder-dash-assembly.git
   cd boulder-dash-assembly
   ```
2. Assemble the program using **NASM**:  
   ```bash
   nasm -f bin main.asm -o game.com
   ```
3. Run the game in DOSBox or any MS-DOS-compatible environment:  
   ```bash
   dosbox game.com
   ```

## Requirements  
- NASM Assembler  
- DOSBox or MS-DOS emulator  
