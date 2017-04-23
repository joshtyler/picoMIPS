//SUBLEQ operation
//Subtract and branch if less than or equal to zero
//Result = reg2 - reg1

`include "constants.sv"

module subleq(input logic signed `REG_SIZE reg_1, reg_2, output logic signed `REG_SIZE result, output logic branch);

always_comb
begin
	result = reg_2 - reg_1;

	if(result < 0)
		branch = 1;
	else
		branch = 0;
end

endmodule
