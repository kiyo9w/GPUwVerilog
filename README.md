# GPUwVerilog
Simple GPU Design in Verilog

We are a group of students working on designing a simple GPU using Verilog. Our aim is to study and implement basic GPU functionalities to help us understand more on hardware designs and parallel processing.

We have taken some inspiration from [adam-maj/tiny-gpu](https://github.com/adam-maj/tiny-gpu), our project is independently developed to suit our learning objectives.

## Architecture
![architecture drawio](https://github.com/user-attachments/assets/792c9616-d6c7-4104-8f67-dc89ae7a1104)

Special thanks to our teammates [@Soap](https://github.com/Spavvvv) and [@Kaiser287](https://github.com/Kaiser287) for their efforts of drawing the diagram

## About the pre-defined program for testing simulation
This program is just a simple test for its ability to run instructions on different threads.
Defined in instruction_memory.mem, below is the translated binary instruction for the program.
Note that we placed the values 3 on memory location [0] and 5 on memory location [5], defined in data_memory.mem.

	1.	0x0000: LDR R0, [0]
Instruction = 0x6000
	2.	0x0001: LDR R1, [1]
Instruction = 0x6101
	3.	0x0002: ADD R2 = R0 + R1 + 16
Instruction = 0x0210
After execution: R2 = 3 + 5 + 16 = 24.
	4.	0x0003: SUB R3 = R2 - R0 - 0
Instruction = 0x1300
After execution: R3 = 24 - 3 = 21.
	5.	0x0004: CMP R3, R2
Instruction = 0x3320
Sets cmp_flag=1 since R3(21)<R2(24).
	6.	0x0005: JLT 0x0A
Instruction = 0x500A
	7.	If no jump occurs (cmp_flag=0 scenario), next: 0x0006: MUL R4 = R2 * R3
Instruction = 0x2430
R4=24*21=504.
	8.	0x0007: STR R4, [2]
Instruction = 0x7402
	9.	0x0008: HALT
Instruction = 0xF000
	10.	0x0009: NOP (just do ADD R0=R0+R0+0 for no effect)
Instruction = 0x0000
If JLT taken (cmp_flag=1) jump here:
	11.	0x000A: LDR R5, [1]
Instruction = 0x6501
	12.	0x000B: ADD R5 = R5 + R0 + 0
Instruction = 0x0500
R5 = 5 + 3 + 0 = 8.
	13.	0x000C: STR R5, [3]
Instruction = 0x7503
	14.	0x000D: HALT
0xF000
	15.	0x000E: NOP = 0x0000
	16.	0x000F: NOP = 0x0000

## To Run
Install icarus verilog and cocotb from the command line using `brew install icarus-verilog`and `pip install cocotb`
Simply run the command `make` from the root of the program

## Completed Tasks by Week

|# Week | Tasks Completed                                |
|------|-------------------------------------------------|
| 1    | Formed group & decided our project              |
| 2    | Set up development environment, getting started |
|      | with verilog sytax & basic GPU knowledge        |
| 3    | Researched GPU architectures and its componetns |
| 4    | High-Level Design and Specification             |
| 5    | Module development                              |
| 6    | Module development                              |
| 7    | Module development                              |

## Planned Tasks

| Task                               | Weight | Status       |
|------------------------------------|--------|--------------|
| Implement program counter          | High   | Completed    |
| Implement register file            | High   | Completed    |
| Implement memory interface and LSU | High   | Partially    |
| Implement ALU                      | High   | Completed    |
| Implement control unit             | High   | Completed    |
| Implement instruction decoder      | High   | Completed    |
| Create testbenches for all modules | Medium | In progess   |
| Integrate all components           | Medium | Completed    |
| Perform simulation                 | Low    | Completed    |
| Optimize for performance           | Low    | Not Started  |
| Implement error handling and       | Medium | Completed    |
| debugging tools                    |        |              |
| Documentation with LaTex           | Low    | Not Started  |
| Create visualization for           | Medium | Planed       |
| simulation results                 |        |              |
| Add support for shared memory      | Medium | Planed       |

## Acknowledgments

We would like to thank [adam-maj/tiny-gpu](https://github.com/adam-maj/tiny-gpu) for inspiring our project.
