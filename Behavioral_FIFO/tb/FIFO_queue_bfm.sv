///`define VERBOSE_PRINT_ENABLED `INTERFACE_DEBUG // attempt to make debug switches modular, ie global vs local verbosity
`ifdef INTERFACE_DEBUG
	`define VERBOSE_PRINT_ENABLED 1
`else
	`define VERBOSE_PRINT_ENABLED 0
`endif

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
    logic almost_empty;
    logic almost_full;
   


   
task reset_fifo();
    `IF_DEBUG_PRINT_ENABLED $display("RST INTERFACE: reset press: rst_a=%1b",rstn_a);
    `IF_DEBUG_PRINT_ENABLED $display("RST INTERFACE: reset press: rst_b=%1b",rstn_b);
    push = 1'b0;
    pop = 1'b0;
    rstn_a = 1'b0;
    rstn_b = 1'b0;
    `IF_DEBUG_PRINT_ENABLED $display("RST INTERFACE: reset press: rst_a=%1b",rstn_a);
    `IF_DEBUG_PRINT_ENABLED $display("RST INTERFACE: reset press: rst_b=%1b",rstn_b);
    repeat(5) @(posedge clk_a);
    rstn_a = 1'b1;
    rstn_b = 1'b1;
    `IF_DEBUG_PRINT_ENABLED $display("RST INTERFACE: reset press: DONE rst_a=%1b",rstn_a);
    `IF_DEBUG_PRINT_ENABLED $display("RST INTERFACE: reset press: DONE rst_b=%1b",rstn_b);
endtask

// clock generation
initial clk_a = 0;
always #(CLKA_PERIOD/2) clk_a = ~clk_a;

initial clk_b = 0;
always #(CLKB_PERIOD/2) clk_b = ~clk_b;


task push_data_single;
    input [DATA_WIDTH-1:0] write_data;
    output                  success_write;
    begin
        `IF_DEBUG_PRINT_ENABLED $display("WR INTERFACE 0: write_data: %h, bfm.datain: %h",write_data,datain_a);
        {datain_a,push} <= {write_data,1'b1};
        @(posedge clk_a);
        `IF_DEBUG_PRINT_ENABLED $display("WR INTERFACE 1: write_data: %h, datain: %h",write_data,datain_a);
        {datain_a,push} <= {write_data,1'b0};
        success_write   <= !full;
        @(posedge clk_a);
        {datain_a,push}  = {write_data,1'b0};
        `IF_DEBUG_PRINT_ENABLED $display("WR INTERFACE 2: write_data: %h, datain: %h",write_data,datain_a);
    end
endtask


task pop_data_single;
    output [DATA_WIDTH-1:0] read_data;
    output                  succes_read;
    begin
        succes_read     <= 0;
        {read_data,pop} <= {dataout_b,1'b1}; //(!empty)?{dataout_b,1'b1}:{dataout_b,1'b0};//
        `IF_DEBUG_PRINT_ENABLED $display("RD INTERFACE pre edge: data_out: %h , read_data: %h",dataout_b,read_data);
        @(posedge clk_b); // read_data has the previous fifo output ( ie previous popped data), after reset it is 'hx, pop is set at this rising edge.
        {read_data,pop} <= {dataout_b,1'b0};
        succes_read     <= !empty; // need to check flag empty flag right here.
         `IF_DEBUG_PRINT_ENABLED $display("RD INTERFACE at edge: data_out: %h , read_data: %h",dataout_b,read_data);        
        @(posedge clk_b); // read_data is assigned with dataout_b from the previous rising edge, which after reset is 'hx, pop goes low at this edge. this worked for the behavioral implementation of the FIFO
                          // RTL FIFO should get the data after this edge with a blocking assignment
        {read_data,pop} = {dataout_b,1'b0};  // MAKE IT WORK FIRST, improve it later. Adding blocking assignment for RTL implementation proper functionality.
        `IF_DEBUG_PRINT_ENABLED $display("RD INTERFACE pos edge: data_out: %h , read_data: %h",dataout_b,read_data);   

    end
endtask



endinterface : FIFO_queue_bfm