/*	
   ===================================================================
   Module Name  : Multiplexor N to 1
      
   Filename     : muxNto1.v
   Type         : Verilog Module
   
   Description  : Parametrizable multiplexor 
                  The number of inputs must be power of two!
                  
                  -data_i signal distribution:
                     
                  data_i  [                      DATA_WIDTH-1:0] -> input 0
                  data_i  [         (2*DATA_WIDTH)-1:DATA_WIDTH] -> input 1
                  data_i  [     (3*DATA_WIDTH)-1:(2*DATA_WIDTH)] -> input 2
                  ...
                  data_i  [ (N*DATA_WIDTH)-1:((N-1)*DATA_WIDTH)] -> input N-1
               * where  N = (2^SEL_WIDTH)
   -----------------------------------------------------------------------------
   Clocks      : -
   Reset       : -
   Parameters  :   
         NAME                         Comments                   Default
         ------------------------------------------------------------------------------
         SEL_WIDTH               Number bits for mux selector        2
         DATA_WIDTH              Number of data bits                33 
         ------------------------------------------------------------------------------
   Version     : 1.0
   Data        : 14 Nov 2018
   Revision    : -
   Reviser     : -		
   ------------------------------------------------------------------------------
      Modification Log "please register all the modifications in this area"
      (D/M/Y)  
      
   ----------------------
   // Instance template
   ----------------------
   muxNto1 
   #(
      .DATA_WIDTH   (),
      .SEL_WIDTH    ("ceil_log2(N)")
   )
   "MODULE_NAME"
   (
      .sel_i    (),
      .data_i   ({
                     ,  // I:N-1
                     ,  // I: ...
                     ,  // I:1
                       // I:0
                     }),
      .data_o   ()
   );



module muxNto1 
#(
	parameter  DATA_WIDTH   = 'd1,
    parameter  SEL_WIDTH    = 'd1
)(
    //-------------ctrl signals---------------//
    input   wire [   SEL_WIDTH -1                  :0 ]  sel_i,
    //-------------data/addr signals-----------//
    input   wire [( (2**SEL_WIDTH) *DATA_WIDTH)-1  :0 ]  data_i,
    output  wire [             DATA_WIDTH-1        :0 ]  data_o
);

// -----------------------------------------------------------

localparam NUM_INPUTS = 2**SEL_WIDTH;

genvar i;
    
wire [DATA_WIDTH-1:0] input_wire [0:NUM_INPUTS-1];

assign  data_o = input_wire[sel_i];

//conections to input wire
generate
    for(i=0; i<NUM_INPUTS; i=i+1) begin: assignements
    
        assign  input_wire[i] = data_i[(i*DATA_WIDTH)+:DATA_WIDTH];
        
    end
endgenerate

endmodule

module convolution_coprocessor_mux
#(
    parameter DATA_WIDTH = 6
)(
    input  [DATA_WIDTH-1 : 0] re_A,
    input  [DATA_WIDTH-1 : 0] re_B,
    input  sel,
    output [DATA_WIDTH-1 : 0] re_out
);

    assign re_out = sel ? re_A : re_B;

endmodule*/

module convolution_coprocessor_mux #(
    parameter DATA_WIDTH = 1,
    parameter SEL_WIDTH = 1
)(
    // Señales de entrada y salida
    input wire [DATA_WIDTH-1:0] re_A,
    input wire [DATA_WIDTH-1:0] re_B,
    input wire [SEL_WIDTH-1:0] sel,
    output wire [DATA_WIDTH-1:0] re_out
);

localparam NUM_INPUTS = 2 ** SEL_WIDTH;
wire [DATA_WIDTH-1:0] input_wire [0:NUM_INPUTS-1];

genvar i;

assign re_out = input_wire[sel];

// Conexiones a la entrada de los cables
generate
for (i = 0; i < NUM_INPUTS; i = i + 1) begin: assignements
    assign input_wire[i] = (i == 0) ? re_B : re_A;
end
endgenerate

endmodule

