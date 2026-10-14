# UVM_FIFO_Verification_Environment

## Overview
A complete UVM verification environment built from scratch for an asynchronous FIFO DUT. 
This project follows the first 13 chapters of the *UVM Primer* by Ray Salemi, and represents a hands-on journey into industry-standard functional verification methodology.

## Objective
Build a reusable, scalable UVM testbench that verifies the `asyncFIFO_RTL_CDC` DUT using constrained-random stimulus and self-checking scoreboards.

## Tools & Technologies
- **Language:** SystemVerilog + UVM
- **Compile & Elaboration:** Xilinx Vivado
- **Simulation:** Xilinx Simulator: Xsim
- **Methodology:** UVM 1.2
- **Reference:** *UVM Primer* by Ray Salemi

## Repository Structure
├───FIFO_uvm_tb_ver0
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
   cd FPGA_misc_projects/FIFO_uvm_tb_ver0
   ##follow the instructions from the Setup_instructions.txt file


##Notes and Learnings
