//Registers

`include "constants.sv"

module regs(input logic clk, logic `CYCLE_SIZE cycle, logic `REG_ADDR_SIZE reg1_addr, reg2_addr, wr_addr, logic `REG_SIZE wr_data, logic [`SWITCH_WIDTH-2:0] switches, output logic `REG_SIZE reg_1, reg_2, logic `LED_SIZE leds,);

logic `REG_ADDR_SIZE rd_addr;

//Input register address multiplexer
multiplexer #(.WIDTH(`REG_ADDR_SIZE)) inmux
(
	.a(reg1_addr),
	.b(reg2_addr),
	.sel(cycle[`CYCLE_LOAD]),
	.out(rd_addr)
);

//LED register. This shadows maind memory to provide an output to LEDs
register #(.WIDTH(`REG_SIZE)) led_reg
(
	.clk(clk),
	.in(wr_data),
	.en(cycle[`CYCLE_EXEC] and wr_addr == `REGS_LED_ADDR),
	.out(rd_addr)
);

logic `REG_SIZE rd_data;

//Main register memory
regs_mem mem0
(
	.clk(clk),
	.d(wr_data),
	.rd_addr(rd_addr),
	.wr_addr(wr_addr),
	.we(cycle[`CYCLE_EXEC]),
	.q(rd_data)
)

//switch multiplexer
//Multiplex between switches 0-7 and switch 8
logic `REG_SIZE switches_muxed;
multiplexer #(.WIDTH(`REG_ADDR_SIZE)) swmux
(
	.a(switches[7:0]),
	.b({8b0,switches[8]}),
	.sel(rd_addr == REG_SW8_ADDR),
	.out(switches_muxed)
);

//Data multiplexer
//Multiplexes between register data and switches
logic `REG_SIZE reg_data;
multiplexer #(.WIDTH(`REG_ADDR_SIZE)) swmux
(
	.a(rd_data),
	.b(switches_muxed),
	.sel(rd_addr == REG_SW07_ADDR || rd_addr == REG_SW8_ADDR),
	.out(reg_data)
);

//Output 1 register
register #(.WIDTH(`REG_SIZE)) led_reg
(
	.clk(clk),
	.in(reg_data),
	.en(cycle[`CYCLE_EXEC]),
	.out(reg_1)
);

always_comb
	reg_2 = reg_data;

endmodule
