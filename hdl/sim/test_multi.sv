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
	immediate = 5'b00110; //0.75
	#1ns
	assert(result == 8'b00000100); //4 (truncated from 4.5)

	#10ns
	register = 8'b00001000; //8
	immediate = 5'b01100; //12 (but divided down for immediate)
	#1ns
	assert(result == 8'b00001100); //12 (truncated from 4.5)

	#10ns
	register = 8'b10000000; //-128
	immediate = 5'b00100; //0.5
	#1ns
	assert(result == 8'b11000000); //12 (truncated from 4.5)
	#10ns;
	$stop;
end

endmodule