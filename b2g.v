module b2g #(
    parameter WIDTH = 4
) (
    input [WIDTH-1:0] B,
    output [WIDTH-1:0] G
);
    assign G[WIDTH-1] = B[WIDTH-1];

    genvar k;
    generate
        for (k = 0; k < WIDTH-1; k = k+1) begin: gray
            assign G[k] = B[k] ^ B[k+1];
        end
    endgenerate 
endmodule