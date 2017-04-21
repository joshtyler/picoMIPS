//Program counter

`include "constants.sv"

module pc(input logic clk, reset, branch, logic `CYCLE_SIZE cycle, logic `PROG_MEM_ADDR_SIZE branch_addr, output logic `PROG_MEM_ADDR_SIZE addr);

logic `PROG_MEM_ADDR_WIDTH ctr;

//Program counter
always @(posedge clk, posedge reset) //Reset
begin
	if(reset)
		ctr <= '0;
	else if(cycle == `CYCLE_INC)
		ctr <= ctr + 1;
end

//Multiplexer to choose between next address or branch
//Note that this can be combinational since branch is only true in the increment cycle
multiplexer #(.WIDTH(`PROG_MEM_ADDR_WIDTH)) multiplexer0
(
	.a(ctr),
	.b(branch_addr),
	.sel(branch),
	.out(addr)
);

endmodule
