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


class FIFO_queue_tester;

`ifdef TESTER_DEBUG_ENABLED
    `define VERBOSE_PRINT_ENABLED 1
 `endif
`define IF_DEBUG_PRINT_ENABLED if(`VERBOSE_PRINT_ENABLED)   

    import FIFO_queue_pkg::*;
    virtual FIFO_queue_bfm bfm;
 
// localparam DATA_WIDTH = 16; //FIFO_queue_bfm::DATA_WIDTH;
// localparam FIFO_DEPTH = 16; //FIFO_queue_bfm::FIFO_DEPTH;
// localparam STIMULUS_DEPTH = 1024;
 
 int seed_read,seed_write,i;
 logic push_data_burst_enabled, pop_data_burst_enabled;
 
 
 function new(virtual FIFO_queue_bfm bfm_constructor,int seed_read_constructor, int seed_write_constructor);
    bfm=bfm_constructor;
	seed_read  = seed_read_constructor;
	seed_write = seed_write_constructor;
	$readmemh("fifo_data_hex.txt",stimulus_array);
 endfunction: new

logic [DATA_WIDTH-1:0] stimulus_array [0:STIMULUS_DEPTH-1];
logic [DATA_WIDTH-1:0] fifo_dump_data [0:STIMULUS_DEPTH-1];



// performs random number of continuous writes to the FIFO alternating idle cycles 
// until we reach the count of elements of the end of a stimulus file
// this mimics clk_a domain write operations
task push_data_multi;  
    input [DATA_WIDTH-1:0] data_array [0:STIMULUS_DEPTH-1];
    input int seed;
    logic [DATA_WIDTH-1:0] data_array_temp;
    bit [3:0] data_burst_size;
    bit [3:0] data_burst_idle;
    int burst_count;
    bit success_write;
    begin
        @(posedge bfm.clk_a);
        data_burst_size = $random(seed); 
        data_burst_idle = $random(seed); 
        burst_count=0;
        push_data_burst_enabled=1; // blocking assignments to ensure data assigned at the same time as data_burst_size/idle 
            while(push_data_burst_enabled)begin 
                    data_burst_size = $random(seed);
                    repeat(data_burst_size)begin 
                        if(!bfm.full)  begin
                            bfm.push_data_single(data_array[burst_count],success_write);
                            `IF_DEBUG_PRINT_ENABLED $display("data_array_temp: %h data_array[burst_count] %h , %d",data_array_temp, data_array[burst_count], burst_count);
                            burst_count=burst_count+1;
                            if(burst_count >= (STIMULUS_DEPTH))begin
                                push_data_burst_enabled = 0;
                                break;
                            end
                        end
                    end
                    data_burst_idle = $random(seed);
                    repeat(data_burst_idle)@(posedge bfm.clk_a);
            end     
    end
endtask


task pop_data_multi(ref logic [DATA_WIDTH-1:0] data_array_pop [0:STIMULUS_DEPTH-1], input int seed);
    bit [3:0] data_burst_size;
    bit [3:0] data_burst_idle;
    int burst_count;
    logic [DATA_WIDTH-1:0] data_array_temp;
    bit success_read;
    begin
        @(posedge bfm.clk_b);
        data_burst_size = $random(seed);
        data_burst_idle = $random(seed);
        burst_count     = 0;
        pop_data_burst_enabled   = 1;
            while(pop_data_burst_enabled)begin
                    data_burst_size = $random(seed);
                    @(posedge bfm.clk_b);
                    repeat(data_burst_size)begin 
                        if(!bfm.empty)  begin
                            bfm.pop_data_single(data_array_temp,success_read);
                            data_array_pop[burst_count]=data_array_temp;
                            `IF_DEBUG_PRINT_ENABLED $display("data_array_pop[burst_count] %h , %d",data_array_pop[burst_count],burst_count);
                            burst_count=burst_count+1;
                            if(burst_count >= (STIMULUS_DEPTH))begin
                                pop_data_burst_enabled = 0;
                                break;
                            end
                        end
                    end 
                    data_burst_idle = $random(seed);
                    repeat(data_burst_idle)@(posedge bfm.clk_a);
            end
            @(posedge bfm.clk_a);     
    end    
endtask
 
 
task execute(); 
    fork
//            push_data_multi(stimulus_array,seed_read);
//            pop_data_multi(fifo_dump_data,seed_write);
            push_data_multi_2(stimulus_array,seed_read);
            pop_data_multi_2(fifo_dump_data,seed_write);
            evaluate();
    join
endtask


task evaluate;
    logic evaluation_done;
    evaluation_done = 0;
    repeat(5)@(posedge bfm.clk_a);
    while(!evaluation_done)begin
		@(posedge bfm.clk_a);
        if(!pop_data_burst_enabled & !push_data_burst_enabled)begin 
            if (stimulus_array == fifo_dump_data)begin
                evaluation_done = 1; 
				$display("----------------------------------------------------------");
                $display("test PASS");
				$display("----------------------------------------------------------");
                break;
            end else begin 
                for (i =0 ; i<STIMULUS_DEPTH; i++)begin
                    if (stimulus_array[i] != fifo_dump_data[i]) $display("missmatch at index %0d. %h != %h ",i,stimulus_array[i],fifo_dump_data[i]);
                end
				$display("----------------------------------------------------------");
				$display("test FAIL");
				$display("----------------------------------------------------------");
                evaluation_done = 1;
            end
        end
    end
    $display("evaluation done");
endtask



task push_data_multi_2; // double full flag check  
    input [DATA_WIDTH-1:0] data_array [0:STIMULUS_DEPTH-1];
    input int seed;
    logic [DATA_WIDTH-1:0] data_array_temp;
    bit [3:0] data_burst_size;
    bit [3:0] data_burst_idle;
    int burst_count;
    bit success_write;
    begin
        @(posedge bfm.clk_a);
        data_burst_size = $random(seed); 
        data_burst_idle = $random(seed); 
        burst_count=0;
        push_data_burst_enabled=1; // blocking assignments to ensure data assigned at the same time as data_burst_size/idle 
            while(push_data_burst_enabled)begin 
                    data_burst_size = $random(seed);
                    repeat(data_burst_size)begin 
                        if(bfm.almost_full)begin  // wait 2 cycles to avoid losing data 
                            repeat(6)@(posedge bfm.clk_a);
                        end
                        if(!bfm.full)  begin
                            bfm.push_data_single(data_array[burst_count],success_write);
                            `IF_DEBUG_PRINT_ENABLED $display("data_array_temp: %h data_array[burst_count] %h , %d",data_array_temp, data_array[burst_count], burst_count);
                            burst_count=burst_count+1;
                            if(burst_count >= (STIMULUS_DEPTH))begin
                                push_data_burst_enabled = 0;
                                break;
                            end
                        end
                    end
                    data_burst_idle = $random(seed);
                    repeat(data_burst_idle)@(posedge bfm.clk_a);
            end     
    end
endtask


// double empty flag check 
task pop_data_multi_2(ref logic [DATA_WIDTH-1:0] data_array_pop [0:STIMULUS_DEPTH-1], input int seed);
    bit [3:0] data_burst_size;
    bit [3:0] data_burst_idle;
    int burst_count;
    logic [DATA_WIDTH-1:0] data_array_temp;
    bit success_read;
    begin
        @(posedge bfm.clk_b);
        data_burst_size = $random(seed);
        data_burst_idle = $random(seed);
        burst_count     = 0;
        pop_data_burst_enabled   = 1;
            while(pop_data_burst_enabled)begin
                    data_burst_size = $random(seed);
                    @(posedge bfm.clk_b);
                    repeat(data_burst_size)begin 
                        if(bfm.almost_empty)begin  // wait 2 cycles to avoid data corruption
                            repeat(6)@(posedge bfm.clk_b);
                        end
                        if(!(bfm.empty))  begin
                                    bfm.pop_data_single_2(data_array_temp,success_read);
                                    data_array_pop[burst_count]=data_array_temp;
                                    `IF_DEBUG_PRINT_ENABLED $display("safe data_array_pop[burst_count] %h , %d",data_array_pop[burst_count],burst_count);
                                    burst_count=(success_read)? burst_count+1: burst_count;
                                    if(burst_count >= (STIMULUS_DEPTH))begin
                                        pop_data_burst_enabled = 0;
                                        break;
                                    end
                        end
                    end 
                    data_burst_idle = $random(seed);
                    repeat(data_burst_idle)@(posedge bfm.clk_a);
            end 
    end    
endtask



endclass

