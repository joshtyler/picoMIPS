// From http://quartushelp.altera.com/14.1/mergedProjects/hdl/vlog/vlog_pro_ram_inferred.htm
// 128 x 8-bit synchronous single-port RAM with common read and write addresses
module ram_single(q, a, d, we, clk);
   output[7:0] q;
   input [7:0] d;
   input [6:0] a;
   input we, clk;
   reg [7:0] mem [127:0];
    always @(posedge clk) begin
        if (we)
            mem[a] <= d;
        q <= mem[a];
   end
endmodule
