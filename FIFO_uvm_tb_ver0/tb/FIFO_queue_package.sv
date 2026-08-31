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
package FIFO_queue_pkg;

`include "uvm_macros.svh"
	import uvm_pkg::*;
	
`include "base_tester.svh"
`include "FIFO_queue_coverage.svh"
`include "FIFO_queue_scoreboard.svh"
`include "env.svh"

`include "address_boundaries_tester.svh"	
`include "random_burst_tester.svh"	
`include "reset_health_tester.svh"	
`include "write_read_tester.svh"

`include "address_boundaries_test.svh"	
`include "random_burst_test.svh"	
`include "reset_health_test.svh"	
`include "write_read_test.svh"	

 parameter DATA_WIDTH = 16; //FIFO_queue_bfm::DATA_WIDTH;
 parameter FIFO_DEPTH = 16; //FIFO_queue_bfm::FIFO_DEPTH;
 parameter STIMULUS_DEPTH = 65535;
 
endpackage