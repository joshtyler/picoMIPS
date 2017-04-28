//Top level module

`include "constants.sv"

module picoMIPS(input logic clk, input logic `SWITCH_SIZE SW, output logic `LED_SIZE LED);

//Cycle generator signals
logic `CYCLE_SIZE cycle;

//Program memory signals
logic `PROG_MEM_ADDR_SIZE prog_mem_addr;
logic `PROG_MEM_SIZE prog_mem_data;
//Signals to break out opcode
logic op_code;
logic `REG_ADDR_SIZE reg1_addr, reg2_addr;
logic `IMM_SIZE immediate;
logic `PROG_MEM_ADDR_SIZE branch_addr;
//Decode instruction into constituant parts
localparam OP_CODE_IDX = $high(prog_mem_data);
localparam REG1_HIGH_IDX = OP_CODE_IDX - 1;
localparam REG1_LOW_IDX = REG1_HIGH_IDX - `REG_ADDR_WIDTH +1;
localparam REG2_HIGH_IDX = REG1_LOW_IDX - 1;
localparam REG2_LOW_IDX = REG2_HIGH_IDX - `REG_ADDR_WIDTH +1;
localparam BRANCH_HIGH_IDX = REG2_LOW_IDX - 1;
localparam BRANCH_LOW_IDX = $low(prog_mem_data);
localparam IMM_LOW_IDX = $low(prog_mem_data);
localparam IMM_HIGH_IDX = IMM_LOW_IDX + `IMM_WIDTH -1;
always_comb
begin
	op_code = prog_mem_data[OP_CODE_IDX];
	reg1_addr = prog_mem_data[REG1_HIGH_IDX : REG1_LOW_IDX];
	reg2_addr = prog_mem_data[REG2_HIGH_IDX : REG2_LOW_IDX];
	immediate =  prog_mem_data[IMM_HIGH_IDX : IMM_LOW_IDX];
	branch_addr =  prog_mem_data[BRANCH_HIGH_IDX : BRANCH_LOW_IDX];
end

//Program counter signals
logic branch;

//Register signals
logic `REG_SIZE wr_data, reg1, reg2;

//SUBLEQ signals
logic `REG_SIZE subleq_result;
logic subleq_branch;

//MULTI signals
logic `REG_SIZE multi_result;

//Cycle generator
cycle cycle0
(
	.clk(clk),
	.cycle(cycle)
);

logic reset;
always_comb
	reset = !SW[$high(SW)]; //The highest switch is reset, but it's active low

//Program counter
pc pc0
(
	.clk(clk),
	.reset(reset),
	.branch(branch),
	.enable(cycle[`CYCLE_EXEC]),
	.branch_addr(branch_addr),
	.addr(prog_mem_addr)
);

//Program memory
prog_mem mem0
(	.clock(clk),
	.reset(reset),
	.enable(cycle[`CYCLE_WRITE]),
	.addr(prog_mem_addr),
	.data(prog_mem_data)
);

//Registers
regs regs0
(
	.clk(clk),
	.we(cycle[`CYCLE_EXEC]),
	.reg1_addr(reg1_addr),
	.reg2_addr(reg2_addr),
	.wr_addr(reg2_addr), //We always want to write back to reg 2
	.wr_data(wr_data),
	.switches(SW[$high(SW)-1:$low(SW)]), //All switches except highest
	.reg_1(reg1),
	.reg_2(reg2),
	.leds(LED)
);

//SUBLEQ instruction
subleq sub0
(
	.reg_1(reg1),
	.reg_2(reg2),
	.result(subleq_result),
	.branch(subleq_branch)
);

//MULTI instruction
multi multi0
(
	.register(reg1),
	.immediate(immediate),
	.result(multi_result)
);

//Multiplexer to multiplex result and branch
multiplexer #(.WIDTH(`REG_WIDTH + 1 ))  multi_sub_out_mux
(
	.a( {subleq_branch, subleq_result} ),
	.b( {1'b0, multi_result} ),
	.sel(op_code),
	.out( {branch, wr_data} )
);

endmodule
