//Registers

`include "constants.sv"

module regs(input logic clk, input logic `CYCLE_SIZE cycle, input logic `REG_ADDR_SIZE reg1_addr, reg2_addr, wr_addr, input logic `REG_SIZE wr_data, input logic [`SWITCH_WIDTH-2:0] switches, output logic `REG_SIZE reg_1, reg_2, output logic `LED_SIZE leds);

logic `REG_ADDR_SIZE rd_addr;

//Input register address multiplexer
//This needs to select reg1 only in DEC1 cycle
multiplexer #(.WIDTH(`REG_ADDR_WIDTH )) inmux
(
	.a(reg2_addr),
	.b(reg1_addr),
	.sel(cycle[`CYCLE_DEC1]),
	.out(rd_addr)
);

//LED register. This shadows maind memory to provide an output to LEDs
//Note we write in teh EXEC cycle
logic led_reg_en;
always_comb
	led_reg_en = cycle[`CYCLE_EXEC] && wr_addr == `REG_LED_ADDR;
register #(.WIDTH(`REG_WIDTH )) led_reg
(
	.clk(clk),
	.in(wr_data),
	.en(led_reg_en),
	.out(leds)
);

logic `REG_SIZE rd_data;

//Main register memory
//Note we write in the EXEC cycle
regs_mem mem0
(
	.clk(clk),
	.d(wr_data),
	.rd_addr(rd_addr),
	.wr_addr(wr_addr),
	.we(cycle[`CYCLE_EXEC]),
	.q(rd_data)
);

//Switch address multiplexer
//The switch addresses need to be valid for reg1 in DEC2 cycle, reg2 all other times
//This multiplexer provides this
logic `REG_ADDR_SIZE switch_addr;
multiplexer #(.WIDTH(`REG_ADDR_WIDTH)) sw_addr_mux
(
	.a(reg2_addr),
	.b(reg1_addr),
	.sel(cycle[`CYCLE_DEC2]),
	.out(switch_addr)
);


//switch multiplexer
//Multiplex between switches 0-7 and switch 8
logic `REG_SIZE switches_muxed;
logic sw_mux_sel;
always_comb
	sw_mux_sel = (switch_addr == `REG_SW8_ADDR);
multiplexer #(.WIDTH(`REG_WIDTH)) sw_mux
(
	.a(switches[7:0]),
	.b({7'b0,switches[8]}),
	.sel(sw_mux_sel),
	.out(switches_muxed)
);

//Data multiplexer
//Multiplexes between register data and switches
logic `REG_SIZE reg_data;
logic data_mux_sel;
always_comb
	data_mux_sel = (switch_addr == `REG_SW07_ADDR || switch_addr == `REG_SW8_ADDR);
multiplexer #(.WIDTH(`REG_WIDTH)) data_mux
(
	.a(rd_data),
	.b(switches_muxed),
	.sel(data_mux_sel),
	.out(reg_data)
);

//Output 1 register
//This is clocked in the DEC2 cycle, as this is when the output represents REG1
register #(.WIDTH(`REG_WIDTH)) out1_reg
(
	.clk(clk),
	.in(reg_data),
	.en(cycle[`CYCLE_DEC2]),
	.out(reg_1)
);

always_comb
	reg_2 = reg_data;

endmodule
