//Cycle counter

`include "constants.sv"

module cycle(input logic clk, output logic `CYCLE_SIZE cycle);

//Initialisation value - will be provided by bitstream
initial
	cycle = 1;

//Note could probably be changed to infer a mulitplier for better optimisation
always @(posedge clk)
	if(cycle [`CYCLE_EXEC])
		cycle <= 1;
	else
		cycle <= (cycle << 1);

endmodule
