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






virtual class base_tester extends uvm_component;
	`uvm_component_utils(base_tester); // adding test to uvm factory


	virtual interface FIFO_queue_bfm bfm;

	// base_tester constructor 
	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction : new

// implement build_phase()
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(virtual FIFO_queue_bfm)::get(null,"*","bfm",bfm) )
			$fatal("failed to initialize bfm");
	endfunction : build_phase
	
	
// define virtal clases to be overwritten by base_tester childredn
	typedef logic [DATA_WIDTH-1:0] data_array_t [];

	pure virtual task write_read_N(
		input int N_samples_local,
		input  data_array_t write_data_array,
		output data_array_t read_data_array
		);
	
	

// implement run_phase()
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		bfm.reset_fifo(); 
		$display("resetting FIFO at base_test");
		$display("base_test start");
		
		
		$display("base_test complete");
		phase.drop_objection(this);
	endtask


endclass : base_tester
