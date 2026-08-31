`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2026 11:54:44 AM
// Design Name: 
// Module Name: 4bit_substract
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


module FourBit_substract(
    input  [3:0] push_add,
    input  [3:0]  pop_add,
    output wire [3:0] diff_add
    );
    
    wire [4:0] diff_add_pre;
    
    assign diff_add_pre = (push_add - pop_add);
    
    assign diff_add = (diff_add_pre[4])? ~diff_add_pre+1'b1: diff_add_pre;
    
    
endmodule
