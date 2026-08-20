`define VERBOSE_PRINT_ENABLED 1
//`define VERBOSE_PRINT_ENABLED `INTERFACE_DEBUG
`define IF_DEBUG_PRINT_ENABLED if(`VERBOSE_PRINT_ENABLED)  

interface FIFO_queue_bfm;

        parameter DATA_WIDTH=16;
        parameter FIFO_DEPTH = 16;
        
    localparam   CLKA_PERIOD   = 5;//10ns;
    localparam   CLKB_PERIOD   = 3.33;//6.66ns; 

    logic clk_a;
    logic rstn_a;
    logic [DATA_WIDTH-1:0] datain_a;
    logic push;
    logic  pop;
    logic [DATA_WIDTH-1:0] dataout_b;  // output 
    logic clk_b;
    logic rstn_b;
    logic full;  //output 
    logic empty; // output 
   


   
task reset_fifo();
    $display("fifo_queue reset press: rst_a=%b1",rstn_a);
    $display("fifo_queue reset press: rst_b=%b1",rstn_b);
    rstn_a = 1'b0;
    rstn_b = 1'b0;
    repeat(5) @(posedge clk_a);
    rstn_a = 1'b1;
    rstn_b = 1'b1;
    $display("fifo_queue reset press: DONE rst_a=%b1",rstn_a);
    $display("fifo_queue reset press: DONE rst_b=%b1",rstn_b);
endtask

// clock generation
initial clk_a = 0;
always #(CLKA_PERIOD/2) clk_a = ~clk_a;

initial clk_b = 0;
always #(CLKB_PERIOD/2) clk_b = ~clk_b;


task push_data_single;
    input [DATA_WIDTH-1:0] write_data;
    begin
        `IF_DEBUG_PRINT_ENABLED $display("0 write_data: %h, bfm.datain: %h",write_data,datain_a);
        {datain_a,push} <= {write_data,1'b1};
        @(posedge clk_a);
        `IF_DEBUG_PRINT_ENABLED $display("1 write_data: %h, datain: %h",write_data,datain_a);
        {datain_a,push} <= {write_data,1'b0};
        @(posedge clk_a);
        {datain_a,push}  = {write_data,1'b0};
        `IF_DEBUG_PRINT_ENABLED $display("2 write_data: %h, datain: %h",write_data,datain_a);
    end
endtask

logic [DATA_WIDTH-1:0] read_data_tb;
task pop_data_single;
    //ref logic[DATA_WIDTH-1:0] read_data;
    output [DATA_WIDTH-1:0] read_data;
    begin
        {read_data,pop} <= {dataout_b,1'b1};
        `IF_DEBUG_PRINT_ENABLED $display("pre edge data_out: %h , read_data: %h",dataout_b,read_data);
        @(posedge clk_b);
        {read_data,pop} <= {dataout_b,1'b0};
        `IF_DEBUG_PRINT_ENABLED $display("at edge data_out: %h , read_data: %h",dataout_b,read_data);         
        @(posedge clk_b);
        `IF_DEBUG_PRINT_ENABLED $display("pos edge data_out: %h , read_data: %h",dataout_b,read_data);  

    end
endtask



endinterface : FIFO_queue_bfm