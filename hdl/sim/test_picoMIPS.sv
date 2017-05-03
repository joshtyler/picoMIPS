//Testbench for top level system

`include "../source/constants.sv"

`timescale 1ns / 1 ps

module test_picoMIPS;

//Inputs
logic clk;
logic `SWITCH_SIZE SW;

//Outputs
logic `LED_SIZE LED;

//Log file
integer logFile;


//Assignments for switches to make them easier to use
logic SW8, SW9;
logic [`SWITCH_WIDTH-3:0] SW17;
always_comb
begin
	SW[$high(SW)] = SW9;
	SW[$high(SW)-1] = SW8;
	SW[$high(SW)-2:0] = SW17;
end

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

//By default, verilog does not truncate for rounding
//This function implements multiplication with truncated result for rounding
function logic signed `REG_SIZE multiplyTruncated;
input real a,b;
begin
	localparam offset = 16;
	logic signed [ $high(multiplyTruncated) + offset : $low(multiplyTruncated)] result_shifted;
	result_shifted = ((a*b)*(2**offset));
	multiplyTruncated = result_shifted[$high(result_shifted):$low(result_shifted)+offset];
end
endfunction;

//Test main program
task testAffineTransform;
input logic signed `REG_SIZE x,y;
begin
	logic signed `REG_SIZE x_exp,y_exp,x1,x2,x3,y1,y2,y3, x_res, y_res;
	time delay;
	delay = 1us;

	//Calculate expected result
	x1 = multiplyTruncated(0.5,x);
	x2 = multiplyTruncated((-0.875),y);
	x3 = 5;

	y1 = multiplyTruncated((-0.875),x);
	y2 = multiplyTruncated(0.75,y);
	y3 = 12;

	x_exp = x1 + x2 + x3;
	y_exp = y1 + y2 + y3;

	SW17 = x;
	SW8 = 1;
	#delay;
	SW8 = 0;
	#delay;
	SW17 = y;
	SW8 = 1;
	#delay;
	SW8 = 0;
	#delay;
	x_res = LED;
	assert(x_res == x_exp) else
		$error("X Result: %d, Expected %d. (x=%d,y=%d)", x_res, x_exp,x,y);
	SW8 = 1;
	#delay;
	y_res = LED;
	assert(y_res == y_exp) else
		$error("Y Result: %d, Expected %d. (y=%d,y=%d)", y_res, y_exp,x,y);
	SW8 = 0;
	#delay;

	$fdisplay(logFile, "%d\t%d\t%d\t%d\t", x, y, x_exp, y_exp);
	
end
endtask;

//Stimulus
initial
begin
	logFile = $fopen("log.txt");
	$fdisplay(logFile, "xi\tyi\txo\tyo");
	
	//Initialise
	SW17 = 0;
	SW8 = 0;

	//Reset
	SW9 = 0;
	# 100ns;
	SW9 = 1;

	//testAffineTransform(-1,2);
	//$stop;

	//Test all possible values
	for(int i = -128; i < 128; i++)
	begin
		$display(i);
		for(int j = -128; j < 128; j++)
		begin
			testAffineTransform(i,j);
		end
	end

	$fclose(logFile);
	$stop;
	
end

endmodule