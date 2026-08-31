`timescale 1ns / 1ps
module blockingVsNonBlocking_tb(
        input a,
        output b
    );
    parameter CLKA_PERIOD=5;  
    
    reg [7:0] count;
    logic [7:0] mem [0:32];
    logic capture;
    logic condition_A;
    logic clk;
    logic [7:0]count_instant_copy;
// clock generation
initial clk = 0;
always #(CLKA_PERIOD/2) clk = ~clk;

logic[3:0] push_add;
logic[3:0] pop_add;
logic[3:0] diff_add;
FourBit_substract substractInst(
    .push_add(push_add),
    .pop_add(pop_add),
    .diff_add(diff_add)
    );

//initial begin
task count_task;
        count = 'h0;
        forever begin: count_1
            @(posedge clk) count <=count+1'b1;
        end: count_1
endtask

task read_counter;
    output count_int;
    count_int=count;
endtask

initial begin
    fork
        count_task();
    join 
end

int print_count;
logic      a,b,c;
logic [7:0]counter;
initial begin 
    #40
    print_count=0;
    condition_A =1'b0;
    a <= 1'b1;
    b <= 1'b1;
    c = 1'b1;
    $display("first assign: a <=1 , b<=1 ,c=1 at time %t",$realtime);    
      
      repeat(0) begin 
        @(posedge clk);
        $display("repeat 0 test");  //will this print work ??  NO
      end


    @(posedge clk) a <= 1'b0; 
    $display("assigned right after first clk edge: a <= 0 , b not assigned ,c not assigned at time %t",$realtime);
    $display("first clk edge: a = %b , b= %b ,c=%b",a,b,c);
    b <=1'b0;
    c = 1'b0;
    $display("assigned right after first clk edge: a not assigned , b<=0 ,c=0 at time %t",$realtime);
    $display("a = %b , b= %b ,c=%b",a,b,c);
    @(posedge clk); // a and b are assigned 0 until this point. befor this ( NBA the RHS 1'b0 for both was just evaluated)
    $display("second clk edge: a = %b , b= %b ,c=%b",a,b,c);
    b <= 1'b1;
    $display("assigned right after second clk edge: a not assigned , b<=1 ,c not assigned at time %t",$realtime);
    $display("a = %b , b= %b ,c=%b",a,b,c);
    $display("assigned right after second clk edge: a <= 1 , b not assigned ,c = 1 at time %t",$realtime);
    a <= 1'b1;
    c = 1'b1;
    $display("a = %b , b= %b ,c=%b",a,b,c);
    // a and b are not assigned at this point , only RHS is evaluated.
    #1 
    $display(" #1 delay : ");
    $display("a = %b , b= %b ,c=%b",a,b,c);
    
    @(posedge clk);
    a <= 1'b0;
    b <= 1'b0;
    c = 1'b0;
    $display("assigned right after third clk edge: a <= 0 , b<=0 ,c = 0 at time %t",$realtime);
    $display("a = %b , b= %b ,c=%b",a,b,c);
    @(posedge clk);
    $display("last clk edge: a  , b ,c  not assigned at time %t",$realtime);
    $display("a = %b , b= %b ,c=%b",a,b,c);
    toggle_data(a,b);
    toggle_data(a,c);
    
    pop_add <='h2;
    push_add<='h0;
    @(posedge clk);
    pop_add <='h3;
    push_add<='h0;
    @(posedge clk);
        pop_add <='h4;
    push_add<='h0;
    @(posedge clk);
        pop_add <='h5;
    push_add<='h0;
    @(posedge clk);
    
    repeat(5)@(posedge clk);
    pop_add <='hb;
    push_add<='ha;
    @(posedge clk);
    pop_add <='hf;
    push_add<='ha;
    @(posedge clk);
    pop_add <='h2;
    push_add<='hc;
    @(posedge clk);
    pop_add <='h4;
    push_add<='h9;
    @(posedge clk);
    
    
    
    repeat(5)@(posedge clk);
    pop_add <='ha;
    push_add<='h9;
    @(posedge clk);
    pop_add <='ha;
    push_add<='h7;
    @(posedge clk);
    pop_add <='hc;
    push_add<='h5;
    @(posedge clk);
    pop_add <='h9;
    push_add<='h4;
    @(posedge clk);
    
    repeat(5)@(posedge clk);
    pop_add <='h1;
    push_add<='h0;    
    
   
    $finish();

end 


task toggle_data(input logic x,output logic y);
    y <= !x;
    @(posedge clk);
endtask

initial begin 
        count_instant_copy =7'h0;
        capture            =1'b0;
    forever begin
//    $display("count_instant_copy %h, pre posedge",count_instant_copy);
        @(posedge clk);
            if(condition_A)begin
//                capture=1'b1;
                read_counter(count_instant_copy); $display("count_instant_copy %h @posedge",count_instant_copy);
            end
    end
end
    
    
endmodule
