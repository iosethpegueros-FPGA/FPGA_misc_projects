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

class FIFO_queue_scoreboard;

 virtual FIFO_queue_bfm bfm;
 
 localparam DATA_WIDTH = 16; //FIFO_queue_bfm::DATA_WIDTH;
 localparam FIFO_DEPTH = 16; //FIFO_queue_bfm::FIFO_DEPTH;
 

 
 function new(virtual FIFO_queue_bfm bfm_constructor);
    bfm=bfm_constructor;
 endfunction: new

task execute;
	#1 $display("this task executes el coverage y asi ");
	$display(" NO HAS IMPLEMENTADO EL COVERAGEEEEE !!!! : ) ");
endtask




endclass