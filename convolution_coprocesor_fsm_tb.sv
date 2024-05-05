`timescale 1ns / 1ps

module convolution_coprocesor_fsm_tb;

    // Parámetros
    parameter CLK_PERIOD = 10; // Periodo de reloj en ns

    // Entradas
    logic clk;
    logic rstn;
    logic start;
    logic comp_i_out;
    logic comp_j_out;
    logic comp_indexH_out;

    // Salidas
    logic sel_j;
    logic j_enable;
    logic sel_i;
    logic i_enable;
    logic currentZ_en;
    logic cunrrentZ_clr;
    logic writeZ;
    logic done;
    logic busy;

    // Instancia de la FSM
    convolution_coprocesor_fsm dut (
        .clk(clk),
        .rstn(rstn),
        .start(start),
        .comp_i_out(comp_i_out),
        .comp_j_out(comp_j_out),
        .comp_indexH_out(comp_indexH_out),
        .sel_j(sel_j),
        .j_enable(j_enable),
        .sel_i(sel_i),
        .i_enable(i_enable),
        .currentZ_en(currentZ_en),
        .cunrrentZ_clr(cunrrentZ_clr),
        .writeZ(writeZ),
        .done(done),
        .busy(busy)
    );

    // Generación de reloj
    always #((CLK_PERIOD / 2)) clk = ~clk;

    // Inicialización de señales
    initial begin
        clk = 0;
        rstn = 0;
        start = 0;
        comp_i_out = 0;
        comp_j_out = 0;
        comp_indexH_out = 0;
        #100; // Espera inicial
        rstn = 1; // Liberar el reset
        #100; // Espera después de liberar el reset

        // Establecer condiciones para cada estado de la FSM
        // Ejemplo: Simulación del estado S1
        // Puedes continuar con cada estado de la FSM de manera similar
        $display("Testbench: Estado S1");
        start = 1;
        #10;
        start = 0;
        comp_i_out = 1;
        #10;
        comp_i_out = 0;
        // Continuar con las condiciones de los demás estados
    end

    // Verificación
    always @(posedge clk) begin
        if (done) begin
            $display("Testbench: FSM completada exitosamente.");
            $finish;
        end
        // Agrega condiciones de verificación adicionales según sea necesario
    end

endmodule
