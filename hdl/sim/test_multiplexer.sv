//Testbench for multiplexer
`timescale 1ns / 1 ps
module test_multiplexer;

logic [7:0] a,b, out;
logic sel;

multiplexer dut (.*);

initial
begin
	a = 34;
	b = 95;
	sel = 0;
	# 10ns;
	assert(out == a);
	sel = 1;
	# 10ns;
	assert(out == b);
	sel = 0;
	# 10ns;
	assert(out == a);
	$stop;
end

endmodule