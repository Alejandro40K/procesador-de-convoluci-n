/*module convolution_coprocessor_not
#(parameter DATA_WIDTH = 1)(
    input [DATA_WIDTH-1:0] A_i,
);

    assign not_A_o = !A_i;

endmodule


convolution_coprocessor_not indexH_greater_or_equal_to_zero_wire
(
    .A_i            (indexH_less_than_zero_wire), 
    .not_A_o        (indexH_greater_or_equal_to_zero_wire) 
);*/

module convolution_coprocessor_not #(
    parameter DATA_WIDTH = 1
)(
    input [DATA_WIDTH-1:0] A_i,
    output [DATA_WIDTH-1:0] not_A_o
);

    assign not_A_o = ~A_i;

endmodule
