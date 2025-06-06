`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/02/2025 01:21:29 PM
// Design Name: 
// Module Name: order
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


module order(
    input [31:0] price,
    input [31:0] quantity,
    input side,
    input [31:0] time_entered,
    
    input [31:0] best_ask,
    input [31:0] best_bid,
    
    // order_id, 
    output match
    );
        
    always @(*) begin
    // if on the buyer side and price is >= to sellers lowest accept, match
    if (side == 0 && price >= best_ask)      
        match = 1;
    // if on the seller side and price bid is >= to price, match
    else if (side == 1 && price <= best_bid) 
        match = 1;
    else
        match = 0;
    end
endmodule
