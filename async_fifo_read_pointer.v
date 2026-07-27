`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2025 08:59:45 PM
// Design Name: 
// Module Name: async_fifo_read_pointer
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


module async_fifo_read_pointer #(
    parameter DEPTH = 100
)(
    input r_rst,
    input rclk,
    input r_en,
    input [$clog2(DEPTH):0] w_ptr_sync,
    output reg [$clog2(DEPTH):0] r_addr,
    output [$clog2(DEPTH):0] r_ptr_gray,
    output empty_flag
    );

    localparam ADDR_DEPTH = $clog2(DEPTH); // 7 Bits


    // reg [ADDR_DEPTH:0] w_addr_int;
    // assign w_addr = w_addr_int;
    b2g #(.WIDTH(ADDR_DEPTH)) b2g_r (.B(r_addr[ADDR_DEPTH-1:0]), .G(r_ptr_gray[ADDR_DEPTH-1:0]));
    assign r_ptr_gray[ADDR_DEPTH] = r_addr[ADDR_DEPTH];

    always @(posedge rclk, negedge r_rst) begin
        if(!r_rst) begin
            r_addr <= 0;
        end
        else begin
            if (r_en & ~empty_flag) begin
                if (r_addr == DEPTH - 1) begin
                    r_addr[ADDR_DEPTH-1:0] <= 0;
                    r_addr[ADDR_DEPTH] <= ~r_addr[ADDR_DEPTH];
                end
                else begin
                    r_addr <= r_addr + 1'b1;
                end
            end
        end
    end

    assign empty_flag = (r_ptr_gray == w_ptr_sync);

endmodule
