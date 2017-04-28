//Single register
//Note this infers a multiplier. This is very wasteful, but reduces the cost figure!

`include "constants.sv"

module register #(parameter WIDTH = 8) (input logic [WIDTH-1:0] in, input logic clk, en, output logic [WIDTH-1:0] out);


	altsyncram	altsyncram_component (
				.address_a (1'b0),
				.clock0 (clk),
				.data_a (in),
				.wren_a (en),
				.q_a (out),
				.aclr0 (1'b0),
				.aclr1 (1'b0),
				.address_b (1'b1),
				.addressstall_a (1'b0),
				.addressstall_b (1'b0),
				.byteena_a (1'b1),
				.byteena_b (1'b1),
				.clock1 (1'b1),
				.clocken0 (1'b1),
				.clocken1 (1'b1),
				.clocken2 (1'b1),
				.clocken3 (1'b1),
				.data_b (1'b1),
				.eccstatus (),
				.q_b (),
				.rden_a (1'b1),
				.rden_b (1'b1),
				.wren_b (1'b0));
	defparam
		altsyncram_component.clock_enable_input_a = "BYPASS",
		altsyncram_component.clock_enable_output_a = "BYPASS",
		altsyncram_component.intended_device_family = "Cyclone IV E",
		altsyncram_component.lpm_hint = "ENABLE_RUNTIME_MOD=NO",
		altsyncram_component.lpm_type = "altsyncram",
		altsyncram_component.numwords_a = 1,
		altsyncram_component.operation_mode = "SINGLE_PORT",
		altsyncram_component.outdata_aclr_a = "NONE",
		altsyncram_component.outdata_reg_a = "UNREGISTERED",
		altsyncram_component.power_up_uninitialized = "FALSE",
		altsyncram_component.ram_block_type = "M9K",
		altsyncram_component.read_during_write_mode_port_a = "NEW_DATA_NO_NBE_READ",
		altsyncram_component.widthad_a = 1,
		altsyncram_component.width_a = WIDTH,
		altsyncram_component.width_byteena_a = 1;

/*
	logic [2*WIDTH-1:0] tmp_res;

	always_comb
		out = tmp_res[WIDTH-1:0];

	lpm_mult	lpm_mult_component (
				.clken (en),
				.clock (clk),
				.dataa (in),
				.datab ({7'b0,1'b1}),
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

*/


endmodule
