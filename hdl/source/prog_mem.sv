//Program memory

`include "constants.sv"

module prog_mem (input logic clock, input logic `PROG_MEM_ADDR_SIZE addr, output logic `PROG_MEM_SIZE data);

logic`PROG_MEM_SIZE memory `PROG_MEM_DEPTH_SIZE;

initial
	$readmemb("progmem.bin", memory);

always @ (posedge clock)
	data <= memory[addr];

endmodule