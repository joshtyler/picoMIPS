// Tri port RAM
module ram_tri(q1, q2, a1, a2, a3, d, we, clk);
   output[7:0] q1, q2; //Output data
   input [7:0] d; //Write data
   input [6:0] a1, a2, a3; //Independant addresses
   input we, clk;
   reg [7:0] mem [127:0];
   
   
    always @(posedge clk)
	begin
        if (we)
            mem[a3] <= d;
			
        q1 <= mem[a1];
		q2 <= mem[a2];
   end
endmodule
