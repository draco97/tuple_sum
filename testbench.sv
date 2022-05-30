`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2022 06:24:15 PM
// Design Name: 
// Module Name: testbench
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


module testbench();
    reg clk, reset, ack;
    reg [7:0] size;
    wire [7:0] tuple1;
    wire [7:0] tuple2;
    wire [7:0] tuple3;
    wire valid;
    reg [7:0] count;
    
    sum_zero TupleSum(
        reset,
        clk,
        ack,
        size,
        tuple1,
        tuple2,
        tuple3,
        valid);
    
    initial begin
        clk = 0;
        reset = 1;
        ack = 0;
        count = 0;
    end
    
    always #5 clk = ~clk;
    
//    initial  begin
//      $dumpfile ("tupleSum.vcd"); 
//      $dumpvars; 
//    end
    
    initial #500 $finish();
    
    initial begin
        size = 8'h7;
        #20;
        reset = 1'b0;
        #150;
        $monitor("Reset module to change size to 4");
        reset = 1'b1;
        count = 0;
        size = 8'h4;
        #20;
        reset = 1'b0;
        #150;
        reset = 1'b1;
    end
    
    //Logic to read the outputs
    always @(posedge valid) begin
        byte t1 = tuple1;
        byte t2 = tuple2;
        byte t3 = tuple3;
        if(count == 0)
            $display("New Results for sum after Reset:");
        $display("Triplet No.%d = [%0d,%0d,%0d]", count+1, t1, t2, t3);
        count = count+1;
        #15;
        ack = 1'b1;
    end 
    always @(negedge valid) #5 ack = 1'b0;
        
endmodule
