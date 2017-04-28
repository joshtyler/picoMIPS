//Registers

`include "constants.sv"

module regs(input logic clk, we, input logic `REG_ADDR_SIZE reg1_addr, reg2_addr, wr_addr, input logic `REG_SIZE wr_data, input logic [`SWITCH_WIDTH-2:0] switches, output logic `REG_SIZE reg_1, reg_2, output logic `LED_SIZE leds);

//LED register. This shadows maind memory to provide an output to LEDs
//Note we write in teh EXEC cycle
logic led_reg_en;
always_comb
	led_reg_en = we && wr_addr == `REG_LED_ADDR;
register #(.WIDTH(`REG_WIDTH )) led_reg
(
	.clk(clk),
	.in(wr_data),
	.en(led_reg_en),
	.out(leds)
);

logic `REG_SIZE rd_data1, rd_data2;

//Main register memory
//Note we write in the EXEC cycle
regs_mem mem0
(
	.clk(clk),
	.d(wr_data),
	.rd_addr1(reg1_addr),
	.rd_addr2(reg2_addr),
	.wr_addr(wr_addr),
	.we(we),
	.q1(rd_data1),
	.q2(rd_data2)
);

//Switch multiplexers.
//Choose output between switches and reg data
switch_multipexer sw_mux1
(
	.addr(reg1_addr),
	.reg_data(rd_data1),
	.switches(switches),
	.reg_out(reg_1)
);

switch_multipexer sw_mux2
(
	.addr(reg2_addr),
	.reg_data(rd_data2),
	.switches(switches),
	.reg_out(reg_2)
);

endmodule
