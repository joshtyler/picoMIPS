`ifndef CONSTANTS_SV
`define CONSTANTS_SV

//Cycle constants
`define CYCLE_WIDTH 3
`define CYCLE_SIZE [`CYCLE_WIDTH-1:0]
`define CYCLE_EXEC 0
`define CYCLE_LD1 1
`define CYCLE_LD2 2 

//Program memory constants
`define PROG_MEM_WIDTH 13
`define PROG_MEM_SIZE [`PROG_MEM_WIDTH-1:0]
`define PROG_MEM_DEPTH 49
`define PROG_MEM_DEPTH_SIZE [`PROG_MEM_DEPTH-1:0]
`define PROG_MEM_ADDR_WIDTH 6
`define PROG_MEM_ADDR_SIZE [`PROG_MEM_ADDR_WIDTH-1:0]

//Register constants
`define REG_WIDTH 8
`define REG_SIZE [`REG_WIDTH-1:0]
`define REG_ADDR_WIDTH 3
`define REG_ADDR_SIZE [`REG_ADDR_WIDTH-1:0]
`define REG_DEPTH 6 //This is the 'true' register depth - not including switches
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
`define SWITCH_WIDTH 9
`define SWITCH_SIZE[`SWITCH_WIDTH-1:0]

`endif