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
class FIFO_queue_top;

 virtual FIFO_queue_bfm bfm;
 
 localparam DATA_WIDTH = 16; //FIFO_queue_bfm::DATA_WIDTH;
 localparam FIFO_DEPTH = 16; //FIFO_queue_bfm::FIFO_DEPTH;
 
 //TODO: fix parameters, use parameters delcared in inteface
 logic [DATA_WIDTH-1:0] queue_16x16 [$:FIFO_DEPTH];
 
 function new(virtual FIFO_queue_bfm bfm_constructor);
    bfm=bfm_constructor;
 endfunction: new
    
 task run_FIFO_flag_full();
    @(posedge bfm.clk_a) bfm.full = (queue_16x16.size()==FIFO_DEPTH)? 1'b1 : 1'b0; 
 endtask : run_FIFO_flag_full
 
 task run_FIFO_flag_empty();
    @(posedge bfm.clk_b) bfm.empty = (queue_16x16.size()=='h0)? 1'b1 : 1'b0;
 endtask : run_FIFO_flag_empty
 
 task execute();
    fork
        run_FIFO_write();
        run_FIFO_read();
        run_FIFO_flag_full();
        run_FIFO_flag_empty();
    join
endtask: execute
 
task run_FIFO_write();
//    bit push_l;
    forever begin: write_fifo
    @(posedge bfm.clk_a);
    if(bfm.push)begin
        $display("pushed data %2h",bfm.datain_a);
        if(!bfm.full)begin
//            push_data(datain_a);
            queue_16x16.push_front(bfm.datain_a);
            $display("pushed data ?? , full=%2h , size=%2h",bfm.full,queue_16x16.size());
        end                    
    end
    end: write_fifo
endtask

task run_FIFO_read;
    forever begin: read_fifo
    @(posedge bfm.clk_b);
    if(bfm.pop)begin
        $display("pop data %2h",bfm.dataout_b);
        if(!bfm.empty)begin
            bfm.dataout_b=queue_16x16.pop_back();
            $display("ppped data ?? ");
        end
    end
    end: read_fifo
endtask
 

endclass



