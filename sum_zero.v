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
    output [7:0] tuple1,
    output [7:0] tuple2,
    output [7:0] tuple3,
    output valid
    );        
    reg valid;
    reg [7:0] tuple1;
    reg [7:0] tuple2;
    reg [7:0] tuple3;
    reg in_ready, out_ready;               //flag to indicate module completion
    reg rst_assrt, first_addr;

    reg [7:0] array[0:255];
    reg [7:0] out_array[0:255][0:2];
    integer row;
    integer i, j, arr_size, hash_pointer, arr_pointer, iterator;
    reg [8:0] temp;
    integer curr_val, sum, curr_sum;   //the sum to be calculated
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
    
    function [8:0] find_value(input [7:0] value);
        begin
            find_value = 8'b0;
            for (iterator=0; iterator<255; iterator = iterator+1) begin
                if(hash[iterator] == value) begin
                    find_value = {hash[iterator], 1'b1};
                    hash[iterator] = 8'bxx;
                end
            end
        end
    endfunction 

    always @(negedge reset)begin 
        rst_assrt = 1'b1;
        out_ready = 1'b0;
        row=-1;
        hash_pointer = 0;
        arr_size = size;
        arr_pointer = 0;
        first_addr = 1;
    end 
    
    always @(posedge clk) 
    if(rst_assrt)begin
        if(first_addr == 1) begin
            cs = 1'b1;
            address = arr_pointer;
            first_addr = 0;
        end
        else begin
            if(arr_pointer < arr_size) begin
                array[arr_pointer] = dout_rom;
                hash[arr_pointer] = 8'bxx;
                arr_pointer = arr_pointer +1;
                address = arr_pointer;
            end
            else begin
                in_ready = 1'b1;
                rst_assrt = 1'b0;
                cs = 1'b0;
                row = 0;
            end
        end
    end
    
    always @(posedge clk)
    begin
        if(reset) begin
            valid = 0;
            in_ready = 1'b0;
            out_ready = 1'b0;
            rst_assrt = 1'b0;
            sum = 0;
            curr_sum = 0;
            arr_size = 0;
            first_addr = 0;
        end
        else begin
            sum = 0;
            if(in_ready) begin
                for(i=0;i<arr_size-2;i=i+1) begin
                    curr_val = array[i];
                    curr_sum = sum - curr_val;
                    for(j=i+1;j<arr_size;j=j+1) begin
                        curr_val = array[j];
                        temp = find_value(curr_sum - curr_val);
                        if(temp[0] == 1'b1) begin
                            out_array[row][0] = array[i];
                            out_array[row][1] = array[j];
                            out_array[row][2] = temp[8:1];
                            row = row+1;
                        end
                        hash[hash_pointer] = array[j];
                        hash_pointer = hash_pointer+1;
                    end
                    hash_pointer = 0;
                    for(j=0;j<arr_size;j=j+1) begin
                        hash[j] = 8'bxx;
                    end
                end
                out_ready = 1'b1;
                in_ready = 1'b0;
            end
        end
    end
    always @(posedge clk) begin
        if(out_ready && (!valid)) begin
            if(row>0) begin
                valid = 1'b0;
                row = row-1;
                tuple1 = out_array[row][0];
                tuple2 = out_array[row][1];
                tuple3 = out_array[row][2];
                valid = 1'b1;
            end
            else begin
                out_ready = 1'b0;
                valid = 1'b0;
            end
        end
    end 
    always @(posedge ack) valid = 1'b0;
        
endmodule
