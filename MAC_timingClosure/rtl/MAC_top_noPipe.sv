`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/01/2026 11:01:54 AM
// Design Name: 
// Module Name: MAC_top
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

(* use_dsp = "no" *) // Vivado attribute: prevents the use of  DSP48 blocks
module MAC_top_noPipe(
    input clock,
    input reset,
    input opA,
    input opB,
    input clear_ops,
    input shiftIn_en,
//    input shiftOut_en,
    input valid_i, // start MAC operation 
    output [64:0]result
    );
    
    logic [63:0] mult_result;
    logic [31:0] operandA, operandB;
    logic [64:0] accumulator_r; 
    
    /// operand A shift register to 32 bit bus
    always@(posedge clock or negedge reset)begin
        if(!reset)begin
            operandA <= 'h0;
        end else if (clear_ops) begin 
            operandA <= 'h0;
        end else if (shiftIn_en  &  valid_i) begin
            operandA <= {operandA[30:0],opA};
        end
    end
     /// operand B shift register to 32 bit bus
    always@(posedge clock or negedge reset)begin
        if(!reset)begin
            operandB <= 'h0;
        end else if (clear_ops) begin 
            operandB <= 'h0;
        end else if (shiftIn_en  & valid_i) begin
            operandB <= {operandB[30:0],opB};
        end
    end
 
 (* multstyle = "logic" *)
 assign mult_result=operandA * operandB;
 
 logic [64:0] ripple_sum;
 carry_ripple_adder add_i(
    .A(mult_result),
    .B(accumulator_r[63:0]),
    .SUM(ripple_sum[63:0]),
    .carry_out(ripple_sum[64])
    );
    
    always@(posedge clock or negedge reset)begin
        if(!reset)begin
            accumulator_r <='h0;
        end else if (valid_i) begin
            //accumulator_r <=  mult_resul + accumulator_r; // xilinx implementation
            accumulator_r <= ripple_sum;
        end
    end
    

    assign result = accumulator_r; 
    

    
endmodule



module carry_ripple_adder (
    input [63:0] A,
    input [63:0] B,
    output [64:0] SUM,
    output  carry_out
);


logic [64:0] carry_prop;
logic carry_in = 1'b0;


assign carry_prop      = (({1'b0,A} & {1'b0,B}) | ({carry_prop[31:0],carry_in} & ({1'b0,A} ^ {1'b0,B})));
assign {carry_out,SUM} = A ^ B ^ carry_prop;
   
   
endmodule


