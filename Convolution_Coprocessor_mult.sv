/*
module convolution_coprocessor_mult 
#(parameter DATA_WIDTH = 8)(
    input [DATA_WIDTH-1:0] A_i,
    input [DATA_WIDTH-1:0] B_i,
    output [DATA_WIDTH-1:0] A_and_B_o
);

    assign A_and_B_o = A_i * B_i;

endmodule*/

module convolution_coprocessor_mult 
#(
   parameter DATA_WIDTH = 8)
(
    input  [DATA_WIDTH-1 : 0] re_A,
	input  [DATA_WIDTH-1 : 0] re_B,
    output [DATA_WIDTH-1 : 0] re_out
);
	
	reg signed  [DATA_WIDTH -1: 0] temp_RA;
	reg signed  [DATA_WIDTH -1: 0] temp_RB;
	wire signed [DATA_WIDTH -1: 0] temp_RE;
	
	always@(re_A, re_B)
	begin
		temp_RA = re_A;
		temp_RB = re_B;
	end 
	
	assign temp_RE = temp_RA * temp_RB;
	
	assign re_out = temp_RE;
endmodule
