//MULTI (Multiply immediate) operation
//MSB of immediate is -2^0, LSB is 2^-3
//MSB of register is -2^2, lSB is 2^0
`include "constants.sv"

module multi(input logic signed `REG_SIZE register, input logic signed `IMM_SIZE immediate, output logic signed `REG_SIZE result);

localparam EXTENDED_WORD_WIDTH = `REG_WIDTH + `IMM_WIDTH -1; //This is one less than the comibined widths because 2^0 is shared between the two numbers
logic signed [EXTENDED_WORD_WIDTH-1 : 0] x,y;
logic signed [(2*EXTENDED_WORD_WIDTH)-1 : 0] z;

localparam REGISTER_SHIFT = `IMM_WIDTH -1; //4

localparam RESULT_OFFSET = 2*REGISTER_SHIFT -1; //7

always_comb
begin
	x = immediate; //We can assign this directly because the LSBs align
	y = (register << REGISTER_SHIFT); //This needs to be shifted

	z = x * y;

	result = z[ (RESULT_OFFSET + `REG_WIDTH) : RESULT_OFFSET];
end

endmodule
