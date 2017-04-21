//Multiplexer
//This uses a multiplier, which is silly, but it reduces the cost figure compared to combinational logic
//The method is that when sel is 0, the input is multiplied by 1, and the selected output bits are input a
// When sel is 1, the input is multiplied by the input width, and the selected output bits are input b

module multiplexer #(parameter WIDTH = 8) (input logic [WIDTH-1:0] a,b, input logic sel, output logic [WIDTH-1:0] out);

//Multiplier signals
logic [WIDTH*4 -1 : 0] result;
logic [WIDTH*2 -1 : 0] x,y;

always_comb
begin
	x = {a, b};
	if(sel)
		y = (2 << (WIDTH -1));
	else
		y = 1;

	result = x * y; //This should infer a multipilier
	out = result[WIDTH*2-1: WIDTH];
end 


endmodule
