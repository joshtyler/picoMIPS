//Testbench for top level system

`include "../source/constants.sv"

`timescale 1ns / 1 ps

module test_picoMIPS;

//Inputs
logic clk;
logic `SWITCH_SIZE SW;

//Outputs
logic `LED_SIZE LED;

//DUT instance
picoMIPS dut (.*);

//Setup clk
initial
begin
	clk = 0;
	#10ns;
	forever #10ns clk = ~clk;
end

//Generate an instruction
function logic `PROG_MEM_SIZE generateInstruction;
input logic opcode;
input logic `REG_ADDR_SIZE reg1;
input logic `REG_ADDR_SIZE reg2;
input logic `PROG_MEM_ADDR_SIZE branch;
begin
	generateInstruction = { opcode, reg1, reg2, branch};
end
endfunction

//Setup program memory to clear Z and load 1 into the LED register
task clearZandLoadLED;
begin
	dut.mem0.memory[0] = generateInstruction(0, `REG_Z_ADDR, `REG_Z_ADDR, 1); //Clear Z register
	dut.mem0.memory[1] = generateInstruction(1, `REG_U_ADDR, `REG_LED_ADDR, 1); //Load 1 into LEDs
end
endtask

//Stimulus
initial
begin
	//Initialise
	SW = 0;

	//Reset
	SW[$high(SW)] = 1;
	# 12ns;
	SW[$high(SW)] = 0;
	
end

endmodule