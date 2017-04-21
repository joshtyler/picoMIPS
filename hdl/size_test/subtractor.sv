module subtractor (input logic [7:0] a, b, output logic [7:0] c);
  
always_comb
    c = a - b;

endmodule
