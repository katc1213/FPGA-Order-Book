`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2025 03:12:00 PM
// Design Name: 
// Module Name: hash_table
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


module hash_table #(
    parameter KEY_WIDTH = 8,
    parameter DATA_WIDTH = 16,
    parameter MEM_SIZE = 16
) (
    input clk,
    input reset,
    input [KEY_WIDTH-1:0] key_in,
    input [DATA_WIDTH-1:0] data_in,
    input write_en,
    input read_en,
    input delete_en,
    output reg [DATA_WIDTH-1:0] data_out,
    output reg valid
);
    // Simple hash table storage
    reg [KEY_WIDTH-1:0] keys [0:MEM_SIZE-1];
    reg [DATA_WIDTH-1:0] values [0:MEM_SIZE-1];
    reg [MEM_SIZE-1:0] valid_bits;

    integer i;
    wire [31:0] hash = key_in % MEM_SIZE;  // very simple hash

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            valid_bits <= 0;
            for (i=0; i<MEM_SIZE; i=i+1) begin
                keys[i] <= 0;
                values[i] <= 0;
            end
            data_out <= 0;
            valid <= 0;
        end else begin
            if (write_en) begin
                keys[hash] <= key_in;
                values[hash] <= data_in;
                valid_bits[hash] <= 1;
            end
            if (delete_en) begin
                if (valid_bits[hash] && keys[hash] == key_in)
                    valid_bits[hash] <= 0;
            end
            if (read_en) begin
                if (valid_bits[hash] && keys[hash] == key_in) begin
                    data_out <= values[hash];
                    valid <= 1;
                end else begin
                    data_out <= 0;
                    valid <= 0;
                end
            end
        end
    end
endmodule