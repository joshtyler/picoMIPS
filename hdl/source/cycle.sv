//Cycle counter

`include "constants.sv"

module cycle(input logic clk, output logic `CYCLE_SIZE cycle);

logic `CYCLE_SIZE mem [2**(`CYCLE_WIDTH)-1:0];

//Initialisation value - will be provided by bitstream
initial
	cycle = 4'b1000;

//Initialise memory to desired values.
initial
begin
	mem[4'b0000] = 4'b0001; //What we will reset to (if we end up using reset)

	mem[4'b0001] = 4'b0010; //Normal cycle
	mem[4'b0010] = 4'b0100;
	mem[4'b0100] = 4'b1000;
	mem[4'b1000] = 4'b0001;
end

always @(posedge clk)
begin
	cycle <= mem[cycle]; //Note that q doesn't get d this clock cycle

end

endmodule
