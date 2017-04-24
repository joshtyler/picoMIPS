//Single register
//Note this infers an entire ram instance for an 8 bit register
//This is HORRENDOUSLY wasteful, but helps to minimise the utilisation figure :)

//So it seems that in synthesis this deosn't infer memory :( Maybe replace with a multiplier?

`include "constants.sv"

module register #(parameter WIDTH = 8) (input logic [WIDTH-1:0] in, input logic clk, en, output logic [WIDTH-1:0] out);

logic [WIDTH-1:0] mem [1:0];

logic addr;

localparam CONSTANT_READ_ADDR = 0;
always_comb
	addr = CONSTANT_READ_ADDR;

//Init memory to zero
initial
	for(int i=0; i < 2; i++)
		mem[i] = 0;

always @(posedge clk)
begin
	if(en)
		mem[addr] <= in;
end

always_comb
	out = mem[addr];
endmodule
