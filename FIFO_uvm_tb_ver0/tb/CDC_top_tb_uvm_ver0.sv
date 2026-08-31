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






module CDC_top_tb_uvm_ver0;
 
 // FIFO packages and macros here:
	import FIFO_queue_pkg::*;
//`include "FIFO_queue_macros.svh"	
// import UVM packages and macros 
      import uvm_pkg::*;
`include "uvm_macros.svh"
   
   FIFO_queue_bfm bfm_rtl(); // instantiating interface to conect DUT

   CDC_top u_DUT_CDC_top (
    // domain A data generator
    .clka_in        (bfm_rtl.clk_a),
    .rsta_n         (bfm_rtl.rstn_a),
    .command_bus_a  ({bfm_rtl.push,12'h0,bfm_rtl.datain_a}),
    // domain B data consumer
    .clkb_in        (bfm_rtl.clk_b),
    .rstb_n         (bfm_rtl.rstn_b),
    .command_bus_b  ({bfm_rtl.pop,29'h0}),
    .rddata_dom_b   (bfm_rtl.dataout_b),
    .full           (bfm_rtl.full),
    .empty          (bfm_rtl.empty),
    .almost_full    (bfm_rtl.almost_full),
    .almost_empty   (bfm_rtl.almost_empty),
    // outputs
    .dummy_out      (dummy_out)
);


// connect interface to testbench
// execute testbench
initial begin
   uvm_config_db #(virtual FIFO_queue_bfm)::set(null, "*", "bfm", bfm_rtl);
   run_test();
end



endmodule
