//Program counter

`include "constants.sv"

module pc(input logic branch, input logic `PROG_MEM_ADDR_SIZE branch_addr, nml_addr, output logic `PROG_MEM_ADDR_SIZE addr);


//Multiplexer to choose between next address or branch
multiplexer #(.WIDTH(`PROG_MEM_ADDR_WIDTH)) branch_mux
(
	.a(nml_addr),
	.b(branch_addr),
	.sel(branch),
	.out(addr)
);


endmodule
