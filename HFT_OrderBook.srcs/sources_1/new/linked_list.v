`timescale 1ns / 1ps
`define EMPTY_PTR 8'hFF
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2025 01:31:00 PM
// Design Name: 
// Module Name: linked_list
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


module linked_list #(
    parameter N = 256
 )(
    input clk,
    input reset,
    input insert_en,
    // input cancel_en,
    
    input [31:0] order_id_in,
    input [15:0] quantity_in,
    input [7:0]  ll_head_in,     // current head pointer
    output reg [7:0] ll_head_out,// new head pointer (unchanged or updated)
    output reg [7:0] new_node_idx  // index of inserted node
    );
    
    // Node arrays for linked list DA with 256 price levels
    reg [31:0] order_id [0:N-1];
    reg [15:0] order_quantity [0:N-1];
    reg [7:0]  order_next [0:N-1];   // Next pointer (linked list)
    
    reg [7:0]  free_ptr;             // Points to next free node index
    reg [7:0] curr_ptr;
    reg [7:0] prev_ptr;
    integer i;
    
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < N; i = i + 1) begin
                order_id[i]  <= 0;              // clear order id of each node
                order_quantity[i]  <= 0;        // clear quantity of each order
                order_next[i] <= `EMPTY_PTR;         // set next pointers to NULL or no next node
            end
            free_ptr <= 0;                      // point to next free node at index 0
            ll_head_out <= `EMPTY_PTR;               // list is empty so out head ptr point to NULL
        end else if (insert_en) begin
            new_node_idx <= free_ptr;
            
            // store new order
            order_id[free_ptr] <= order_id_in;
            order_quantity[free_ptr] <= quantity_in;
            order_next[free_ptr] <= `EMPTY_PTR;  // point to NULL 
            
            if (ll_head_in == `EMPTY_PTR) begin // if empty list, new order is head
                ll_head_out <= free_ptr;
            end else begin                  // if not, place at end of list
                i = ll_head_in;
                while (order_next[i] != `EMPTY_PTR)
                    i = order_next[i];
                order_next[i] <= free_ptr;
                ll_head_out <= ll_head_in;
           end
           free_ptr <= free_ptr + 1;
        end
     end
endmodule