module multiplier (input logic [17:0] a, b, output logic [35:0] c);
  
always_comb
    c = a * b;

endmodule
