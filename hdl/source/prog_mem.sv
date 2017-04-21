module prog_mem (input logic clock, input logic [5:0] addr, output logic [12:0] data);

(* ram_init_file = "progmem.mif" *) logic[12:0] memory[48:0];

always @ (posedge clock)
	data <= memory[addr];

endmodule