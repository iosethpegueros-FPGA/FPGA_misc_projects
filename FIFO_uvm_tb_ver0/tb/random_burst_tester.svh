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

class random_burst_tester extends base_tester;
	`uvm_component_utils(random_burst_tester); // adding test to uvm factory
	

	virtual interface FIFO_queue_bfm bfm;

	// random_burst_tester constructor 
	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction : new

// implement build_phase()
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(virtual FIFO_queue_bfm)::get(null,"*","bfm",bfm) )
			$fatal("failed to initialize bfm");
	endfunction : build_phase
	
	
	task write_read_N;
		input int N_samples_local;
		input  data_array_t write_data_array;
		output data_array_t read_data_array;
	begin

	$display(" stub function in this random_burst_tester");
	end
	endtask


// implement run_phase()
	task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	$display("random_burst_tester start");
	
	$display("random_burst_tester complete");
	phase.drop_objection(this);
	endtask


endclass : random_burst_tester
