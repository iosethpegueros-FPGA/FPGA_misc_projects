# Behavioral_FIFO

## Overview
A golden model of a synchronous FIFO implemented in object-oriented SystemVerilog. This model serves as a reference for verifying RTL FIFO implementations, including the asynchronous FIFO in the `asyncFIFO_RTL_CDC` project.

## Objective
Provide a clean, cycle-accurate behavioral reference that mirrors the expected functionality of a hardware FIFO. The model is used in scoreboards and self-checking testbenches to compare DUT behavior against a trusted source.

## Tools & Technologies
- **Language:** SystemVerilog (OOP)
- **Simulation:** Vivado Simulator: Xsim
- **Usage:** Reference model for verification environments

## Repository Structure
├───Behavioral_FIFO
│   ├───constraints
│   ├───results/# project and generated reports
│   ├───rtl
│   ├───scripts/#instructions to build, synthesize, elaborate and generate timming reports
    └───tb

## Skills Demonstrated
- Behavioral FIFO modeling in SystemVerilog
- SystemVerilog OOP and interfaces
- Blocking vs. non-blocking assignment concepts
- Automatic / self-checking testbench
- Preprocessor-based configurability for UVM reuse


#Learnings and Notes
After describing a behavioral model of a FIFO in pure SystemVerilog, I refreshed my knowledge of SystemVerilog OOP, interfaces, and blocking vs. non-blocking assignments.
This model uses preprocessor directives to support reuse of the class in UVM environments.
