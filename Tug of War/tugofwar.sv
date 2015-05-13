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

// Hex Display
module Hex(Clock, Reset, L, R, NL, NR, lightOn);
	input Clock, Reset;
	input L, R, NL, NR;
	reg [6:0] PS, NS;
	output reg[6:0] lightOn;
	parameter[6:0] player1win = 7'b0100100, player2win = 7'1111001, lightOff = 7'1111111;
	
	// while
	always @(*)
	case(PS)
	

endmodule
