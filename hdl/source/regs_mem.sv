//Memory component of registers
//Dual port

`include "constants.sv"

module regs_mem(input logic clk, input logic `REG_SIZE d, input logic `REG_ADDR_SIZE addr1, addr2, input logic we2, output logic `REG_SIZE q1, q2);

logic `REG_SIZE mem `REG_DEPTH_SIZE;

//We need to initialise the unity register at powerup.
//The values of other registers does not matter
//(The zero register is zeroed in software)
//For simplicity therefore we initialise them all to the unity value
//Note that the unity value is NOT 1 because we need to account for the fact that immidiates have lower significance
initial
	for(int i=0; i < `REG_DEPTH; i++)
		mem[i] = (1 << 3);

//Port A (Read only)
always @(posedge clk)
begin

	q1 <= mem[addr1];

end

//Port B (Read/write)
//Follows template
always @(posedge clk)
begin
	if(we2)
		mem[addr2] <= d;

	q2 <= mem[addr2]; //Note that q doesn't get d this clock cycle

end

endmodule
