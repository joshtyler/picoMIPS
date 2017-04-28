//Memory component of registers
//Triple port

`include "constants.sv"

module regs_mem(input logic clk, input logic `REG_SIZE d, input logic `REG_ADDR_SIZE rd_addr1, rd_addr2, wr_addr, input logic we, output logic `REG_SIZE q1, q2);

logic `REG_SIZE mem `REG_DEPTH_SIZE;

//We need to initialise the unity register at powerup.
//The values of other registers does not matter
//(The zero register is zeroed in software)
//For simplicity therefore we initialise them all to the unity value
//Note that the unity value is NOT 1 because we need to account for the fact that immediates have lower significance
initial
	for(int i=0; i < `REG_DEPTH; i++)
		mem[i] = (1 << 3);

always @(posedge clk)
begin
	if(we)
		mem[wr_addr] <= d;

	q1 <= mem[rd_addr1]; //Note that q doesn't get d this clock cycle
	q2 <= mem[rd_addr2];

end

endmodule
