//Multiplexer
//This uses a multiplier, which is silly, but it reduces the cost figure compared to combinational logic
//The method is that when sel is 0, the input is multiplied by 1, and the selected output bits are input a
// When sel is 1, the input is multiplied by the input width, and the selected output bits are input b

//Note this works when WIDTH_A is greater than or equal to WIDTH_B
//Allowing different widths can save logic elements
module multiplexer #(parameter WIDTH = 8, parameter WIDTH_B = WIDTH) (input logic [WIDTH-1:0] a, input logic [WIDTH_B-1:0]  b, input logic sel, output logic [WIDTH-1:0] out);

//Multiplier signals
localparam TOTAL_WIDTH = (WIDTH + WIDTH_B);

logic [TOTAL_WIDTH*2 -1 : 0] result;
logic [TOTAL_WIDTH -1 : 0] x,y;

always_comb
begin
	x = {b, a};
	if(sel)
		y = 1;
	else
		y = (2 << (WIDTH -1));

	out = result[WIDTH*2-1: WIDTH];
end 

	//Instantiate multiplier
	lpm_mult	lpm_mult_component (
				.dataa (x),
				.datab (y),
				.result (result),
				.aclr (1'b0),
				.clken (1'b1),
				.clock (1'b0),
				.sum (1'b0));
	defparam
		lpm_mult_component.lpm_hint = "DEDICATED_MULTIPLIER_CIRCUITRY=YES,MAXIMIZE_SPEED=5",
		lpm_mult_component.lpm_representation = "UNSIGNED",
		lpm_mult_component.lpm_type = "LPM_MULT",
		lpm_mult_component.lpm_widtha = TOTAL_WIDTH,
		lpm_mult_component.lpm_widthb = TOTAL_WIDTH,
		lpm_mult_component.lpm_widthp = 2*TOTAL_WIDTH;

endmodule
