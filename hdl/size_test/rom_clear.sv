//ROM with async clear on input
module rom_clear(q, a, re, clk, reset);
   output[7:0] q; //Output data
   input [6:0] a;
   input re, clk, reset;
   reg [7:0] mem [127:0];
   reg [6:0] address;
   
   initial
		for(int i = 0; i < 128; i++)
			mem[i] = i;
   
   
   
   always_comb
		if(reset)
			address = 0;
		else
			address = a;
			
    always @(posedge clk)
	begin
		q <= mem[address];
   end
endmodule
