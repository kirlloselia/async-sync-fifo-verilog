`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2025 12:40:30 PM
// Design Name: 
// Module Name: FIFO_SYNC
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

// this is SYNC FIFO, with single clock source, but divided F_Tx = 60Mhz, F_Rx = 10Mhz
// this is using internal pointers school
// with burst = 120

module FIFO_SYNC
#(
    //parameter DATA_WIDTH = 1, parameter DEPTH = 2
    parameter DATA_WIDTH = 32, parameter DEPTH = 100
)(
    input reset,
    input clk,
    input [DATA_WIDTH-1:0] data_in,
    input w_en,
    input r_en,
    output reg [DATA_WIDTH-1:0] data_out,
    output full_flag,
    output empty_flag
    );

    localparam ADDR_DEPTH = $clog2(DEPTH); // 7 Bits

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    reg [ADDR_DEPTH:0] w_ptr, r_ptr; // 8bits added a wrap bit for flags

    wire w_clk, r_clk;
//    wire w_clk;
//    reg r_clk;
    assign w_clk = clk;
    
    integer i;
    
    clk_divider_6 dut (.clk(clk), .reset(reset), .clk_6(r_clk));
//    always @(posedge w_clk, negedge reset) begin
//        if(!reset) begin
//            r_clk <= 0;
//        end
//        else begin
//            r_clk <= ~r_clk;
//        end
//    end

    always @(posedge w_clk, negedge reset) begin
        if(!reset) begin
            w_ptr <= 0;
            for (i = 0; i < DEPTH; i = i+1) begin
                mem[i] <= 0;
            end
        end
        else begin
            if (w_en & ~full_flag) begin
                mem[w_ptr[ADDR_DEPTH-1:0]] <= data_in;
                if (w_ptr == DEPTH - 1) begin
                    w_ptr[ADDR_DEPTH-1:0] <= 0;
                    w_ptr[ADDR_DEPTH] <= ~w_ptr[ADDR_DEPTH];
                end
                else begin
                    w_ptr <= w_ptr + 1'b1;
                end
            end
        end
    end

    always @(posedge r_clk, negedge reset) begin
        if(!reset) begin
            r_ptr <= 0;
        end
        else begin
            if (r_en & ~empty_flag) begin               // why this condition (if ~em_fl) evaluates to true @ rising edge while em_fl is going to be deasserted @ this edge? 
                                                       // because of using CLK EN in the FF, where the en sig is the condition
                data_out <= mem[r_ptr[ADDR_DEPTH-1:0]];
                if (r_ptr == DEPTH - 1) begin
                    r_ptr[ADDR_DEPTH-1:0] <= 0;
                    r_ptr[ADDR_DEPTH] <= ~r_ptr[ADDR_DEPTH];
                end
                else begin
                    r_ptr <= r_ptr + 1'b1;
                end
            end
        end
    end
    assign full_flag = (w_ptr[ADDR_DEPTH] != r_ptr[ADDR_DEPTH]) && (w_ptr[ADDR_DEPTH-1:0] == r_ptr[ADDR_DEPTH-1:0]);
	assign empty_flag = (w_ptr == r_ptr);

endmodule
