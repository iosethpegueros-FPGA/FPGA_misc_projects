`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/06/2026 11:54:57 AM
// Design Name: 
// Module Name: CDC_top
// Project Name: 
// Target Devices:
//      ZYNQ XC7Z020-1CLG400C  (Programmable logic equivalent to Artix-7 FPGA)
//      FPGA devices selected for this project in vivado: xc7z020clg400-1 
// Tool Versions: 
// Description: 
// 		cross domain crossing execercise for timing concepts learning/reviewing
//		this module contains a custom FIFO implementation ( with attempts to avoid delays and erros for cornercases in full and empty flags )
//		two domains: A slow clock  and B fast clocks are considered.
//		a Test bench covers these scenarios 
//      gray counters are implemented for address pointer crossing domains 
// Dependencies: 
//		every module is impmenented in this file. there are no dependencies 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


/** Module: CDC_top
*this module instantiates an Asynchronous FIFO, driven by two command buses in domain A and B
**/
module CDC_top#(
        /** Parameters: 
        *DATA_WIDTH - sets memory data width, 16 by default
        *FIFO_DEPTH - sets memory data width, 16 by default 
        **/
        parameter DATA_WIDTH=16,
        parameter FIFO_DEPTH = 16
    )(
        /**Group:
        // domain A data generator
        * command_buss_a: contains control signals and data 
        * rddata_dom_a: stores data read on doman A. Not used in this example 
        **/ 
        input clka_in,
        input wire rsta_n,
        input  [31:0] command_bus_a,
        output [15:0] rddata_dom_a,
        // domain B data consumer 
        input clkb_in,
        input wire rstb_n,
        input [31:0] command_bus_b,
        output wire [15:0] rddata_dom_b,
        output wire full,
		output wire  almost_full,
        output wire empty,
		output wire  almost_empty, 
        // add functional ports above this dummy conecction 
        output [31:0] dummy_out
    
    );

    // break command bus into control signals 
    logic valid_a, write_a, read_a;
    logic [15:0]wrdata_dom_a;

    logic valid_b, write_b, read_b;
    logic [15:0]wrdata_dom_b;

    //  writing data  domainA
    assign valid_a      = command_bus_a[31];
    assign write_a      = command_bus_a[28];
    assign  read_a      = command_bus_a[29]; // not used in this example, as domnain A has no consumer interface 
    assign wrdata_dom_a = command_bus_a[15:0];        
  
    //  reading data  domainB
    assign valid_b      = command_bus_b[31];
    assign write_b      = command_bus_b[28];// not used in this example, as domnain B has no producer interface 
    assign  read_b      = command_bus_b[29]; 


    //Instance: u_async_fifo
    // instantiating async_fifo_WIDTHxDEPTH
    // 
    async_fifo_WIDTHxDEPTH #(
        .DATA_WIDTH  (DATA_WIDTH),
        .DEPTH (FIFO_DEPTH)
    ) u_async_fifo (
        .rst_n              (rsta_n),
        .write_clk          (clka_in),
        .write_en           (write_a),
        .write_data         (wrdata_dom_a),
        .write_full         (full),
        .almost_full        (almost_full),
        .read_clk           (clkb_in),
        .read_en            (read_b),
        .read_data          (rddata_dom_b),
        .read_empty         (empty),
        .almost_empty       (almost_empty),
        .dummy_out          ()
    );
    
    // assigning useless data to dummy buss. for synthesis tricks and experiments only 
    assign dummy_out = rddata_dom_b | wrdata_dom_a;


endmodule

/** Module: dual_port_mem_WIDTHxDEPTH
*   system verilog description of a dual port RAM , should be inferred as an FPGA primitive
**/
module dual_port_mem_WIDTHxDEPTH #(
        DATA_WIDTH  = 32,
        DEPTH       = 32
//        localparam DEPTH_WIDTH =$clog2(DEPTH)
    )(
    //global
    input rst_n,
    //write interface
    input write_clk,
    input [DEPTH_WIDTH-1:0] write_address,
    input write_en,
    input [DATA_WIDTH-1:0] write_data,

     
    //read interface
    input read_clk,
    input [DEPTH_WIDTH-1:0] read_address,
    input read_en,
    output reg [DATA_WIDTH-1:0] read_data,


    output [31:0]dummy_out
    );

  localparam DEPTH_WIDTH =$clog2(DEPTH);
  localparam MEMORY_DEPTH = DEPTH;  //  
  
  logic [DATA_WIDTH-1:0] memory_array [0:MEMORY_DEPTH-1];
  logic [DATA_WIDTH-1:0] read_data_wire;

// write port 
always@(posedge write_clk)begin    
    if(write_en) begin
        memory_array[write_address]<=write_data;
    end
end

// read port 
assign read_data_wire = memory_array[read_address];
 
always@(posedge read_clk)begin
    if(read_en) begin
        read_data<=read_data_wire;
    end
end

  
endmodule


/** Module: async_fifo_WIDTHxDEPTH
*   Actual FIFO. Implementation of control logic for domain A and domain B, handling full and empty flags.
**/
module async_fifo_WIDTHxDEPTH#(
        DATA_WIDTH  = 32,
        DEPTH = 16
    )(
    //global
    input rst_n,
    //write interface
    input write_clk,
    input write_en,
    input [DATA_WIDTH-1:0] write_data,
    output write_full,
    output almost_full,
     
    //read interface
    input read_clk,
    input read_en,
    output [DATA_WIDTH-1:0] read_data,
    output read_empty,
    output almost_empty,

    output [31:0]dummy_out
    );
    

    localparam DEPTH_WIDTH =$clog2(DEPTH); // get bit width to be able to index DEPTH
    
    logic push_clk, pop_clk;
    // Push (write interface) 
    logic                   push;           // push enable
    logic [DEPTH_WIDTH-1:0] push_addr_gray;      // push address, gray code address. all addresses crosing domain are coded gray 
    logic [DATA_WIDTH-1:0]  push_data;
    // Pop (read interface) - 
    logic                      pop;            // pop enable
    logic [DEPTH_WIDTH-1:0]    pop_addr_gray;       // pop address, gray code address. all addresses crosing domain are coded gray  
    logic [DATA_WIDTH-1:0]     pop_data;
	
    logic [DEPTH_WIDTH-1:0]  synched_pop_addr [0:2]; //all addresses crosing domain are coded gray  
    logic [DEPTH_WIDTH-1:0]  synched_push_addr[0:2]; //all addresses crosing domain are coded gray  
	
    // status flags 
    logic                    full, empty, full_r, empty_r;
	logic					 almost_empty_reg,almost_full_reg;
    logic                    wrap_wr , wrap_rd , wrap_wraddr_r, wrap_rdaddr_r;
    logic                    [2:0]synched_wrap_wr; 
    logic                    [2:0]synched_wrap_rd;
	logic clear_write_wrap;
    logic clear_read_wrap; 

    // address pointers gray and binary 
    logic [DEPTH_WIDTH-1:0]  push_addr_bin; //memory is indexed using binary address 
    logic [DEPTH_WIDTH-1:0]  pop_addr_bin;  //memory is indexed using binary address 
    logic [DEPTH_WIDTH-1:0]  push_addr_gray;  // address in gray code for domain crossing 
    logic [DEPTH_WIDTH-1:0]  pop_addr_gray;   // address in gray code for domain crossing   	
    logic [DEPTH_WIDTH-1:0]  push_addr_bin_increment1; 
    logic [DEPTH_WIDTH-1:0]  pop_addr_bin_increment1;	

    logic pop_equals_push_domainA;
    logic pop_equals_push_domainB;
    logic [2:0]synched_clear_write_wrap;
    
    assign push_clk = write_clk;
    assign pop_clk  = read_clk; 

	// incrementing binary address pointers 
	assign push_addr_bin_increment1 = push_addr_bin + 1'b1;
	assign pop_addr_bin_increment1  = pop_addr_bin  + 1'b1;	
 
 
 
 //procedure: domain A write logic
 //write pointer logic.  aka push_address in domainA ( write )
    always@(posedge write_clk or negedge rst_n)begin
        if(!rst_n)begin
            full_r               <= 'h0;
            push_addr_bin        <= 'h0;
            push_addr_gray       <= 'h0;
            wrap_wr              <= 'h0;
			synched_pop_addr[0]  <= 'h0; 
			synched_pop_addr[1]  <= 'h0; 
			synched_pop_addr[2]  <= 'h0; 
            synched_wrap_rd      <= 'h0;
			almost_full_reg      <= 'h0;
        end else begin
            if(push) begin
                push_addr_gray   <= push_addr_bin_increment1 ^ ((push_addr_bin_increment1) >> 1);  // convert incremented binary addres to gray code.       
                push_addr_bin    <= push_addr_bin_increment1 ;                                     // increment push/write address  by 1                       
            end
            {synched_pop_addr[2],synched_pop_addr[1],synched_pop_addr[0]} <= {synched_pop_addr[1],synched_pop_addr[0],pop_addr_gray};  //synchronizing pop/read adress from domain B to domain A.
            synched_wrap_rd      <= {synched_wrap_rd[1:0],wrap_rd};  																   //synchronizing wrap_rd flag from domain A to domain B
            wrap_wr              <= ((push_addr_bin == 'hf )& push & !clear_write_wrap)? 1'b1 :(clear_write_wrap)? 1'b0 : wrap_wr;  // wrap_wr sets when write pointer is pointing to the last memory location and a push/write request happens, it clears until pop/read pointer wraps too
			almost_full_reg      <= almost_full;
        end   
    end

 //procedure: domain B read logic    
 //read pointer logic.  aka pop_address  in domainB ( read )
    always@(posedge read_clk or negedge rst_n)begin
        if(!rst_n)begin
            empty_r                  <= 'h0;
            pop_addr_bin             <= 'h0; 
            pop_addr_gray                 <= 'h0;
            wrap_rd                  <= 'h0;  
            synched_push_addr[0]     <= 'h0;
            synched_push_addr[1]     <= 'h0;      
            synched_push_addr[2]     <= 'h0;      				
            synched_wrap_wr          <= 'h0;
            synched_clear_write_wrap <= 'h0;  
			almost_empty_reg         <= 'h0; 			
        end else begin
            if(pop)begin
                pop_addr_gray        <=  pop_addr_bin_increment1  ^ (( pop_addr_bin_increment1) >> 1); // convert incremented binary addres to gray code.
                pop_addr_bin         <=  pop_addr_bin_increment1;                             		   // increment pop/read address by 1
            end 
            {synched_push_addr[2],synched_push_addr[1],synched_push_addr[0]}         <= {synched_push_addr[1],synched_push_addr[0],push_addr_gray};  //synchronizing push/write adress from domain A to domain B.       
            wrap_rd                  <= ((pop_addr_bin == 'hf) & pop & !synched_clear_write_wrap)? 1'b1 :(synched_clear_write_wrap)? 1'b0 :wrap_rd ;  // generate wrap read flag when address is at the last memory location TODO: fix/eliminate magic numbers, use FIFO_DEPTH parameter 
            synched_wrap_wr          <= {synched_wrap_wr[1:0],wrap_wr}; 																			//synchronizing wrap_wr flag from domain B to domain A
            synched_clear_write_wrap <= {synched_clear_write_wrap[1:0],clear_write_wrap};															//synchronizing clear signals 
			almost_empty_reg         <= almost_empty;
        end                    
    end


    // procedure: control and status flag generation
	// checking pointers are equal from each domain perspective 
    assign pop_equals_push_domainA =  !( synched_pop_addr[2]  ^ push_addr_gray);
    assign pop_equals_push_domainB =  !(synched_push_addr[2]  ^ pop_addr_gray);    
    

    assign clear_write_wrap    =  synched_wrap_rd[2];   // read pointer catched, now write_pointer should be ahead of read_pointer
//  read wrap is just a pulse to clear write wrap. which means write is no longer behind read pointer.   


    assign push = write_en  & !full;    //  data will be pushed as long as memory is not full
    assign pop  = read_en   & !empty;   //  data will be popped as long as memory is not empty 
    
    assign full  = (pop_equals_push_domainA  &   almost_full_reg    )? 1'b1 : 1'b0;  // pointers are equal after write_ptr reaches read ptr. if the flag almost_empty is set then it means fifo was emptied after the wrapping of write
    assign empty = (pop_equals_push_domainB  &   !synched_wrap_wr[2])? 1'b1 : 1'b0;  // fifo is empty after read pointer reaches write. it'll 'waste' 3 clock cycles waiting for wrap_wr from domainA to ensure it's not a full. almost_empty flag should indicate the read interface to stop reading data.

    assign read_data  = pop_data  ;
    assign push_data  = write_data;
    
    assign write_full = full;
    assign read_empty = empty;
	
	logic [DEPTH_WIDTH-1:0] synched_push_addr_bin;
    logic [DEPTH_WIDTH-1:0] synched_pop_addr_bin;
	logic [DEPTH_WIDTH-1:0] synched_push_addr_gray2bin;
    logic [DEPTH_WIDTH-1:0] synched_pop_addr_gray2bin;
	logic [DEPTH_WIDTH-1:0] pop_minus_push;        // address difference  to calculate almost_empty
	logic [DEPTH_WIDTH-1:0] push_minus_pop;        // address difference to calculate almost_full
	logic [DEPTH_WIDTH:0] pop_minus_push_signed;    // holds 2's complement substraction result with 1 extra bit in length to hold the - sign
	logic [DEPTH_WIDTH:0] push_minus_pop_signed;   // holds 2's complement substraction result with 1 extra bit in length to hold the - sign
	logic pop_minus_push_sign,push_minus_pop_sign;
		
	logic [DEPTH_WIDTH:0] push_minus_pop_abs; //holds absolute result value of substraction.
	logic [DEPTH_WIDTH:0] pop_minus_push_abs; //holds absolute result value of substraction.

	// procedure: almost empty/full flag generation combo logic 
	// convert synched addreses from gray code back to binary for status flag calculation.
	assign synched_push_addr_gray2bin[DEPTH_WIDTH-1] =  {synched_push_addr[2][DEPTH_WIDTH-1]};
	assign synched_push_addr_gray2bin[DEPTH_WIDTH-2] =  {synched_push_addr_gray2bin[DEPTH_WIDTH-1]  ^ synched_push_addr[2][DEPTH_WIDTH-2]}; 
	assign synched_push_addr_gray2bin[DEPTH_WIDTH-3] =  {synched_push_addr_gray2bin[DEPTH_WIDTH-2]  ^ synched_push_addr[2][DEPTH_WIDTH-3]};
	assign synched_push_addr_gray2bin[DEPTH_WIDTH-4] =  {synched_push_addr_gray2bin[DEPTH_WIDTH-3]  ^ synched_push_addr[2][DEPTH_WIDTH-4]};
	assign synched_push_addr_bin = synched_push_addr_gray2bin;
	
	assign synched_pop_addr_gray2bin[DEPTH_WIDTH-1] =  {synched_pop_addr[2][DEPTH_WIDTH-1]};
	assign synched_pop_addr_gray2bin[DEPTH_WIDTH-2] =  {synched_pop_addr_gray2bin[DEPTH_WIDTH-1]  ^ synched_pop_addr[2][DEPTH_WIDTH-2]}; 
	assign synched_pop_addr_gray2bin[DEPTH_WIDTH-3] =  {synched_pop_addr_gray2bin[DEPTH_WIDTH-2]  ^ synched_pop_addr[2][DEPTH_WIDTH-3]};
	assign synched_pop_addr_gray2bin[DEPTH_WIDTH-4] =  {synched_pop_addr_gray2bin[DEPTH_WIDTH-3]  ^ synched_pop_addr[2][DEPTH_WIDTH-4]};
	assign synched_pop_addr_bin = synched_pop_addr_gray2bin;

	// address pointer difference from each domain perspective
	// domain A
	assign push_minus_pop_signed= (push_addr_bin         - 	synched_pop_addr_bin );	
	// domain B 
	assign pop_minus_push_signed= (pop_addr_bin          - 	synched_push_addr_bin);

	// convert substaction negative results to absolute value.
	assign pop_minus_push_abs  = ~pop_minus_push_signed+1'b1;
	assign push_minus_pop_abs  = ~push_minus_pop_signed+1'b1;

	// get the sign of substraction 
	assign pop_minus_push_sign = pop_minus_push_signed[DEPTH_WIDTH];
	assign push_minus_pop_sign = push_minus_pop_signed[DEPTH_WIDTH];

	// get absolute value only to calculate almost_empty/full flags
	assign pop_minus_push = (pop_minus_push_sign)? pop_minus_push_abs[DEPTH_WIDTH-1:0]  :pop_minus_push_signed[DEPTH_WIDTH-1:0]; 
	assign push_minus_pop = (push_minus_pop_sign)? push_minus_pop_abs[DEPTH_WIDTH-1:0]  :push_minus_pop_signed[DEPTH_WIDTH-1:0];


	// the operation for these flags is done with synchronized addresses
	// taking address difference. flags are set when we are within 4 locations from each other. 
	// TODO: fix magic numbers, use function to calculate expected differences based on FIFO_DEPTH
	assign almost_empty = (   ((pop_minus_push < 'h4) && (pop_minus_push_sign) && (!synched_wrap_wr[2] | wrap_rd) )  // whent wrap_wr is low, difference should be positive sign. wrap_rd set means synched_wrap_wr will go low after 3 cycles. using it to prevent losing the flag while wrap_wr is crossing domains. 
						   || ((pop_minus_push >= 'hc) && (!pop_minus_push_sign) && (synched_wrap_wr[2]) ))? 1'b1 :1'b0;
	
	
	assign almost_full  = (   ((push_minus_pop >= 'hc) && (!push_minus_pop_sign) &&  (!wrap_wr)  )
						   || ((push_minus_pop < 'h4) && (push_minus_pop_sign ) &&  (wrap_wr )  ))? 1'b1 :1'b0; 
						   
    //procedure:  u_fifo_mem
    // instantiating dual port memory 
    dual_port_mem_WIDTHxDEPTH #(
        .DATA_WIDTH  (DATA_WIDTH),
        .DEPTH (DEPTH)
    ) u_fifo_mem (
        .rst_n         (rst_n),
        .write_clk     (push_clk),
        .write_address (push_addr_bin),
        .write_en      (push),
        .write_data    (push_data),
        .read_clk      (pop_clk),
        .read_address  (pop_addr_bin),
        .read_en       (pop),
        .read_data     (pop_data),
        .dummy_out     ()
    );
  
endmodule


