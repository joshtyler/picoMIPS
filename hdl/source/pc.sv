//Program counter

`include "constants.sv"

module pc(input logic clk, reset, branch, input logic `CYCLE_SIZE cycle, input logic `PROG_MEM_ADDR_SIZE branch_addr, output logic `PROG_MEM_ADDR_SIZE addr);

logic `PROG_MEM_ADDR_SIZE ctr;
logic `PROG_MEM_ADDR_SIZE selected_addr;

logic `PROG_MEM_ADDR_SIZE new_ctr;

always_comb
	new_ctr = ctr + 1;

//Multiplexer to choose between next address or branch
multiplexer #(.WIDTH(`PROG_MEM_ADDR_WIDTH)) branch_mux
(
	.a(new_ctr),
	.b(branch_addr),
	.sel(branch),
	.out(selected_addr)
);

//Program counter
//Updates during exec cycle
//Async reset overrides everything
always @(posedge clk, posedge reset)
begin
	if(reset)
		ctr <= '0;
	else if(cycle[`CYCLE_EXEC])
		ctr <= selected_addr;
end

always_comb
	addr = ctr;

endmodule
