//ALU
`include "constants.sv"

module alu(input logic `REG_SIZE reg_1,reg_2 , input logic op_code, input logic `IMM_SIZE immediate, output logic `REG_SIZE wr_data, output logic branch);

//SUBLEQ signals
logic `REG_SIZE subleq_result;
logic subleq_branch;

//MULTI signals
logic `REG_SIZE multi_result;

//SUBLEQ instruction
subleq sub0
(
	.reg_1(reg_1),
	.reg_2(reg_2),
	.result(subleq_result),
	.branch(subleq_branch)
);

//MULTI instruction
multi multi0
(
	.register(reg_1),
	.immediate(immediate),
	.result(multi_result)
);

//Multiplexer to multiplex result and branch
multiplexer #(.WIDTH(`REG_WIDTH + 1 ))  multi_sub_out_mux
(
	.a( {subleq_branch, subleq_result} ),
	.b( {1'b0, multi_result} ),
	.sel(op_code),
	.out( {branch, wr_data} )
);

endmodule
