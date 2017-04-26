//7 segment decoder

module segdec(input logic [3:0] in, output logic [6:0] out);

	always_comb
	begin
		//7'bABCDEFG
		case (in)
			4'b0000 :
				out = 7'b1111110;
			4'b0001 :
				out = 7'b0110000;
			4'b0010 :
				out = 7'b1101101; 
			4'b0011 :
				out = 7'b1111001;
			4'b0100 :
				out = 7'b0110011;
			4'b0101 :
				out = 7'b1011011;  
			4'b0110 :
				out = 7'b1011111;
			4'b0111 :
				out = 7'b1110000;
			4'b1000 :
				out = 7'b1111111;
			4'b1001 :
				out = 7'b1111011;
			//This will be used to show a minus sign
			4'b1010 :
				out = 7'b0000001;
			//Otherwise all off
			default :
				out = 7'b0000000;
    		endcase
	end
     
endmodule