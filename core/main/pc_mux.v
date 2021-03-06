`include "param_pc_mux.vh"

module pc_mux (
	input [31 : 0] pc,	
	input [31 : 0] rs1, // from decoder
	input [31 : 0] imm, // from decoder
	input [`SEL_PC_WIDTH - 1 : 0] pc_sel, // from decode
	input taken, // from br_cond
	input stall, // from controller
	input [31 : 0] mtvec,
	input [31 : 0] mepc,
	output reg [31 : 0] next_pc
);


	always @(*) begin
		if (stall) begin // stall
			next_pc = pc;
		end else if (taken) begin // branch is taken
			next_pc = pc + imm;
		end else begin
			case (pc_sel)
				`SEL_PC_JAL  : next_pc = pc + imm; // jump and link
				`SEL_PC_JALR : next_pc = rs1 + imm; // jump and link register
				`SEL_PC_ADD4 : next_pc = pc + 32'h4; // +4
				`SEL_PC_MTVEC : next_pc = mtvec;
				`SEL_PC_MEPC  : next_pc = mepc;
				`SEL_PC_NONE : next_pc = 32'h0;
			endcase // pc_sel
		end
	end // always @(*)
	
	
endmodule // pc_mux
