`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/29/2022 03:53:19 PM
// Design Name: 
// Module Name: sum_zero
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


module sum_zero(
    input reset,
    input clk,
    input ack,
    input [7:0] size,
    output [23:0] tuple,
    output valid
    );        
    reg valid;
    reg [23:0] tuple;
    reg in_ready, out_ready;               //flag to indicate module completion
    reg rst_assrt;

    reg [7:0] array[0:255];
    reg [7:0] out_array[0:255][0:2];
    integer row;
    integer i, j, arr_size, hash_pointer, arr_pointer;
    reg [8:0] temp;
    reg [7:0] sum, curr_sum;   //the sum to be calculated
    reg [7:0] hash[0:255];  //a hash map of array elemnts to compute sum with max 256 elements
        
    //To access module rom_256x8
    reg [7:0] address;
    reg cs;
    wire [7:0] dout_rom;
    
    rom_256x8 ROM(
        dout_rom, // Data output
        address , // Address input
        cs        // Chip Select
    );
    
    function [8:0] find_value();
        input [7:0] value;
        begin
            find_value = 8'b0;
            for (integer i=0;i<arr_size;i = i+1) begin
                if(hash[i] == value) begin
                    find_value = {1'b1, hash[i]};
                end
            end
        end
    endfunction 

    always @(negedge reset)begin 
        rst_assrt = 1'b1;
        out_ready = 1'b0;
        row=0;
        hash_pointer = 0;
        arr_size = size;
        arr_pointer = 0;
    end 
    
    always @(posedge clk) 
    if(rst_assrt)begin
        if(arr_pointer < arr_size) begin
            address = arr_pointer;
            cs = 1'b1;
            array[arr_pointer] = dout_rom;
            hash[arr_pointer] = 8'b0;
            arr_pointer = arr_pointer +1;
        end
        else begin
            in_ready = 1'b1;
            rst_assrt = 1'b0;
            cs = 1'b0;
        end
    end
    
    always @(posedge clk)
    begin
        if(reset) begin
            valid = 0;
            in_ready = 1'b0;
            out_ready = 1'b0;
            rst_assrt = 1'b0;
        end
        else begin
            if(in_ready) begin
                for(i=0;i<arr_size;i=i+1) begin
                    curr_sum = sum - array[i];
                    for(j=i+1;j<size;j=j+1) begin
                        temp = find_value(curr_sum - array[j]);
                        if(temp[8] == 1'b1) begin
                            out_array[row][0] = array[i];
                            out_array[row][1] = array[j];
                            out_array[row][2] = temp[7:0];
                            row = row+1;
                        end
                        hash[hash_pointer] = array[j];
                        hash_pointer = hash_pointer+1;
                    end
                    hash_pointer = 0;
                    for(integer j=0;j<arr_size;j=j+1) begin
                        hash[j] = 8'b0;
                    end
                end
                out_ready = 1'b1;
                in_ready = 1'b0;
            end
        end
    end
    always @(posedge clk) begin
        if(out_ready && (!valid || ack)) begin
            if(row>=0) begin
                row = row-1;
                valid = 1'b0;
                tuple[7:0] = out_array[row][0];
                tuple[15:8] = out_array[row][1];
                tuple[23:16] = out_array[row][2];
                valid = 1'b1;
            end
            else begin
                out_ready = 1'b0;
                valid = 1'b0;
            end
        end
    end 
        
endmodule
