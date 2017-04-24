//Testbench for top level system

`include "../source/constants.sv"

`timescale 1ns / 1 ps

module test_picoMIPS;

//Inputs
logic clk;
logic `SWITCH_SIZE SW;

//Outputs
logic `LED_SIZE LED;


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

//Setup program memory to clear Z and load 1 into the LED register
task clearZandLoadLED;
begin
	dut.mem0.memory[0] = generateInstruction(0, `REG_Z_ADDR, `REG_Z_ADDR, 1); //Clear Z register
	dut.mem0.memory[1] = generateInstruction(1, `REG_U_ADDR, `REG_LED_ADDR, 1); //Load 1 into LEDs
end
endtask

//Load counting test program
task countingTest;
begin
	$readmemb("../../asm_progs/compiled/counter.bin", dut.mem0.memory);
end
endtask

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
	logic signed `REG_SIZE x_exp,y_exp,x1,x2,x3,y1,y2,y3;
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
	assert(LED == x_exp) else
		$fatal("X Result: %d, Expected %d. (x=%d,y=%d)", LED, x_exp,x,y);
	SW8 = 1;
	#delay;
	assert(LED == y_exp) else
		$fatal("Y Result: %d, Expected %d. (y=%d,y=%d)", LED, y_exp,x,y);
	SW8 = 0;
	#delay;
	
end
endtask;

//Stimulus
initial
begin
	//Initialise
	SW17 = 0;
	SW8 = 0;

	//Reset
	SW9 = 1;
	# 12ns;
	SW9 = 0;

	//Test all possible values
	for(int i = -128; i < 128; i++)
	begin
		$display(i);
		for(int j = -128; j < 128; j++)
		begin
			testAffineTransform(i,j);
		end
	end

	$stop;
	
end

endmodule