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
        ROM[0] = -5;
        ROM[1] = -2;
        ROM[2] = 3;
        ROM[3] = 2;
        ROM[4] = 0;
        ROM[5] = -5;
        ROM[6] = 4;
        ROM[7] = 1;
    end 
endmodule
