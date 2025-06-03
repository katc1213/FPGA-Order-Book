`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/02/2025 01:21:29 PM
// Design Name: 
// Module Name: bats_parser
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


module bats_parser(
    input clk,
    input reset,
    input[7:0] data_in,
    input data_valid,
    input start_parse,
    input command_ready,
    
    // type: add 00, cancel 01, modify 10
    output reg[1:0] parse_opcode,
    output reg[15:0] parse_id,
    output reg[15:0] parse_price,
    output reg[15:0] parse_quantity,
    // BUY/SELL = 0/1
    output reg parse_side,
    output reg parse_valid,
    output reg parse_done
    );
    
//    typedef enum {
//        IDLE,
//        OPCODE,
//        ORDER_ID,
//        SIDE,
//        PRICE,
//        QUANTITY,
//        DONE
//    } state_t;
    
    //state_t state, next_state;
    
//    reg [7:0] buffer [0:63];     // temporary input buffer
//    integer buf_idx;
    
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            state <= IDLE;
            parse_valid <= 0;
//            buf_idx <= 0;
//            field_index <= 0;
        end else begin
            state <= next_state;
            if (data_valid && state != DONE) begin
            end
            end
    end
    
endmodule