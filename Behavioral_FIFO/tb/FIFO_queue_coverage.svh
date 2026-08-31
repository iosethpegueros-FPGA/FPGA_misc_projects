`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2026 03:13:10 PM
// Design Name: 
// Module Name: FIFO_queue_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`define VERBOSE_PRINT_ENABLED 1
`define IF_DEBUG_PRINT_ENABLED if(`VERBOSE_PRINT_ENABLED)   

class FIFO_queue_coverage extends uvm_component;
	`uvm_component_utils(FIFO_queue_coverage)
 
 
	virtual FIFO_queue_bfm bfm;
 
   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new

   function void build_phase(uvm_phase phase);
      if(!uvm_config_db #(virtual FIFO_queue_bfm)::get(null, "*","bfm", bfm))
        $fatal("failed to initialize bfm");
   endfunction : build_phase
 


task run_phase(uvm_phase phase);
	$display("this task executes coverage    ");
	$display("COVERAGE IS NOT INPMEMENTED YET");
	$display("this is just a coverage stub   ");
endtask




endclass