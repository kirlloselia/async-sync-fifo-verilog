`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2025 09:00:53 PM
// Design Name: 
// Module Name: synchronizer_2ff
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


module synchronizer_2ff #(
    parameter WIDTH = 8
)(
    input clk,
    input reset,
    input [WIDTH-1:0] in,
    output reg [WIDTH-1:0] out
    );

    reg [WIDTH-1:0] unstable_out;
    always @(posedge clk, negedge reset) begin
        if (!reset) begin
            out <= 0;
            unstable_out <= 0;
        end 
        else begin
            unstable_out <= in;
            out <= unstable_out;
        end
    end
    
endmodule
