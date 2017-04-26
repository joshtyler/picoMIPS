//SUBLEQ operation
//Subtract and branch if less than or equal to zero
//Result = reg2 - reg1

`include "constants.sv"

module subleq(input logic signed `REG_SIZE reg_1, reg_2, output logic signed `REG_SIZE result, output logic branch);

//Note we must do arithmetic one bit wider than the input.
//This is because 0-0x80 = 0x80, and so a branch will mistakenly generated

logic [`REG_WIDTH:0] result_tmp; // `REG_WIDTH makes it one bit wider than reg_1 and reg_2


always_comb
begin
	result_tmp = reg_2 - reg_1;
	result = result_tmp[$high(result_tmp)-1 : 0];
end


//Instantiate multiplier. This to save on logic elements
//Checking if the result is less than or equal to zero takes 3 LEs
//This multiplier should be able to do it in 1 multiplier
// -1 * 0 = 0
// -1 * [negative] = positive
// Therefore calculate -1 * result and branch if not positive

logic [2*(`REG_WIDTH + 1)-1:0] mult_out;

always_comb
	branch = ! mult_out[$high(mult_out)];


lpm_mult lpm_mult_component (
	.dataa ({(`REG_WIDTH+1){1'b1}}),
	.datab (result_tmp),
	.result (mult_out),
	.aclr (1'b0),
	.clken (1'b1),
	.clock (1'b0),
	.sum (1'b0));

defparam
	lpm_mult_component.lpm_hint = "DEDICATED_MULTIPLIER_CIRCUITRY=YES,MAXIMIZE_SPEED=5",
	lpm_mult_component.lpm_representation = "SIGNED",
	lpm_mult_component.lpm_type = "LPM_MULT",
	lpm_mult_component.lpm_widtha = (`REG_WIDTH + 1),
	lpm_mult_component.lpm_widthb = (`REG_WIDTH + 1),
	lpm_mult_component.lpm_widthp = 2*(`REG_WIDTH + 1);

endmodule
