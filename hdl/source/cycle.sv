//Cycle counter

`include "constants.sv"

module cycle(input logic clk, output logic `CYCLE_SIZE cycle);

//Initialisation value - will be provided by bitstream
initial
	cycle = '0;

always @(posedge clk)
begin
	if(cycle == `CYCLE_WRITE)
		cycle <= '0;
	else
		cycle <= cycle + 1;

end

endmodule
