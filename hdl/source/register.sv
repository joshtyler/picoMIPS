//Single register
//Note this infers an entire ram instance for an 8 bit register
//This is HORRENDOUSLY wasteful, but helps to minimise the utilisation figure :)

`include "constants.sv"

module register #(parameter WIDTH = 8) (input logic [WIDTH-1:0] in, input logic clk, en, output logic [WIDTH-1:0] out);

logic [WIDTH-1:0] mem [1:0];

logic addr;

localparam CONSTANT_READ_ADDR = 0;
always_comb
	addr = CONSTANT_READ_ADDR;

always @(posedge clk)
begin
	if(en)
		mem[addr] <= in;
end

always_comb
	out = mem[addr];
endmodule
