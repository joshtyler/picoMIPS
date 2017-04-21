//Memory component of registers

`include "constants.sv"

module regs_mem(input logic clk, logic `REG_SIZE d, logic `REG_ADDR_SIZE rd_addr, wr_addr, logic we, output logic `REG_SIZE q);

logic `REG_SIZE mem `REG_DEPTH_SIZE;

//We need to initialise the unity register at powerup.
//The values of other registers does not matter
//(The zero register is zeroed in software)
initial
	mem[`REG_U_ADDR] = 1;

always @(posedge clk)
begin
	if(we)
		mem[wr_addr] <= d;

	q <= mem[rd_addr]; //Note that q doesn't get d this clock cycle

end

endmodule
