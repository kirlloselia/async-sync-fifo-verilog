`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/20/2025 12:20:17 PM
// Design Name: 
// Module Name: clk_divider_6
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


module clk_divider_6(
    input clk,
    input reset,
    output clk_6
    );
    reg [2:0] Q;
    assign clk_6 = Q[2];
    always @(posedge clk, negedge reset) begin
        if (!reset) begin
            Q <= 0;
        end
        else begin
            Q[0] <= ~Q[2];
            Q[1] <= Q[0];
            Q[2] <= Q[1];
        end
    end
endmodule
