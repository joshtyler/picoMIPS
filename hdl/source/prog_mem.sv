//Program memory

`include "constants.sv"

module prog_mem (input logic clock, input logic `PROG_MEM_ADDR_WIDTH addr, output logic `PROG_MEM_WIDTH data);

logic`PROG_MEM_WIDTH memory `PROG_MEM_DEPTH;

initial
	$readmemb("progmem.bin", memory);

always @ (posedge clock)
	data <= memory[addr];

endmodule