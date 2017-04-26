// synthesise to run on Altera DE0 for testing and demo
module picoMIPS4test(
  input logic fastclk,  // 50MHz Altera DE0 clock
  input logic [9:0] SW, // Switches SW0..SW9
  output logic [7:0] LED, // LEDs
  output logic [6:0] HEX0,
  output logic [6:0] HEX1,
  output logic [6:0] HEX2,
  output logic [6:0] HEX3,
  output logic [6:0] HEX4,
  output logic [6:0] HEX5,
  output logic [6:0] HEX6,
  output logic [6:0] HEX7);
  
  logic clk; // slow clock, about 50Hz
  
  counter c (.fastclk(fastclk),.clk(clk)); // slow clk from counter
  
  // to obtain the cost figure, synthesise your design without the counter 
  // and the picoMIPS4test module using Cyclone IV E as target
  // and make a note of the synthesis statistics
  picoMIPS myDesign (.clk(clk), .SW(SW),.LED(LED));
  
logic [6:0] sw_hex[3:0];
always_comb
begin
	HEX0 = sw_hex[0]; //Units
	HEX1 = sw_hex[1]; //Tens
	HEX2 = sw_hex[2]; //Hundreds
	HEX3 = sw_hex[3]; //Sign
end

bin_to_bcd sw_disp
(
	.in(SW[7:0]),
	.disp(sw_hex)
);

logic [6:0] led_hex[3:0];
always_comb
begin
	HEX4 = led_hex[0]; //Units
	HEX5 = led_hex[1]; //Tens
	HEX6 = led_hex[2]; //Hundreds
	HEX7 = led_hex[3]; //Sign
end

bin_to_bcd led_disp
(
	.in(LED),
	.disp(led_hex)
);

endmodule  