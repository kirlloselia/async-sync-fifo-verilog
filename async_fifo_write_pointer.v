`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2025 08:59:45 PM
// Design Name: 
// Module Name: async_fifo_write_pointer
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


module async_fifo_write_pointer #(
    parameter DEPTH = 100
)(
    input w_rst,
    input wclk,
    input w_en,
    input [$clog2(DEPTH):0] r_ptr_sync,
    output reg [$clog2(DEPTH):0] w_addr,
    output [$clog2(DEPTH):0] w_ptr_gray,
    output full_flag
    );

    localparam ADDR_DEPTH = $clog2(DEPTH); // 7 Bits


    // reg [ADDR_DEPTH:0] w_addr_int;
    // assign w_addr = w_addr_int;
    b2g #(.WIDTH(ADDR_DEPTH)) b2g_w (.B(w_addr[ADDR_DEPTH-1:0]), .G(w_ptr_gray[ADDR_DEPTH-1:0]));
    assign w_ptr_gray[ADDR_DEPTH] = w_addr[ADDR_DEPTH];

    always @(posedge wclk, negedge w_rst) begin
        if(!w_rst) begin
            w_addr <= 0;
        end
        else begin
            if (w_en & ~full_flag) begin
                if (w_addr == DEPTH - 1) begin
                    w_addr[ADDR_DEPTH-1:0] <= 0;
                    w_addr[ADDR_DEPTH] <= ~w_addr[ADDR_DEPTH];
                end
                else begin
                    w_addr <= w_addr + 1'b1;
                end
            end
        end
    end

    // assign full_flag = (w_ptr_gray[ADDR_DEPTH:ADDR_DEPTH-1] != r_ptr_sync[ADDR_DEPTH:ADDR_DEPTH-1]) 
    //                     && (w_ptr_gray[ADDR_DEPTH-2:0] == r_ptr_sync[ADDR_DEPTH-2:0]);
    assign full_flag = (w_ptr_gray[ADDR_DEPTH] != r_ptr_sync[ADDR_DEPTH]) 
                        && (w_ptr_gray[ADDR_DEPTH-1:0] == r_ptr_sync[ADDR_DEPTH-1:0]);


endmodule


// 000 
// 001
// 010

// 0 1 3 2
// 4 5 7 6
// 12 12 15 14
// 8 9 11 10

// 8 --- 1100
// 0 --- 0000
