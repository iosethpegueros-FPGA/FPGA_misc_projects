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

class reset_health_tester extends base_tester;
	`uvm_component_utils(reset_health_tester); // adding test to uvm factory
	

	virtual interface FIFO_queue_bfm bfm;

	// reset_health_tester constructor 
	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction : new

// implement build_phase()
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(virtual FIFO_queue_bfm)::get(null,"*","bfm",bfm) )
			$fatal("failed to initialize bfm");
	endfunction : build_phase
	
	// define class atributtes here: 
	localparam write_read_test_Nsamples = 16;
	int unsigned N_samples;	
	
	task write_read_N;
		input int N_samples_local;
		input  data_array_t write_data_array;
		output data_array_t read_data_array;
		int  read_count;
		logic success_read,success_write;
		begin
			read_data_array= new[N_samples_local];			
			read_count  = 0;
			success_read =0;
				repeat(N_samples_local)begin
					bfm.pop_data_single(read_data_array[read_count],success_read);
					read_count = read_count+1;
				end
		end
	endtask


	function data_array_t zeroed_array_gen ();
		data_array_t random_data_array;
		random_data_array = new[N_samples];
		for(int i=0;i<=N_samples-1;i++)begin
			random_data_array[i] = 'h0;
		end
		return random_data_array;
	endfunction :zeroed_array_gen
	

// implement run_phase()
	task run_phase(uvm_phase phase);
	
		data_array_t write_data_array;
		data_array_t read_data_array;

		N_samples = write_read_test_Nsamples;   //FIFO size write read operations for write_read_test 
		// read_data_array =new[N_samples];
		write_data_array=new[N_samples];
		write_data_array = zeroed_array_gen();	

	phase.raise_objection(this);
	$display("reset_health_tester start");
	
	repeat(5)begin 
		bfm.reset_fifo();
		$display("FIFO was reset at %t",$realtime);
		write_read_N(N_samples,write_data_array,read_data_array);
			for(int i=0; i<=N_samples; i++)begin
				if(read_data_array[i] != 'h0) $display("FIFO shows data after reset");
			end
	end
	$display("reset_health_tester complete");
	phase.drop_objection(this);
	
	endtask

endclass : reset_health_tester