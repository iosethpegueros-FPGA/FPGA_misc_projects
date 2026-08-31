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

//






class base_test extends uvm_component
	`uvm_component_utils(base_test); // adding test to uvm factory
	

	virtual interface FIFO_queue_bfm bfm;

	// base_test constructor 
	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction : new

// implement build_phase()
	function void build_phase(uvm_phase phase)begin
		if(!uvm_config_db #(virtual FIFO_queue_bfm::get(null,"*","bfm",bfm) )
			$fatal("failed to initialize bfm");
	end : build_phase
// define virtal clases to be overwritten by base_test childredn


// implement run_phase()
	task run_phase() begin
	
	phase.raise_objection(this);
    bfm.reset_fifo(); 
	$display("resetting FIFO at base_test");
	$display("base_test start");
	
	
	$display("base_test complete");
	phase.drop_objection(this);
	
	endtask


endclass : base_test
