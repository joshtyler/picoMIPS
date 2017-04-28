//Program memory

`include "constants.sv"

module prog_mem (input logic clock, reset, enable, input logic `PROG_MEM_ADDR_SIZE addr, output logic `PROG_MEM_SIZE data);



//Begin Altera component instance
	altsyncram	altsyncram_component (
				.aclr0 (reset),
				.address_a (addr),
				.clock0 (clock),
				.clocken0 (enable),
				.q_a (data),
				.aclr1 (1'b0),
				.address_b (1'b1),
				.addressstall_a (1'b0),
				.addressstall_b (1'b0),
				.byteena_a (1'b1),
				.byteena_b (1'b1),
				.clock1 (1'b1),
				.clocken1 (1'b1),
				.clocken2 (1'b1),
				.clocken3 (1'b1),
				.data_a ({17{1'b1}}),
				.data_b (1'b1),
				.eccstatus (),
				.q_b (),
				.rden_a (1'b1),
				.rden_b (1'b1),
				.wren_a (1'b0),
				.wren_b (1'b0));
	defparam
		altsyncram_component.address_aclr_a = "CLEAR0",
		altsyncram_component.clock_enable_input_a = "NORMAL",
		altsyncram_component.clock_enable_output_a = "BYPASS",
		altsyncram_component.init_file = "../source/progmem.mif",
		altsyncram_component.intended_device_family = "Cyclone IV E",
		altsyncram_component.lpm_type = "altsyncram",
		altsyncram_component.numwords_a = `PROG_MEM_DEPTH,
		altsyncram_component.operation_mode = "ROM",
		altsyncram_component.outdata_aclr_a = "CLEAR0",
		altsyncram_component.outdata_reg_a = "UNREGISTERED",
		altsyncram_component.ram_block_type = "M9K",
		altsyncram_component.widthad_a = `PROG_MEM_ADDR_WIDTH,
		altsyncram_component.width_a = `PROG_MEM_WIDTH,
		altsyncram_component.width_byteena_a = 1;



endmodule