`timescale 1ns / 1ps
`define EMPTY_PTR 8'hFF
`include "linked_list.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2025 02:28:22 PM
// Design Name: 
// Module Name: orderbook
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


module orderbook #(
    parameter WIDTH = 32, DEPTH = 8, PRICE_LVL = 256 
    )(
    input clk,
    input reset,
    
    input [WIDTH - 1:0] price,
    input [WIDTH - 1:0] quantity,
    input [15:0] order_id,
    input side,                    // 0 = BID, 1 = ASK
    input [WIDTH - 1:0] time_entered,
    
    output reg [WIDTH - 1:0] best_ask,
    output reg [WIDTH - 1:0] best_bid
    );
    
    wire [7:0] list_head_in;
    wire [7:0] list_head_out;
    wire [7:0] new_node_idx;
    // head of LL -> order entered in first or high priority at each PL
    reg [7:0] bid_head [0:255]; // bid LL head pointers
    reg [7:0] ask_head [0:255]; // ask LL head pointers
    
    assign list_head_in = (side == 1'b0) ? bid_head[price] : ask_head[price];
    
//    parameter idle = 8'h00;
//    parameter add_en = 8'h01;
//    parameter cancel_en = 8'h02;
//    parameter update_en = 8'h03;

    linked_list #(.N(256)) order_list(
        .clk(clk),
        .reset(reset),
        .insert_en(insert_en),
        .order_id_in(order_id),
        .qunantity_in(quantity),
        .ll_head_in(list_head_in),
        .ll_head_out(list_head_out),
        .new_node_idx(new_node_idx)
    );
    
    //reg [7:0] state = idle;
    
    integer i, j;
    
    always @(posedge clk) begin
        if (insert_en) begin
            if (side == 1'b0)
                bid_head[price] <= list_head_out;
            else
                ask_head[price] <= list_head_out;
        end
    end
    
//    always @(posedge clk or posedge reset) begin
//        best_ask <= 0;
//        best_bid <= 0;
//        if (reset) begin
//            for (i = 0; i < 256; i = i + 1)
//                for (j = 0; j < DEPTH; j = j + 1) begin
//                    valid_bid[i][j] <= 0;
//                    valid_ask[i][j] <= 0;
//                end
//        end else begin
//            if (add_en) begin
//                if (side == 0) begin
//                    for (j = 0; j < DEPTH; j = j + 1) begin
//                        if (!valid_bid[price][j]) begin
//                            valid_bid[price][j] <= 1;
//                            bid_order_id[price][j] <= order_id;
//                            bid_quantity[price][j] <= quantity;
//                            bid_time[price][j] <= time_entered;
//                            disable add_bid_loop;
//                        end
//                    end
//                end else begin
//                    for (j = 0; j < DEPTH; j = j + 1) begin
//                        if (!valid_ask[price][j]) begin
//                            valid_ask[price][j] <= 1;
//                            ask_order_id[price][j] <= order_id;
//                            ask_quantity[price][j] <= quantity;
//                            ask_time[price][j] <= time_entered;
//                            disable add_ask_loop;
//                        end
//                    end
//                end
//            end
//            if (cancel_en) begin
//                if (side == 0) begin
//                    for (j = 0; j < DEPTH; j = j + 1) begin
//                        if (valid_bid[price][j] && bid_order_id[price][j] == order_id)
//                            valid_bid[price][j] <= 0;
//                    end
//                end else begin
//                    for (j = 0; j < DEPTH; j = j + 1) begin
//                        if (valid_ask[price][j] && ask_order_id[price][j] == order_id)
//                            valid_ask[price][j] <= 0;
//                    end
//                end
//            end
//            if (update_en) begin
//                if (side == 0) begin
//                    for (j = 0; j < DEPTH; j = j + 1) begin
//                        if (valid_bid[price][j]) begin
//                            bid_quantity[price][j] <= bid_quantity[price][j] - quantity;
//                            if (bid_quantity[price][j] <= 0)
//                                valid_bid[price][j] <= 0;
//                            disable update_bid_loop;
//                        end
//                    end
//                end else begin
//                    for (j = 0; j < DEPTH; j = j + 1) begin
//                        if (valid_ask[price][j]) begin
//                            ask_quantity[price][j] <= ask_quantity[price][j] - quantity;
//                            if (ask_quantity[price][j] <= 0)
//                                valid_ask[price][j] <= 0;
//                            disable update_ask_loop;
//                        end
//                    end
//                end
//            end
//        end
//    end

//    always @(*) begin
//        best_bid = 0;
//        best_ask = {WIDTH{1'b1}};
//        for (i = 255; i >= 0; i = i - 1)
//            for (j = 0; j < DEPTH; j = j + 1)
//                if (valid_bid[i][j]) begin
//                    best_bid = i;
//                    disable best_bid_search;
//                end
//        for (i = 0; i < 256; i = i + 1)
//            for (j = 0; j < DEPTH; j = j + 1)
//                if (valid_ask[i][j]) begin
//                    best_ask = i;
//                    disable best_ask_search;
//                end
//    end
endmodule