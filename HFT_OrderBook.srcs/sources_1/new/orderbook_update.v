`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2025 12:37:09 PM
// Design Name: 
// Module Name: orderbook
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Includes bids and asks of ONE specific asset and is represented as a hash table
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module orderbook_update (
    input clk,
    input reset,
    input [1:0] op_type,       // 00: ADD, 01: CANCEL, 10: TRADE, 11: PUBLISH
    input side,                 // 0 = BID, 1 = ASK
    input [31:0] price,
    input [31:0] quantity,
    input [31:0] order_id,
    input [31:0] time_entered,
    input [7:0] instrumentID,
    output [31:0] best_bid,
    output [31:0] best_ask
);

    wire add_en = (op_type == 2'b00);
    wire cancel_en = (op_type == 2'b01);
    wire update_en = (op_type == 2'b10);

    wire [15:0] ob_pointer;
    wire ob_valid;

    hash_table #(8, 16, 16) orderbook_map ( // hash_table(KEY_WIDTH, DATA_WIDTH, MEM_SIZE)
        .clk(clk),
        .reset(reset),
        .key_in(instrumentID),
        .data_in(16'd1),
        .write_en(1'b0),
        .read_en(1'b1),
        .delete_en(1'b0),
        .data_out(ob_pointer),
        .valid(ob_valid)
    );

    orderbook ob (
        .clk(clk),
        .reset(reset),
        .price(price),
        .order_id(order_id),
        .side(side),
        .add_en(add_en),
        .cancel_en(cancel_en),
        .update_en(update_en),
        .quantity(quantity),
        .time_entered(time_entered),
        .best_bid(best_bid),
        .best_ask(best_ask)
    );

endmodule