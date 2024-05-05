`timescale 1ns / 1ps

module tb_i_counter();

    // Señales de entrada
    logic clk;
    logic rstn;
    logic [5:0] i_mux_wire;
    logic sel_i_wire;
    logic i_enable_wire;
    logic [5:0] i_wire;

    // Instancia del i counter
    convolution_coprocessor_realAdder #(.DATA_WIDTH(6)) i_adder( 
        .re_A      (i_wire),
        .re_B      (6'd1),
        .re_out    (i_mux_wire)
    );

    convolution_coprocessor_mux #(.DATA_WIDTH(6)) i_mux( 
        .re_A      (i_mux_wire),
        .re_B      (6'd0),
	    .sel       (sel_i_wire),
        .re_out    (i_adder_wire)
    );

    convolution_coprocessor_register #(.DATA_WIDTH(6)) i_reg(
        .clk     (clk),
        .rstn    (rstn),
        .clrh    (1'b0),   
        .enh     (i_enable_wire),
        .data_i  (i_adder_wire),
        .data_o  (i_wire)
    );

    // Estímulo de entrada
    initial begin
        // Inicializa las señales de entrada
        clk = 0;
        rstn = 1;
        sel_i_wire = 0;
        i_enable_wire = 1;

        // Ciclo de reloj
        forever #5 clk = ~clk;
    end

    // Monitor de señales de salida y verificación
    always @(posedge clk) begin
        $display("i_wire: %h", i_wire);
    end

    // Estímulos adicionales
    initial begin
        // Cambia sel_i_wire y rstn después de un tiempo
        #100;
        sel_i_wire = 1;
        #100;
        sel_i_wire = 0;
        #100;
        rstn = 0;
        #100;
        rstn = 1;
        // Continúa simulando
        #1000;
        $finish;
    end
    
endmodule
