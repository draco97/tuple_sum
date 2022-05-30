`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2022 04:03:48 PM
// Design Name: 
// Module Name: rom_256x8
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


module rom_256x8(
    dout, addr, cs
    );
    output[7:0] dout;
    input[7:0] addr;
    input cs;
    
    reg [7:0] ROM[0:255];    
    assign dout = cs?ROM[addr]:8'b0;  
    initial begin
        ROM[0] = -8'd5;
        ROM[1] = -8'd2;
        ROM[2] = -8'd3;
        ROM[3] = 8'd5;
        ROM[4] = 8'd3;
        ROM[5] = 8'd0;
        ROM[6] = 8'd2;
        ROM[7] = 8'd1;
    end 
endmodule
