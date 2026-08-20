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



`include "FIFO_queue_class.svh"
`include "FIFO_queue_tester.svh"

module FIFO_queue_tb(
    input a,
    output b
);
 

// parameter DATA_WIDTH =16;
// parameter FIFO_DEPTH = 16;
// parameter STIMULUS_DEPTH = 1024;
   
   FIFO_queue_class queue_obj ;
   FIFO_queue_bfm bfm();
   FIFO_queue_tester tester_obj;
   
  logic clk_sim;
 localparam   CLKA_PERIOD   = 5;//10ns;
 // sim clock generation
initial clk_sim = 0;
always #(CLKA_PERIOD/2) clk_sim = ~clk_sim;
   

initial begin 
    @(posedge clk_sim);
    fork
           queue_obj.execute();
    join 
end


int seed_read,seed_write,i;
initial begin
    seed_read  =1;
    seed_write =3;
    queue_obj = new(bfm);
    tester_obj = new(bfm,seed_read,seed_write);
    bfm.reset_fifo();
    fork
        tester_obj.execute();
    join 
    @(posedge clk_sim);
    $display("teset done ----------------------");
    $finish();
end


initial begin 
    repeat(20)@(posedge clk_sim);
end 


endmodule
