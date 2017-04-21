module multiplexer (input logic [7:0] a, b, input logic ctl, output logic [7:0] c);
  
always_comb
    if(ctl)
        c = b;
    else
        c = a;

endmodule
