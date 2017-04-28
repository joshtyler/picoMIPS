//Cycle counter

`include "constants.sv"

module cycle(input logic clk, output logic `CYCLE_SIZE cycle);

logic `CYCLE_SIZE mem [2**(`CYCLE_WIDTH)-1:0];

initial
		cycle = '0;
		
initial
begin
	mem[0] = 1;
	mem[1] = 2;
	mem[2] = 0;
end

always @(posedge clk)
	cycle <= mem[cycle];


endmodule
