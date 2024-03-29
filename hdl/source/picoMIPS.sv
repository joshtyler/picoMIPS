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
logic `PROG_MEM_ADDR_SIZE branch_addr, nml_addr;

//Decode instruction into constituant parts
localparam OP_CODE_IDX = $high(prog_mem_data);
localparam REG1_HIGH_IDX = OP_CODE_IDX - 1;
localparam REG1_LOW_IDX = REG1_HIGH_IDX - `REG_ADDR_WIDTH +1;
localparam REG2_HIGH_IDX = REG1_LOW_IDX - 1;
localparam REG2_LOW_IDX = REG2_HIGH_IDX - `REG_ADDR_WIDTH +1;
localparam BRANCH_HIGH_IDX = REG2_LOW_IDX - 1;
localparam BRANCH_LOW_IDX = BRANCH_HIGH_IDX - `PROG_MEM_ADDR_WIDTH +1;
localparam IMM_HIGH_IDX = BRANCH_HIGH_IDX;
localparam IMM_LOW_IDX = IMM_HIGH_IDX - `IMM_WIDTH +1;
localparam NML_ADDR_HIGH_IDX = BRANCH_LOW_IDX - 1;
localparam NML_ADDR_LOW_IDX = NML_ADDR_HIGH_IDX - `PROG_MEM_ADDR_WIDTH +1;
always_comb
begin
	op_code = prog_mem_data[OP_CODE_IDX];
	reg1_addr = prog_mem_data[REG1_HIGH_IDX : REG1_LOW_IDX];
	reg2_addr = prog_mem_data[REG2_HIGH_IDX : REG2_LOW_IDX];
	immediate =  prog_mem_data[IMM_HIGH_IDX : IMM_LOW_IDX];
	branch_addr =  prog_mem_data[BRANCH_HIGH_IDX : BRANCH_LOW_IDX];
	nml_addr =  prog_mem_data[NML_ADDR_HIGH_IDX : NML_ADDR_LOW_IDX];
end

//Program counter signals
logic branch;

//Register signals
logic `REG_SIZE wr_data, reg1, reg2;

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
	.branch(branch),
	.nml_addr(nml_addr),
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
	.wr_data(wr_data),
	.switches(SW[$high(SW)-1:$low(SW)]), //All switches except highest
	.reg_1(reg1),
	.reg_2(reg2),
	.leds(LED)
);

//ALU
alu alu0
(
	.reg_1(reg1),
	.reg_2(reg2),
	.op_code(op_code),
	.immediate(immediate),
	.wr_data(wr_data),
	.branch(branch)
);

endmodule
