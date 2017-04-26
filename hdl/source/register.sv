//Single register
//Note this infers a multiplier. This is very wasteful, but reduces the cost figure!

`include "constants.sv"

module register #(parameter WIDTH = 8) (input logic [WIDTH-1:0] in, input logic clk, en, output logic [WIDTH-1:0] out);

	logic [2*WIDTH-1:0] tmp_res;

	always_comb
		out = tmp_res[WIDTH-1:0];

	lpm_mult	lpm_mult_component (
				.clken (en),
				.clock (clk),
				.dataa (in),
				.datab (1),
				.result (tmp_res),
				.aclr (1'b0),
				.sum (1'b0));
	defparam
		lpm_mult_component.lpm_hint = "DEDICATED_MULTIPLIER_CIRCUITRY=YES,MAXIMIZE_SPEED=5",
		lpm_mult_component.lpm_pipeline = 1,
		lpm_mult_component.lpm_representation = "UNSIGNED",
		lpm_mult_component.lpm_type = "LPM_MULT",
		lpm_mult_component.lpm_widtha = WIDTH,
		lpm_mult_component.lpm_widthb = WIDTH,
		lpm_mult_component.lpm_widthp = 2*WIDTH;


endmodule
