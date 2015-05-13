// William Thing

module Lab3 (CLOCK_50, SW, LEDR, KEY, HEX); 
	input CLOCK_50; 
	input [9:0] SW;
	input [3:0] KEY;
	output reg [9:1] LEDR;
	output reg [6:0] HEX[0];
	parameter whichClock = 23; 	

	wire right,left,H1,H2;
	
	button b1 (.Clock(CLOCK_50) , .pressed(~KEY[3]), .set(left));
	button b2 (.Clock(CLOCK_50) , .pressed(~KEY[0]), .set(right));
	
	
	Hex display (.Clock(CLOCK_50), .Reset(SW[9]), .L(left), .R(right), .NL(LEDR[9]), .NR(LEDR[1]), .lightOn(HEX0));
	normalLight nl1(.Clock(CLOCK_50), .Reset(SW[9]),.L(left),.R(right), .NL(LEDR[2]),.NR(1'b0),	 .lightOn(LEDR[1]));
	normalLight nl2(.Clock(CLOCK_50), .Reset(SW[9]),.L(left),.R(right), .NL(LEDR[3]),.NR(LEDR[1]),.lightOn(LEDR[2]));
	normalLight nl3(.Clock(CLOCK_50), .Reset(SW[9]),.L(left),.R(right), .NL(LEDR[4]),.NR(LEDR[2]),.lightOn(LEDR[3]));
	normalLight nl4(.Clock(CLOCK_50), .Reset(SW[9]),.L(left),.R(right), .NL(LEDR[5]),.NR(LEDR[3]),.lightOn(LEDR[4]));
	centerLight nl5(.Clock(CLOCK_50), .Reset(SW[9]),.L(left),.R(right), .NL(LEDR[6]),.NR(LEDR[4]),.lightOn(LEDR[5]));
	normalLight nl6(.Clock(CLOCK_50), .Reset(SW[9]),.L(left),.R(right), .NL(LEDR[7]),.NR(LEDR[5]),.lightOn(LEDR[6]));
	normalLight nl7(.Clock(CLOCK_50), .Reset(SW[9]),.L(left),.R(right), .NL(LEDR[8]),.NR(LEDR[6]),.lightOn(LEDR[7]));
	normalLight nl8(.Clock(CLOCK_50), .Reset(SW[9]),.L(left),.R(right), .NL(LEDR[9]),.NR(LEDR[7]),.lightOn(LEDR[8]));
	normalLight nl9(.Clock(CLOCK_50), .Reset(SW[9]),.L(left),.R(right), .NL(1'b0),   .NR(LEDR[8]),.lightOn(LEDR[9]));
	
	   
endmodule 
 
// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ... 
/*
module clock_divider (clock, divided_clocks); 
	input clock; 
	output [31:0] divided_clocks; 
	reg [31:0] divided_clocks;
 
	initial
		divided_clocks = 0;
	
	always @(posedge clock)
		divided_clocks = divided_clocks +1;
endmodule
*/ 

// centerlight works!!
module centerLight (Clock, Reset, L, R, NL, NR, lightOn);
input Clock, Reset;
 // L is true when left key is pressed, R is true when the right key
// is pressed, NL is true when the light on the left is on, and NR
// is true when the light on the right is on.
input L, R, NL, NR;
// when lightOn is true, the center light should be on.
output reg lightOn;
wire [1:0] PS;
reg [1:0] NS;
parameter off = 1'b0, on = 1'b1;

// while
always @(*)
case(PS)
	off:	if (NL & R) NS = on;           
			else if (NR & L) NS = on;
			else NS = off;
	on:	if (NS & R) NS = off;
			else if (NS & L) NS = off;
			else NS = on;
		
endcase

always @(*)
case(PS)
	off: lightOn = off;
	on: lightOn = on;
endcase

// reset
always @(posedge Clock)
	if (Reset)
		PS <= on; // reset should turn the center light on
	else
		PS <= NS;

endmodule


module normalLight (Clock, Reset, L, R, NL, NR, lightOn);
input Clock, Reset;
// L is true when left key is pressed, R is true when the right key
// is pressed, NL is true when the light on the left is on, and NR
// is true when the light on the right is on.
input L, R, NL, NR;
wire [1:0] PS;
reg [1:0] NS;
parameter off = 1'b0, on = 1'b1;
// when lightOn is true, the normal light should be on.
output reg lightOn;

// while
always @(*)
case(PS)
	off:	if (NL & R) NS = on;           
			else if (NR & L) NS = on;
			else NS = off;
	on:	if (NS & R) NS = off;
			else if (NS & L) NS = off;
			else NS = on;
	
endcase

always @(*)
case(PS)
	off: lightOn = 0;
	on: lightOn = 1;
endcase

// reset
always @(posedge Clock)
	if (Reset)
		PS <= off; // normal light should be turned off when reset
	else
		PS <= NS;

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


module Hex(Clock, Reset, L, R, NL, NR, lightOn);
	input Clock, Reset;
	input L, R, NL, NR;
	reg [6:0] PS, NS;
	output reg[6:0] lightOn;
	parameter[6:0] player1win = 7'b0100100, player2win = 7'b1111001, lightOff = 7'b1111111;
	
	// while
	always @(*)
	case(PS)
		player1win: NS = player1win;
		player2win: NS = player2win;
		lightOff:	if (NL & L) NS = player1win;			// most left and input left = p1win
						else if (NR & R) NS = player2win;	// most right and input right = p2win
						else NS = lightOff;						// else
	endcase
	
	assign lightOn = PS;
	
	always @(posedge Clock)
		if (Reset)
			PS <= lightOff;
		else
			PS <= NS;
	

endmodule

/*
module Lab3_testbench();
reg clk, reset;
reg [1:0]SW;
wire [2:0]out;
light_fsm dut (clk, SW, out, reset);
// Set up the clock.
parameter CLOCK_PERIOD=100;
initial clk=1;
always begin
#(CLOCK_PERIOD/2);
clk = ~clk;
end
// Set up the inputs to the design. Each line is a clock cycle.
initial begin
 @(posedge clk);
 @(posedge clk);
 reset <= 1; 
 @(posedge clk);
 @(posedge clk);
 reset <= 0;
 @(posedge clk);
 @(posedge clk);
 SW[1:0] <= 0; 
 @(posedge clk);
 @(posedge clk);
 SW[0] <= 1;
 @(posedge clk);
 @(posedge clk);
 SW[1] <= 1;
 @(posedge clk);
 @(posedge clk);
 SW[0] <= 0;
 @(posedge clk);
 @(posedge clk);
$stop; // End the simulation.
end
endmodule
*/
 
 
 
