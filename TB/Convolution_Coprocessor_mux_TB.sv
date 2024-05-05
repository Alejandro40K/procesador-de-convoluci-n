`timescale 1ns / 1ps

module MUX_testbench;

    // Parámetros
    parameter DATA_WIDTH = 6;

    // Señales de entrada
    logic [DATA_WIDTH-1:0] i_adder_wire;
    logic sel_i_wire;

    // Señal de salida
    logic [DATA_WIDTH-1:0] i_mux_wire;

	convolution_coprocessor_mux
	#(.DATA_WIDTH(DATA_WIDTH)) i_mux( 
		.re_A      (i_adder_wire),
		.re_B      (6'd0),
		.sel       (sel_i_wire),
		.re_out    (i_mux_wire)
	);

    // Inicialización de valores de entrada
    initial begin
        // Asignar un valor a la entrada i_adder_wire
        i_adder_wire = 6'b101010; // Por ejemplo
        // Asignar un valor a la señal de selección sel_i_wire
        sel_i_wire = 1'b0; // Por ejemplo
        // Esperar algunos ciclos de reloj para la estabilidad
        #10;
        // Mostrar los valores de entrada y salida
        $display("i_adder_wire = %b, sel_i_wire = %b, i_mux_wire = %b", i_adder_wire, sel_i_wire, i_mux_wire);
        // Finalizar la simulación
        $finish;
    end

endmodule

