`ifndef CONSTANTS_SV
`define CONSTANTS_SV

//Cycle constants
//This is a counter. DEC is 00, EXEC is 01, Write is 10
//Since nothing needs to be enabled on DEC, we can treat the system as a one hot counter
//This saves logic elements
//`define CYCLE_DEC
`define CYCLE_WIDTH 2
`define CYCLE_SIZE [`CYCLE_WIDTH-1:0] 
`define CYCLE_EXEC 0
`define CYCLE_WRITE 1

//Program memory constants
`define PROG_MEM_WIDTH 12
`define PROG_MEM_SIZE [`PROG_MEM_WIDTH-1:0]
`define PROG_MEM_DEPTH 31
`define PROG_MEM_DEPTH_SIZE [`PROG_MEM_DEPTH-1:0]
`define PROG_MEM_ADDR_WIDTH 5
`define PROG_MEM_ADDR_SIZE [`PROG_MEM_ADDR_WIDTH-1:0]
`define IMM_WIDTH 5
`define IMM_SIZE [`IMM_WIDTH-1:0]

//Register constants
`define REG_WIDTH 8
`define REG_SIZE [`REG_WIDTH-1:0]
`define REG_ADDR_WIDTH 3
`define REG_ADDR_SIZE [`REG_ADDR_WIDTH-1:0]

//Note that this is two bigger than it needs to be due to the register memory shadowing switches
//This is necessary for simulation becuause otherwise the multiplexer does not work for the switch addresses (as it has X inputs and so gives an X output)
//Perhaps this could be optimised at some point
`define REG_DEPTH 8 
`define REG_DEPTH_SIZE [`REG_DEPTH-1:0]

`define REG_R1_ADDR 0
`define REG_R2_ADDR 1
`define REG_R3_ADDR 2
`define REG_R4_ADDR 3
`define REG_LED_ADDR `REG_R4_ADDR //LEDs shadow R4
`define REG_U_ADDR 4 //Unity
`define REG_Z_ADDR 5 //Zero
`define REG_SW07_ADDR 6 //Switches 0-7
`define REG_SW8_ADDR 7 //Switch 8


//System IO constants
`define LED_WIDTH 8
`define LED_SIZE [`LED_WIDTH-1:0]
`define SWITCH_WIDTH 10
`define SWITCH_SIZE[`SWITCH_WIDTH-1:0]

`endif