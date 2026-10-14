
# asyncFIFO_RTL_CDC

## Overview
Implementation of an asynchronous FIFO in SystemVerilog for Clock Domain Crossing (CDC) analysis. This module is designed to serve as the Device Under Test (DUT) for a SystemVerilog testbench,
and eventually a full UVM verification environment.

## Objective
Build a robust, synthesizable asynchronous FIFO using Gray-code pointers and two-stage synchronizers to safely transfer data between two independent clock domains.
The project emphasizes CDC correctness, metastability mitigation, and verification readiness.


## Tools & Technologies
- **Language:** SystemVerilog
- **Simulation:** Vivado Simulator: Xsim
- **Verification:** SystemVerilog testbench
- **Target Device:** [Xilinx Artix-7 XC7Z020-1CLG400C / PYNQ-Z1 board]
- **Analysis:** waveform analysis, testbench logs

## Repository Structure
├───asyncFIFO_RTL_CDC
│   ├───constraints
│   ├───results/# project and generated reports
│   ├───rtl
│   ├───scripts/#instructions to build, synthesize, elaborate and generate timming reports
│   └───tb
│   └─── Setup_instructions.txt /#instructions to build, synthesize, elaborate and generate timming reports


## How to Use
1. Clone the repository:
   ```windows command prompt
   git clone https://github.com/iosethpegueros-FPGA/FPGA_misc_projects.git
   cd FPGA_misc_projects/asyncFIFO_RTL_CDC
   ##follow the instructions from the Setup_instructions.txt file



## Notes and Learnings 
This FIFO was implemented with the goal of developing the RTL description independently, without basing the design on other authors’ or reference implementations.
This approach is highly educational because it forces you to confront the typical challenges of CDC control logic and synchronization.
It also provides firsthand insight into why more sophisticated implementations—such as the one proposed by Clifford E. Cummings [1]—are designed the way they are.

To transmit data across clock domains, the preferred solution is an asynchronous FIFO. This approach supports multi-bit transfers while avoiding metastability and maintaining data coherence.
For single-bit data, a triple-flop synchronizer combined with a request-acknowledge handshake can be used. 
The number of synchronizer flops required to achieve a target MTBF can be estimated using the following formula, which depends on technology-specific experimental parameters:

	MTBF calculation 
		Depends on experimental values for  its paramters 
			// MTBF = e^(Tmet / tau ) / ( f_clk_dest * f_data * W ) 
			// Tmet available time to solve metastability ( for single flop use 4*Tau , for 2,3,4,etc. give it a full clock cycle eg 5ns for a 200MHZ clock
			// tau  tecnology resolution constant         ( ~20-30 ps for 28nm per majority of Internet/AI references)
			 // f_clk_dest destination clock frequency     (    
			// f_data toggle frequency                         
			// W      Flop's metastability window (.05-.2ps)
		
When using single flop some refernces sugest using  4x  tau value  for Tmet. Some recomend tau of 20 to 30ps (xilixn 28nm) for others 100 ps .
As a best-known method (BKM), two flops are generally sufficient for most CDC applications. A third flop may be added for higher reliability or very high frequencies, but it is not universally required.
Based on MTBF calculations, two flops are sufficient for a 100 MHz source and 200 MHz destination clock.


[1] Cummings, C. E., "Simulation and Synthesis Techniques for Asynchronous FIFO Design," Synopsys Users Group (SNUG) San Jose Proceedings, 2002, pp. 1-23.



Author
Ioseth Pegueros – Senior SoC Emulation Engineer
[linkedin](www.linkedin.com/in/iosethpegueros): 
