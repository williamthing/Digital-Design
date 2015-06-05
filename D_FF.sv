// 
module D_FF (q, d, reset, clk);
	input d, reset, clk;
	output reg q;
	
	
	always @(posedge clk or posedge reset) 
		if (reset)
			q = 0;
		else
			q = d; 
	
endmodule
