/****************************************************************
* Descripcion: Archivo Top del coprocesador de convolucion, P2
*
* Autor: Alejandro Orozco Romo
* email: TAE2024.26@cinvestav.mx
* Fecha: 03/05/2024
****************************************************************/
//Declaracion del Modulo TOP




module convolution_coprocessor_top(
	//entradas de control:
	input  logic        clk,
	input  logic        rstn,
	//entradas del coprocesador de convolucion:
	input  logic [7:0]  dataY,
	input  logic [4:0]  sizeY,
	input  logic        start,
	//salidas del coprocesador:
	output logic [4:0]  memY_addr,
	output logic [15:0] dataZ,
	output logic [5:0]  memZ_addr,
	output logic        writeZ,
	output logic        busy,
	output logic        done
);

//definimos constantes 
`define SIZE_MEM_H 5'd3

//definimos parametros
parameter DATA_WIDTH_ADDERS    = 6;
parameter DATA_WIDTH_COUNTERS  = 6;
parameter DATA_WIDTH_MEMH      = 8;
parameter ADDR_WIDTH_MEMH      = 5;
parameter DATA_WIDTH_MEMZ      = 16;
parameter ADDR_WIDTH_MEMZ      = 6;

//Cables (wires) de la Maquina de Estados
wire comp_i_out_wire;
wire comp_j_out_wire;
wire comp_indexH_out_wire;
wire sel_j_wire;
wire j_enable_wire;
wire sel_i_wire;
wire i_enable_wire;
wire currentZ_en_wire;
wire cunrrentZ_clr_wire;

//i counter wires
wire [DATA_WIDTH_COUNTERS-1:0] i_wire;
wire [5:0] i_adder_wire;
wire [5:0] i_mux_wire;

//j conuter wires
wire [4:0] j_wire; //wire [DATA_WIDTH_COUNTERS-1:0] i_wire;
wire [4:0] j_adder_wire;
wire [4:0] j_mux_wire;

//sizeZ wires
wire [4:0] sizeH;
assign sizeH = 5'd3;
wire [4:0] sizeY_plus_sizeH_wire;
wire [4:0] sizeZ_wire;

//sizeH wires (se equivoco el compañero, puso Z en bes de H, lo corregi)
wire [5:0] i_minus_j_wire;//[5:0]

//indexH wire (bloque AND, NOR, y comparador)
wire indexH_less_than_sizeH_wire;
wire indexH_less_than_zero_wire;
wire indexH_greater_or_equal_to_zero_wire;

//MemoryH wires
wire [DATA_WIDTH_MEMH-1:0] dataH;

//CurrentZ wires
wire [DATA_WIDTH_MEMZ-1:0] dataH_times_dataY_wire;
wire [DATA_WIDTH_MEMZ-1:0] currentZ_sum_wire;

/****************************************************************
* Instancia FSM 
****************************************************************/
convolution_coprocesor_fsm FSM(
	.clk(clk),
	.rstn(rstn),
	
	.start(start),
	.comp_i_out(comp_i_out_wire),
	.comp_j_out(comp_j_out_wire),
	.comp_indexH_out(comp_indexH_out_wire),
	
	.sel_j(sel_j_wire),
	.j_enable(j_enable_wire),
	.sel_i(sel_i_wire),
	.i_enable(i_enable_wire),
	.currentZ_en(currentZ_en_wire),
	.cunrrentZ_clr(cunrrentZ_clr_wire),
	
	.writeZ(writeZ),
	.done(done),
	.busy(busy)
);


/****************************************************************
* Instancia i counter 
****************************************************************/

convolution_coprocessor_realAdder
#(.DATA_WIDTH(6))i_adder( 
    .re_A      (i_wire),
    .re_B      (6'd1),
    .re_out    (i_adder_wire)
);

convolution_coprocessor_mux
#(.DATA_WIDTH(6))i_mux( 
    .re_A      (i_adder_wire),
    .re_B      (6'd0),
	.sel       (sel_i_wire),
    .re_out    (i_mux_wire)
);

convolution_coprocessor_register 
#(.DATA_WIDTH (6))i_reg(
    .clk     (clk),
    .rstn    (rstn),
    .clrh    (1'b0),   
    .enh     (i_enable_wire),
    .data_i  (i_mux_wire),
    .data_o  (i_wire)
);



/****************************************************************
* Instancia j counter 
****************************************************************/

convolution_coprocessor_realAdder
#(.DATA_WIDTH(5))j_adder( 
    .re_A      (j_wire),
    .re_B      (5'd1),
    .re_out    (j_adder_wire)
);

convolution_coprocessor_mux
#(.DATA_WIDTH(5))j_mux( 
    .re_A      (j_adder_wire),
    .re_B      (5'd0),
	.sel       (sel_j_wire),
    .re_out    (j_mux_wire)
);

convolution_coprocessor_register 
#(.DATA_WIDTH (5))j_reg(
    .clk     (clk),
    .rstn    (rstn),
    .clrh    (1'b0),   
    .enh     (j_enable_wire),
    .data_i  (j_mux_wire),
    .data_o  (j_wire)
);
/****************************************************************
* sizeZ calculation instance
****************************************************************/
convolution_coprocessor_realAdder
#(.DATA_WIDTH(5))sizeZ_adder( 
    .re_A      (sizeY),
    .re_B      (sizeH),
    .re_out    (sizeY_plus_sizeH_wire)//sizeY + sizeH = sizeZ
);
//para mejorar, intercambiar el realAdder(que funge como sub)//cambiar por bloque aritmetico complex substractor
convolution_coprocessor_sub
#(.DATA_WIDTH(5))sizeZ_substractor( 
    .re_A      (sizeY_plus_sizeH_wire),
    .re_B      (5'b1_1111),
    .re_out    (sizeZ_wire)//sizeZ=sizeY + sizeH -1 
);

/****************************************************************
* (i - j) instance
****************************************************************/

convolution_coprocessor_sub
#(.DATA_WIDTH(6))i_minus_j( 
    .re_A      (i_wire),
    .re_B      ({1'b0,j_wire}),
    .re_out    (i_minus_j_wire)//j-i
);

// USAMOS BLOQUES DE ARITMETIC comparador_less_than
/****************************************************************
* i comparator instance
****************************************************************/
convolution_coprocessor_comparatorLessThan 
#(.DATA_WIDTH(6))i_comp(
    .A_i            (i_mux_wire), //A_i, sin .
    .B_i            ({1'b0, sizeZ_wire}), 
    .A_less_than_B_o(comp_i_out_wire)
);

/****************************************************************
* j comparator instance
****************************************************************/
convolution_coprocessor_comparatorLessThan 
#(.DATA_WIDTH(5))j_comp(
    .A_i            (j_mux_wire),
    .B_i            (sizeY), 
    .A_less_than_B_o(comp_j_out_wire)
);

/****************************************************************
* comparator indexh (memH_addr) instance
****************************************************************/
convolution_coprocessor_comparatorLessThan 
#(.DATA_WIDTH(6))indexH_less_than_sizeH(
    .A_i            (i_minus_j_wire), 
	//.B_i            (sizeH), 
    .B_i          ({1'b0,sizeH}), 
    .A_less_than_B_o (indexH_less_than_sizeH_wire)//convertir a mis porpios comparadores
);

convolution_coprocessor_comparatorLessThan 
#(.DATA_WIDTH(6))indexH_less_than_zero(///<-
    .A_i            (i_minus_j_wire), 
    .B_i            (6'd0), 
    .A_less_than_B_o(indexH_less_than_zero_wire)//convertir a mis porpios comparadores
);

/////CAMBIAR comparador
convolution_coprocessor_not indexH_greater_or_equal_to_zero(
    .A_i            (indexH_less_than_zero_wire), 
    .not_A_o        (indexH_greater_or_equal_to_zero_wire) 
);
convolution_coprocessor_and indexH //pasamos las "salidas del comparador y not, en mi caso falta el not
(
    .A_i            (indexH_less_than_sizeH_wire), 
	.B_i            (indexH_greater_or_equal_to_zero_wire), 
    .A_and_B_o      (comp_indexH_out_wire)//esta es una de los cables de salida, definir en mi diagrama 
);

/****************************************************************
* MemoryH "ROM" instance, usar RAM, como vace
****************************************************************/
convolution_coprocessor_simple_rom_sv
#(.DATA_WIDTH(DATA_WIDTH_MEMH),
  .ADDR_WIDTH(ADDR_WIDTH_MEMH),  //... FALTA INSTANCIAR ROM
  .TXT_FILE("C:/Users/T480/Desktop/sim/MEMORY_H.txt")
  
) MemoryH (
  .clk(clk),
  .read_addr_i(i_minus_j_wire[4:0]),//Corregir
  .read_data_o(dataH)
);  //revisar el numero de fila para coincidir


///CREO QUE YA EST ABIEN, REVISAR A POSTERIORI
/****************************************************************
* currentZ, aqui cambia la cosa
falta adaptar a mi codigo

En base a CurrentZ, podemos inferir La rom//pasamos las "salidas del comparador y not, en mi caso falta el not
****************************************************************/
convolution_coprocessor_mult 
#(.DATA_WIDTH(DATA_WIDTH_MEMH)) currentZ_mult(
    .re_A            (dataH), 
	.re_B            (dataY), 
    .re_out          (dataH_times_dataY_wire) 
);

convolution_coprocessor_realAdder //pasamos las "salidas del comparador y not, en mi caso falta el not
#(.DATA_WIDTH(DATA_WIDTH_MEMZ)) currentZ_sum(
    .re_A            (dataH_times_dataY_wire), 
	.re_B            (dataZ), 
    .re_out          (currentZ_sum_wire) 
);


convolution_coprocessor_register 
#(.DATA_WIDTH (DATA_WIDTH_MEMZ))currentZ_reg(
    .clk     (clk),
    .rstn    (rstn),  
    .clrh    (cunrrentZ_clr_wire),   
    .enh     (currentZ_en_wire),
    .data_i  (currentZ_sum_wire),
    .data_o  (dataZ)
);
/****************************************************************
* MemoryZ and Memory Y addres conection
****************************************************************/

assign memY_addr = j_wire;
assign memZ_addr = i_wire;

endmodule 



