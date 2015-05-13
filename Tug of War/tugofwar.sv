module Lab3 (CLOCK_50,SW, LEDR,KEY); 
	input CLOCK_50; 
	input SW[9];
	input [3:0] KEY;
	output reg [9:1] LEDR;
	output reg [6:0] HEX[0];
	parameter whichClock = 23; 	

	
	
	clock_divider cdiv (CLOCK_50, clk);   
endmodule 


// User Input
module button(Clock, pressed, set);
	input Clock;
	input pressed;
	output reg set;
	reg PS, NS;
	
	always @(*)
		NS = pressed;
	always @(posedge Clock)
		PS <= NS;
	
	assign set = (~PS & NS);
endmodule
