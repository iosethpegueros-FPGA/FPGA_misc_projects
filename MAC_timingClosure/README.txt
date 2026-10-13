# MAC_timingClosure

## Overview
Implementation of a Multiply-Accumulate (MAC) unit in SystemVerilog, intentionally designed with a constrained architecture to generate and study timing violations in Vivado. This project serves as a hands-on exercise in Static Timing Analysis (STA) and timing closure strategies.

## Objective
The MAC unit is deliberately built using ripple-carry adders and a shift-and-add multiplier instead of DSP48 blocks. This forces long combinational paths and creates setup violations that must be analyzed and resolved through constraint definition and placement strategies.

## Tools & Technologies
- **Language:** SystemVerilog
- **Synthesis & Implementation:** Xilinx Vivado
- **Target Device:** [Xilinx Artix-7 XC7Z020-1CLG400C / PYNQ-Z1 board]
- **Analysis:** Vivado Timing Report, STA

## Repository Structure
├───MAC_timingClosure
│   ├───constraints
│   ├───results/# project and generated reports
│   ├───rtl
│   ├───scripts
│   └───tb
│   └─── Setup_instructions.txt /#instructions to build, synthesize, elaborate and generate timming reports

## How to Use
1. Clone the repository:
   ```windows command prompt
   git clone https://github.com/iosethpegueros-FPGA/FPGA_misc_projects.git
   cd FPGA_misc_projects/MAC_timingClosure
   ##follow the instructions from the Setup_instructions.txt file



##learnings and Notes
This exercise implements a multiply-and-accumulate operation for an FPGA, avoiding the use of DSP blocks.

Goal: create a real scenario where deep logic generates timing violations due to: multiple data layers (logic), fanout, or routing.

Initially, a MAC operation was implemented using a carry-ripple adder. The module has two 32-bit shift registers to enter the operands, followed by a multiplier implemented by the tool and then the custom adder. 
The shift registers are used only for future implementation on an actual development board. The 32 clock cycles required for the operands to become available are disregarded for the purpose of this exercise.

The input operands take 32 clock cycles to “deliver” the parallel data. This could be done in one cycle if the input of the model is connected to a 32-bit bus or a FIFO.

The first compilation test created this type of violation (log below) due to the long datapath. The datapath is 17.52 ns, while the requirement is 7.14 ns. 
  The delay is composed of combinational logic in the multiplier and the adder, plus routing delay (mainly >60%).

Q: How is routing delay fixed? Indirectly, by adding pipeline stages (this approach will be used for this example). Other techniques are register replication and, less effectively, using another place-and-route strategy.

The most direct way to mitigate this is to add a pipeline stage between the multiplier and the adder. That will significantly reduce the datapath.

Q: How much will the violation be reduced? Running at 500 MHz (t = 2 ns), roughly speaking, 19 ns / 2 ns = ~9. Nine is the calculated number of pipeline stages needed to completely eliminate timing violations.

- The module will take at least two clock cycles to generate a result: a 4 ns delay.
- In theory (ignoring the 32-bit shift register), back-to-back operations can be performed after “wasting” the first clock cycle.
- By having appropriate data-flow control, the stages we add will be “hidden.”

1. Before implementing pipelining  
1.1 Worst clock slack is –10.52 ns when combining multiplier and adder logic.  
1.2 230 failing points.  
1.3 14 to 19 logic levels.  
1.4 All of the reported violations happened between the operand B output and the accumulators, and they are mainly routing-related, with ~60% of the total violation.
    Most likely, all the signals have this type of delay, so changing the synthesis strategy or place-and-route strategy will generate the same violation over and over. 
    This is a “last-resort” fix for moving forward, but it will come back and cause problems again.

2. After implementing the first level of pipelining  
2.1 Worst clock slack is –7.93 ns when combining multiplier and adder logic.  
2.2 230 failing points.  
2.3 14 to 19 logic levels.  
2.4 Worst setup violation was reduced overall by 2.12 ns. Routing is still the biggest delay, ~60%.

3. After implementing the second level of pipelining  
Zero timing violations.

An alternative option is to replace the carry-ripple adder with a carry-lookahead adder and implement a faster combinational multiplier as well. 
This is an architecture decision, which deviates from the initial objective of the exercise. 
We could use DSP blocks only to do the same operations. So these options are disregarded for the sake of the exercise.
