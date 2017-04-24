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

	if(result_tmp <= 0)
		branch = 1;
	else
		branch = 0;

	result = result_tmp[$high(result_tmp)-1 : 0];
end

endmodule
