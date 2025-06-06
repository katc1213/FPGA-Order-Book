`timescale 1ns / 1ps
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
    parameter WIDTH = 32, DEPTH = 8
    )(
    input clk,
    input reset,
    input [7:0] state,
    
    input [WIDTH - 1:0] price,
    input [WIDTH - 1:0] quantity,
    input [15:0] order_id,
    input side,         // 0 = BID, 1 = ASK
    input [WIDTH - 1:0] time_entered,
    
    input add_en,
    input cancel_en,
    input update_en,
    
    output reg [WIDTH - 1:0] best_ask,
    output reg [WIDTH - 1:0] best_bid
    );
    
    reg valid_bid [0:255][0:DEPTH-1];
    reg [WIDTH-1:0] bid_order_id [0:255][0:DEPTH-1];
    reg [WIDTH-1:0] bid_quantity [0:255][0:DEPTH-1];
    reg [WIDTH-1:0] bid_time [0:255][0:DEPTH-1];

    reg valid_ask [0:255][0:DEPTH-1];
    reg [WIDTH-1:0] ask_order_id [0:255][0:DEPTH-1];
    reg [WIDTH-1:0] ask_quantity [0:255][0:DEPTH-1];
    reg [WIDTH-1:0] ask_time [0:255][0:DEPTH-1];
    
    integer i, j;

    always @(posedge clk or posedge reset) begin
        best_ask <= 0;
        best_bid <= 0;
        if (reset) begin
            for (i = 0; i < 256; i = i + 1)
                for (j = 0; j < DEPTH; j = j + 1) begin
                    valid_bid[i][j] <= 0;
                    valid_ask[i][j] <= 0;
                end
        end else begin
            if (add_en) begin
                if (side == 0) begin
                    for (j = 0; j < DEPTH; j = j + 1) begin
                        if (!valid_bid[price][j]) begin
                            valid_bid[price][j] <= 1;
                            bid_order_id[price][j] <= order_id;
                            bid_quantity[price][j] <= quantity;
                            bid_time[price][j] <= time_entered;
                            disable add_bid_loop;
                        end
                    end
                end else begin
                    for (j = 0; j < DEPTH; j = j + 1) begin
                        if (!valid_ask[price][j]) begin
                            valid_ask[price][j] <= 1;
                            ask_order_id[price][j] <= order_id;
                            ask_quantity[price][j] <= quantity;
                            ask_time[price][j] <= time_entered;
                            disable add_ask_loop;
                        end
                    end
                end
            end
            if (cancel_en) begin
                if (side == 0) begin
                    for (j = 0; j < DEPTH; j = j + 1) begin
                        if (valid_bid[price][j] && bid_order_id[price][j] == order_id)
                            valid_bid[price][j] <= 0;
                    end
                end else begin
                    for (j = 0; j < DEPTH; j = j + 1) begin
                        if (valid_ask[price][j] && ask_order_id[price][j] == order_id)
                            valid_ask[price][j] <= 0;
                    end
                end
            end
            if (update_en) begin
                if (side == 0) begin
                    for (j = 0; j < DEPTH; j = j + 1) begin
                        if (valid_bid[price][j]) begin
                            bid_quantity[price][j] <= bid_quantity[price][j] - quantity;
                            if (bid_quantity[price][j] <= 0)
                                valid_bid[price][j] <= 0;
                            disable update_bid_loop;
                        end
                    end
                end else begin
                    for (j = 0; j < DEPTH; j = j + 1) begin
                        if (valid_ask[price][j]) begin
                            ask_quantity[price][j] <= ask_quantity[price][j] - quantity;
                            if (ask_quantity[price][j] <= 0)
                                valid_ask[price][j] <= 0;
                            disable update_ask_loop;
                        end
                    end
                end
            end
        end
    end

    always @(*) begin
        best_bid = 0;
        best_ask = {WIDTH{1'b1}};
        for (i = 255; i >= 0; i = i - 1)
            for (j = 0; j < DEPTH; j = j + 1)
                if (valid_bid[i][j]) begin
                    best_bid = i;
                    disable best_bid_search;
                end
        for (i = 0; i < 256; i = i + 1)
            for (j = 0; j < DEPTH; j = j + 1)
                if (valid_ask[i][j]) begin
                    best_ask = i;
                    disable best_ask_search;
                end
    end
endmodule