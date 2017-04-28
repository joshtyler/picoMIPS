//Multiplexer between switches and registers

`include "constants.sv"

module switch_multipexer(input logic `REG_ADDR_SIZE addr, input logic `REG_SIZE reg_data, input logic [`SWITCH_WIDTH-2:0] switches, output logic `REG_SIZE reg_out);

//switch multiplexer
//Multiplex between switches 0-7 and switch 8
logic `REG_SIZE switches_muxed;
logic sw_mux_sel;
always_comb
	sw_mux_sel = addr[0]; //This works because the SW17 address is 6, and the SW8 reg is 7. This saves a logic element
multiplexer #(.WIDTH(`REG_WIDTH), .WIDTH_B(1)) sw_mux
(
	.a(switches[7:0]),
	.b(switches[8]),
	.sel(sw_mux_sel),
	.out(switches_muxed)
);

//Data multiplexer
//Multiplexes between register data and switches
logic data_mux_sel;
always_comb
	data_mux_sel = (addr == `REG_SW07_ADDR || addr == `REG_SW8_ADDR);
multiplexer #(.WIDTH(`REG_WIDTH)) data_mux
(
	.a(reg_data),
	.b(switches_muxed),
	.sel(data_mux_sel),
	.out(reg_out)
);


endmodule