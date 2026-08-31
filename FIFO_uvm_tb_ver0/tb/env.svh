`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2026 03:15:34 PM
// Design Name: 
// Module Name: FIFO_queue_tb
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

class env extends uvm_env;
	`uvm_component_utils(env); // adding env to uvm factory
	

	//instantiate enviroment components 
	base_tester  base_tester_obj;
	FIFO_queue_scoreboard scoreboard_obj;
	FIFO_queue_coverage   coverage_obj;
	

	// env constructor 
	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction : new

	// implement build_phase()
	function void build_phase(uvm_phase phase);
		base_tester_obj  = base_tester::type_id::create("base_tester_obj",this);
		scoreboard_obj   = FIFO_queue_scoreboard::type_id::create("scoreboard_obj",this);
		coverage_obj     = FIFO_queue_coverage::type_id::create("coverage_obj",this);
	endfunction : build_phase
	

endclass : env