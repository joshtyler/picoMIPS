//Testbench for MULTI operation

`include "../source/constants.sv"

`timescale 1ns / 1 ps
module test_multi;

//Inputs
logic signed `REG_SIZE register;
logic signed `IMM_SIZE immediate;

//Output
logic signed `REG_SIZE result;

multi dut (.*);

initial
begin
	register = 8'b00000110; //6
	immediate = 4'b0110; //0.75
	#1ns
	assert(result == 8'b00000100); //4 (truncated from 4.5)

	$stop;
end

endmodule