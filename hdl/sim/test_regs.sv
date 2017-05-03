//Testbench for regs

`include "../source/constants.sv"

`timescale 1ns / 1 ps

module test_regs;

//Cycle
logic `CYCLE_SIZE cycle;

//Inputs
logic clk;
logic we;
logic `REG_ADDR_SIZE reg1_addr, reg2_addr;
logic [`SWITCH_WIDTH-2:0] switches;

//Outputs
logic `REG_SIZE reg_1, reg_2, wr_data;
logic `LED_SIZE leds;

//DUT instance
regs dut (.*);

always_comb
	we = cycle[`CYCLE_EXEC];

//Check that a register is equal to a value
task check_register;
input logic `REG_ADDR_SIZE addr;
input logic `REG_SIZE register;
begin
	logic `REG_SIZE value;

	if(addr == `REG_SW07_ADDR)
		value = switches`REG_SIZE;
	else if(addr == `REG_SW8_ADDR)
		value = switches[$high(switches)]; //Value is 1 if SW8 is set, 0 otherwise
	else
		value = dut.mem0.mem[addr];

	assert(value == register) else $error("Memory not equal. Expected %x found %x",value, register);
end
endtask

task rwTest;
input logic `REG_ADDR_SIZE in_reg1_addr, in_reg2_addr;
input logic `REG_SIZE in_wr_data;
input logic [`SWITCH_WIDTH-2:0] in_switches;
begin
	//We must start on the decode cycle
	assert(cycle == 0);
	reg1_addr = in_reg1_addr;
	reg2_addr = in_reg2_addr;
	wr_data = in_wr_data;
	switches = in_switches;
	@(posedge clk); //Execute
	# 1ns;
	check_register(in_reg1_addr,reg_1);
	check_register(in_reg2_addr,reg_2);
	@(posedge clk); //Write
	# 1ns;
	check_register(in_reg2_addr,in_wr_data);
	if(in_reg2_addr == `REG_LED_ADDR)
		assert(leds == in_wr_data) else $error("Leds not equal. Expected %x found %x",leds, in_wr_data);
	@(posedge clk); //Decode
	# 1ns;
end
endtask

//Setup clk
initial
begin
	clk = 0;
	#10ns;
	forever #10ns clk = ~clk;
end

//Cycle generator
cycle cycle0 (.*);

//Stimulus
initial
begin
	//Initialise memory with dummy values
	dut.mem0.mem[`REG_R1_ADDR] = $urandom_range(255,0);
	dut.mem0.mem[`REG_R2_ADDR] = $urandom_range(255,0);
	dut.mem0.mem[`REG_R3_ADDR] = $urandom_range(255,0);
	dut.mem0.mem[`REG_R4_ADDR] = $urandom_range(255,0);
	dut.mem0.mem[`REG_Z_ADDR] = 0; //The program code normally does this
	dut.mem0.mem[`REG_SW07_ADDR] = $urandom_range(255,0);
	dut.mem0.mem[`REG_SW8_ADDR] = $urandom_range(255,0);
	# 1ns;
	$display($time, ": begin test 1");
	rwTest(`REG_R1_ADDR,`REG_R2_ADDR, $urandom_range(255,0),$urandom_range(255,0));
//	$stop;
	$display($time, ": begin test 2");
	rwTest(`REG_R3_ADDR,`REG_R4_ADDR, $urandom_range(255,0),$urandom_range(255,0));
	$display($time, ": begin test 3");
	rwTest(`REG_SW07_ADDR,`REG_R1_ADDR, $urandom_range(255,0),$urandom_range(255,0));
	$display($time, ": begin test 4");
	rwTest(`REG_SW8_ADDR,`REG_R2_ADDR, $urandom_range(255,0),$urandom_range(255,0));
	$display($time, ": begin test 5");
	rwTest(`REG_Z_ADDR,`REG_U_ADDR, $urandom_range(255,0),$urandom_range(255,0));
	$display("Testing complete");
	$stop;
end

endmodule