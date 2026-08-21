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

module tb_CDC_FIFO_top(
    input a,
    output b
);
 
   
   
   FIFO_queue_bfm bfm_rtl(); // instantiating interface to conect DUT
   FIFO_queue_tester tester_obj_rtl; // instatianting the tester object 
   
   
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
    .full(bfm_rtl.full),
    .empty(bfm_rtl.empty),
    .almost_full(bfm_rtl.almost_full),
    .almost_empty(bfm_rtl.almost_empty),
    // outputs
    .dummy_out      (dummy_out)
);




int seed_read,seed_write,i;
initial begin
    seed_read  =1;
    seed_write =3;

    
    tester_obj_rtl = new(bfm_rtl,seed_read,seed_write);
    bfm_rtl.reset_fifo();
    
    
    fork
        tester_obj_rtl.execute();
    join 
    @(posedge bfm_rtl.clk_a);
    $display("teset done ----------------------");
    $finish();
end




endmodule
