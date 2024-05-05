module convolution_coprocessor_and 
#(parameter DATA_WIDTH = 1)(
    input [DATA_WIDTH-1:0] A_i,
    input [DATA_WIDTH-1:0] B_i,
    output [DATA_WIDTH-1:0] A_and_B_o
);

    assign A_and_B_o = A_i & B_i;

endmodule
