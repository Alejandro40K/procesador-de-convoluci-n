module convolution_coprocesor_fsm(	
    // Control FSM inputs
    input logic clk,
    input logic rstn,
    // Flow control FSM inputs
    input logic start,
    input logic comp_i_out,
    input logic comp_j_out,
    input logic comp_indexH_out,
    // FSM outputs
    output logic sel_j,
    output logic j_enable,
    output logic sel_i,
    output logic i_enable,
    output logic currentZ_en,
    output logic cunrrentZ_clr,
    output logic writeZ,
    output logic done,
    output logic busy
);

// State definition
typedef enum logic[3:0] {S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, XX = 'x} state_t;
// State register
state_t state, next;

// Sequential state transition
always_ff @(posedge clk or negedge rstn) begin
    if (!rstn)
        state <= S1;
    else
        state <= next;
end

// Combinational next state logic
always_comb begin
    next = XX;
    case (state)
        S1: begin
            if (start)
                next = S2;
            else
                next = S1;
        end
        S2: begin
            if (comp_i_out)
                next = S3;
            else if (comp_j_out)
                next = S7;
            else
                next = S11;
        end
        S3: next = S4;
        S4: begin
            if (comp_j_out)
                next = S7;
            else if (comp_indexH_out)
                next = S6;
            else
                next = S5;
        end
        S5: next = S6;
        S6: next = S7;
        S7: begin
            if (comp_indexH_out)
                next = S6;
            else if (comp_j_out)
                next = S7;
            else
                next = S8;
        end
        S8: next = S9;
        S9: next = S10;
        S10: if (comp_i_out)
                 next = S3;
              else
                 next = S11;
        S11: begin
                 if (comp_j_out)
                     next = S7;
                 else if (comp_indexH_out)
                     next = S6;
                 else
                     next = S12;
             end
        S12: begin
                 if (comp_i_out)
                     next = S3;
                 else
                     next = S13;
             end
        S13: next = S1;
        default: next = XX;
    endcase
end

// Registered output logic
always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        busy <= 1'b0;
    end else begin
        busy <= 1'b1;
        sel_j = 1'b0;
        j_enable = 1'b0;
        sel_i = 1'b0;
        i_enable = 1'b0;
        currentZ_en = 1'b0;
        cunrrentZ_clr = 1'b0;
        writeZ = 1'b0;
        done = 1'b0;
        case (state)
            S1: begin
                     busy = 1'b0;
                 end
            S2: begin
                     sel_i = 1'b1;
                     i_enable = 1'b1;
                 end
            S4: begin
                     cunrrentZ_clr = 1'b1;
                     sel_j = 1'b1;
                     j_enable = 1'b1;
                 end
            S6: begin
                     currentZ_en = 1'b1;
                 end
            S7: begin
                     j_enable = 1'b1;
                 end
            S8: begin
                     i_enable = 1'b1;
                     writeZ = 1'b1;
                 end
            S11: begin
                      busy = 1'b0;
                      done = 1'b1;
                  end
            S13: begin
                      busy = 1'b0;
                  end
            default: begin
                           busy = 1'b0;
                      end
        endcase
    end
end

endmodule

/*module convolution_coprocesor_fsm(	
	//ctrl FSM inputs
	input logic clk,
	input logic rstn,
	//flow ctrl FSM inputs
	input logic start,
	input logic comp_i_out,
	input logic comp_j_out,
	input logic comp_indexH_out,
	//FSM output
	output logic sel_j,
	output logic j_enable,
	output logic sel_i,
	output logic i_enable,
	output logic currentZ_en,
	output logic cunrrentZ_clr,
	output logic writeZ,
	output logic done,
	output logic busy
);

//state definition
typedef enum logic[3:0] {S1,S2,S4,S6,S7,S8,S10,S11,S13, XX = 'x} state_t;
//typed definition
state_t state;
state_t next;

//(1)Sate register (sequential side)
always_ff@(posedge clk or negedge rstn)
	if(!rstn) state <= S1;
	else state <= next;
//(2)Convinational next state logic
always_comb begin
	next = XX;
	unique case(state)
		S1: if(start) next = S2;
			else next = S1;
		S2: if(comp_i_out)next = S4;
			else next = S11;
		S4: begin
			if(!comp_j_out) next = S8;
			else
				if(comp_indexH_out) next = S6;
				else next = S7;
		end
		S6: next = S7;
		S7: begin
			if(!comp_j_out) next = S8;
			else
				if(comp_indexH_out) next = S6;
				else next = S7;
		end
		S8: next = S10;
		S10: if (comp_i_out) next = S4;
			 else next = S11;
		S11: next = S13;
		S13: next = S1;
		default: next = XX;
	endcase
end

//(3) Registered output logic
always_ff@(posedge clk or negedge rstn) begin
	if(!rstn) begin
		busy <=1'b0;
	end
	else begin
		//busy <=1'b0;
		//default values
		sel_j <= 1'b0;
		j_enable <= 1'b0;
		sel_i  <= 1'b0;
		i_enable  <= 1'b0;
		currentZ_en  <= 1'b0;
		cunrrentZ_clr  <= 1'b0;
		writeZ  <= 1'b0;
		done  <= 1'b0;
		busy  <= 1'b1;
	    casez(next)
			S1:	busy  <= 1'b0;
			S2: begin
			sel_i <= 1'b1;
					i_enable  <= 1'b1;
				end
			S4: begin
				cunrrentZ_clr  <= 1'b1;
				sel_j  <= 1'b1;
				j_enable  <= 1'b1;
				end
			S6:		currentZ_en  <= 1'b1;
			S7:		j_enable  <= 1'b1;
			S8: begin
					i_enable  <= 1'b1;
					writeZ  <= 1'b1;
				end 
			S10:  ;
			S11: begin
					busy  <= 0;
					done  <= 1;
				end
			S13: busy  <= 0;
		endcase
	end
end
	
*/