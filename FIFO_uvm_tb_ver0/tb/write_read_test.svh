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

class write_read_test extends uvm_test;
	`uvm_component_utils(write_read_test); // adding test to uvm factory
	
	env env_obj;

	// reset_health_test constructor 
	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction : new
	
	
	function void build_phase(uvm_phase phase);
		base_tester::type_id::set_type_override(write_read_tester::get_type());
		env_obj = env::type_id::create("env_obj",this);
	endfunction


endclass : write_read_test