`timescale 1ns / 1ps
module testbench;

    // Parámetros
    parameter DATA_WIDTH = 5;
    
    // Señales de entrada
    //logic [DATA_WIDTH-1:0] j_wire;
    
    // Señales de salida
    //logic [DATA_WIDTH-1:0] j_adder_wire;
    // Tamaño de las señales sizeY y sizeH
    localparam SIZE_Y_WIDTH = 5;
    localparam SIZE_H_WIDTH = 5;
    
    // Señales de entrada
    logic [SIZE_Y_WIDTH-1:0] sizeY;
    logic [SIZE_H_WIDTH-1:0] sizeH;
    
    // Señales de salida
    logic [DATA_WIDTH-1:0] sizeY_plus_sizeH_wire;
    // Instancia del módulo
    /*convolution_coprocessor_realAdder #(DATA_WIDTH) i_adder (
        .re_A(i_wire),
        .re_B(6'd1),
        .re_out(i_adder_wire)
    );*/
	
	/*convolution_coprocessor_realAdder
	#(.DATA_WIDTH(5))j_adder( 
		.re_A      (j_wire),
		.re_B      (5'd1),
		.re_out    (j_adder_wire)
	);*/
	
	convolution_coprocessor_realAdder
	#(.DATA_WIDTH(5))sizeZ_adder( 
		.re_A      (sizeY),
		.re_B      (sizeH),
		.re_out    (sizeY_plus_sizeH_wire)//sizeY + sizeH = sizeZ
	);

    // Inicialización de valores de entrada
    initial begin
        // Asignar un valor a la entrada i_wire
        //j_wire = 5'b101010; // Por ejemplo
		sizeY = 5'b10101;
		sizeH = 5'b01010;
        // Esperar algunos ciclos de reloj para la estabilidad
        #10;
        // Mostrar los valores de entrada y salida
        $display("sizeY = %b, sizeH = %b, sizeY_plus_sizeH = %b", sizeY, sizeH, sizeY_plus_sizeH_wire);
		//$display("j_wire = %b, j_adder_wire = %b", j_wire, j_adder_wire);
        // Finalizar la simulación
        $finish;
    end

endmodule
