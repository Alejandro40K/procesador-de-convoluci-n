`timescale 1ns / 1ps

module convolution_coprocessor_TOP_TB;

parameter DATA_WIDTH_MEMY = 8;
parameter ADDR_WIDTH_MEMY = 5;
parameter DATA_WIDTH_MEMZ = 16;
parameter ADDR_WIDTH_MEMZ = 6;

logic clk = 1'b0;
logic rstn;
wire [7:0] dataY;
logic [4:0] sizeY;
logic start;
wire [4:0] memY_addr;
wire [15:0] dataZ;
wire [5:0] memZ_addr;
wire writeZ;
wire busy;
wire done;
wire [DATA_WIDTH_MEMZ-1:0] dataZ_read;

//convolution_coprocessor_top instance

convolution_coprocessor_top DUT(
	.clk(clk),
	.rstn(rstn),
	
	.dataY(dataY),
	.sizeY(sizeY),
	.start(start),
	
	.memY_addr(memY_addr),
	.dataZ(dataZ),
	.memZ_addr(memZ_addr),
	.writeZ(writeZ),
	.busy(busy),
	.done(done)
);

//memory Y instance 

simple_dual_port_ram_single_clk_sv #(
	.DATA_WIDTH(DATA_WIDTH_MEMY),
	.ADDR_WIDTH(ADDR_WIDTH_MEMY),
	.TXT_FILE("C:/Users/T480/Desktop/sim/MEMORY_Y.txt")
)MemoryY(
	.clk(clk),
	.write_en_i(1'b0),
	.write_addr_i(5'b0),
	.read_addr_i(memY_addr),
	.write_data_i(8'b0),
	.read_data_o(dataY)
);

//Memory Z coprocesor instance


simple_dual_port_ram_single_clk_sv #(
	.DATA_WIDTH(DATA_WIDTH_MEMZ),
	.ADDR_WIDTH(ADDR_WIDTH_MEMZ),
	.TXT_FILE("C:/Users/T480/Desktop/sim/MEMORY_Z.txt")
)MemoryZ(
	.clk(clk),
	.write_en_i(writeZ),
	.write_addr_i(memZ_addr),
	.read_addr_i(6'b0),
	.write_data_i(dataZ),
	.read_data_o(dataZ_read)
);


//reloj e inicializacion

always #5ns clk = ~clk;
initial begin
	sizeY = 5'd5;
	rstn = 1'b1;
	start = 1'b0;
	#10ns;
	rstn = 1'b0;
	#10ns;
	rstn = 1'b1;
	#10ns;
	start = 1'b1;
end
endmodule

