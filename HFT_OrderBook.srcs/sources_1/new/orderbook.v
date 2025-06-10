`timescale 1ns / 1ps
`define EMPTY_PTR 8'hFF
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
    
    input [WIDTH - 1:0] price_in,
    input [WIDTH - 1:0] quantity_in,
    input [15:0] order_id_in,
    input side_in,                    // 0 = BID, 1 = ASK
    input [WIDTH - 1:0] time_entered,
    
    output reg [WIDTH - 1:0] best_ask,
    output reg [WIDTH - 1:0] best_bid
    );
    
    // Node arrays for linked list DA with 256 price levels
    reg [31:0] order_id [0:255];
    reg [15:0] order_quantity [0:255];
    reg [7:0]  order_next [0:255];   // Next pointer (linked list)
    reg [7:0]  order_head [0:255];   // Hash table: price → head node
    reg [7:0]  free_ptr;             // Points to next free node index
    
    reg [7:0] price_index;
    reg [7:0] node_ptr;
    reg [7:0] curr_ptr;

    parameter idle = 8'h00;
    parameter add_en = 8'h01;
    parameter cancel_en = 8'h02;
    parameter update_en = 8'h03;
    
    reg [7:0] state = idle;
    
//    reg valid_bid [0:255][0:DEPTH-1];
//    reg [WIDTH-1:0] bid_order_id [0:255][0:DEPTH-1];
//    reg [WIDTH-1:0] bid_quantity [0:255][0:DEPTH-1];
//    reg [WIDTH-1:0] bid_time [0:255][0:DEPTH-1];

//    reg valid_ask [0:255][0:DEPTH-1];
//    reg [WIDTH-1:0] ask_order_id [0:255][0:DEPTH-1];
//    reg [WIDTH-1:0] ask_quantity [0:255][0:DEPTH-1];
//    reg [WIDTH-1:0] ask_time [0:255][0:DEPTH-1];
    
    integer i, j;
    
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < PRICE_LVL; i = i + 1) begin
                 order_head[i] <= `EMPTY_PTR;
            end
            state <= idle;
            free_ptr <= 0;
        end else if (state == add_en) begin            
            price_index = price_in % 256;
            node_ptr    = free_ptr;
            free_ptr    = free_ptr + 1;
            
            order_id[node_ptr] <= order_id_in;
            order_quantity[node_ptr] <= quantity_in;
            order_next[node_ptr] <= `EMPTY_PTR;
            
            if (order_head[price_index] == `EMPTY_PTR) begin
                order_head[price_index] <= node_ptr;
            end else begin
                curr_ptr = order_head[price_index];
                while (order_next[curr_ptr] != `EMPTY_PTR) begin
                    curr_ptr = order_next[curr_ptr];
                end
                order_next[curr_ptr] <= node_ptr;
            end
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