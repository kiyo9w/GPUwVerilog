# GPUwVerilog
Simple GPU Design in Verilog

We are a group of students working on designing a simple GPU using Verilog. Our aim is to study and implement basic GPU functionalities to help us understand more on hardware designs and parallel processing.

---

## Table of Contents
- [Architecture](#architecture)
- [About the Pre-defined Program for Testing Simulation](#about-the-pre-defined-program-for-testing-simulation)
- [To Run](#to-run)
- [Completed Tasks by Week](#completed-tasks-by-week)
- [Planned Tasks](#planned-tasks)
- [Acknowledgments](#acknowledgments)

---

## Architecture
![architecture drawio](https://github.com/user-attachments/assets/792c9616-d6c7-4104-8f67-dc89ae7a1104)

Special thanks to our teammates [@Soap](https://github.com/Spavvvv) and [@Kaiser287](https://github.com/Kaiser287) for their efforts of drawing the diagram.

---

## About the Pre-defined Program for Testing Simulation

This program is a simple test of the GPU's ability to execute instructions on different threads. Below are the details:

### Memory Setup
- **Data Memory**: Initial values set as follows:
  - `memory[0] = 3`
  - `memory[5] = 5`
- **Instruction Memory**: Contains the binary instructions listed below.

### Instructions
| Address | Assembly Code                 | Binary Instruction | Explanation                                       |
|---------|-------------------------------|--------------------|---------------------------------------------------|
| `0x0000`| `LDR R0, [0]`                | `0x6000`           | Load value from memory[0] into register R0.       |
| `0x0001`| `LDR R1, [1]`                | `0x6101`           | Load value from memory[1] into register R1.       |
| `0x0002`| `ADD R2 = R0 + R1 + 16`      | `0x0210`           | R2 = 3 + 5 + 16 = 24.                            |
| `0x0003`| `SUB R3 = R2 - R0 - 0`       | `0x1300`           | R3 = 24 - 3 = 21.                                |
| `0x0004`| `CMP R3, R2`                 | `0x3320`           | Compare R3 and R2. Sets `cmp_flag = 1` since `R3 < R2`. |
| `0x0005`| `JLT 0x0A`                   | `0x500A`           | Jump to address `0x0A` if `cmp_flag = 1`.         |
| `0x0006`| `MUL R4 = R2 * R3`           | `0x2430`           | (Only if no jump occurs): R4 = 24 * 21 = 504.     |
| `0x0007`| `STR R4, [2]`                | `0x7402`           | Store value of R4 into memory[2].                 |
| `0x0008`| `HALT`                       | `0xF000`           | Halt execution.                                   |
| `0x0009`| `NOP`                        | `0x0000`           | No operation (e.g., `ADD R0 = R0 + R0 + 0`).      |
| `0x000A`| `LDR R5, [1]`                | `0x6501`           | Load value from memory[1] into register R5.       |
| `0x000B`| `ADD R5 = R5 + R0 + 0`       | `0x0500`           | R5 = 5 + 3 + 0 = 8.                              |
| `0x000C`| `STR R5, [3]`                | `0x7503`           | Store value of R5 into memory[3].                 |
| `0x000D`| `HALT`                       | `0xF000`           | Halt execution.                                   |
| `0x000E`| `NOP`                        | `0x0000`           | No operation.                                     |
| `0x000F`| `NOP`                        | `0x0000`           | No operation.                                     |

---

## To Run

1. **Install Requirements**:
   - Install [Icarus Verilog](https://iverilog.fandom.com/wiki/Installation) using:
     ```bash
     brew install icarus-verilog
     ```
   - Install [Cocotb](https://docs.cocotb.org/en/stable/) using:
     ```bash
     pip install cocotb
     ```

2. **Run Simulation**:
   - Navigate to the root directory of the project.
   - Execute:
     ```bash
     make
     ```

---

## Completed Tasks by Week

| # Week | Tasks Completed                                |
|--------|-----------------------------------------------|
| 1      | Formed group & decided our project            |
| 2      | Set up development environment, getting started |
|        | with Verilog syntax & basic GPU knowledge     |
| 3      | Researched GPU architectures and its components |
| 4      | High-Level Design and Specification           |
| 5      | Module development                            |
| 6      | Module development                            |
| 7      | Module development                            |
| 8      | On class presentation                         |

---

## Planned Tasks

| Task                               | Weight | Status       |
|------------------------------------|--------|--------------|
| Implement program counter          | High   | Completed    |
| Implement register file            | High   | Completed    |
| Implement memory interface and LSU | High   | Partially    |
| Implement ALU                      | High   | Completed    |
| Implement control unit             | High   | Completed    |
| Implement instruction decoder      | High   | Completed    |
| Create testbenches for all modules | Medium | Completed  |
| Integrate all components           | Medium | Completed    |
| Perform simulation                 | Low    | Completed    |
| Optimize pre defined program for performance           | Low    | Completed  |
| Implement error handling and       | Medium | Completed    |
| debugging tools                    |        |              |
| Documentation with LaTex           | Low    | In progess  |
| Create visualization for           | Medium | Planned      |
| simulation results                 |        |              |
| Add support for shared memory      | Medium | Planned      |

---

## Acknowledgments

We would like to thank [adam-maj/tiny-gpu](https://github.com/adam-maj/tiny-gpu) for inspiring our project.
