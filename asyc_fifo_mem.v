`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2025 08:59:45 PM
// Design Name: 
// Module Name: asyc_fifo_mem
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


module asyc_fifo_mem #(
    parameter DATA_WIDTH = 32, parameter DEPTH = 100
)(
    input w_rst, r_rst,
    input wclk, rclk,
    input [DATA_WIDTH-1:0] data_in,
    input [$clog2(DEPTH):0] w_addr, r_addr,
    input w_en,
    input r_en,
    output reg [DATA_WIDTH-1:0] data_out
    );

    localparam ADDR_DEPTH = $clog2(DEPTH); // 7 Bits

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    integer i;
    
    always @(posedge wclk, negedge w_rst) begin
        if(!w_rst) begin
            for (i = 0; i < DEPTH; i = i+1) begin
                mem[i] <= 0;
            end
        end
        else begin
            if (w_en) begin
                mem[w_addr[ADDR_DEPTH-1:0]] <= data_in;
            end
        end
    end

    always @(posedge rclk, negedge r_rst) begin
        if(!r_rst) begin
            data_out <= 0;
        end
        else begin
            if (r_en) begin
                data_out <= mem[r_addr[ADDR_DEPTH-1:0]];
            end
        end
    end

endmodule
