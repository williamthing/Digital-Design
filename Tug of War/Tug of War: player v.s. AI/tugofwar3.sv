// William Thing
// Lab 7
// Working@!

module Lab3 (CLOCK_50, SW, LEDR, KEY, HEX0, HEX5); 
	input CLOCK_50; 
	input [9:0] SW;
	input [3:0] KEY;
	output reg [9:0] LEDR;
	output reg [6:0] HEX0, HEX5;	
	assign LEDR[0] = 1'b0;
	wire right,left, winR, winL;
	wire [2:0] counterL, counterR;
	
	wire [9:0] random, mysignal;
	// clock divider 
	parameter whichClock = 15;
	wire [31:0] clk;
	clock_divider cdiv (CLOCK_50, clk);
	
	// random number generator
	LFSR RNG(clk[whichClock], SW[9], random);
	
	// combine rng and switch for boolean
	tenBitAdder together(random, SW[8:0], mysignal);
	
	// buttons for the two different players 
	button player2 (.Clock(clk[whichClock]) , .Reset(SW[9]), .pressed(mysignal[9]), .set(left));
	button player1 (.Clock(clk[whichClock]) , .Reset(SW[9]), .pressed(~KEY[0]), .set(right));
	
	
	// we have normal lights and 1x center light
	normalLight n1(.Clock(clk[whichClock]), .Reset(SW[9]), .L(left), .R(right), .NL(LEDR[2]), .NR(1'b0), .lightOn(LEDR[1]));
	normalLight n2(.Clock(clk[whichClock]), .Reset(SW[9]), .L(left), .R(right), .NL(LEDR[3]), .NR(LEDR[1]), .lightOn(LEDR[2]));
	normalLight n3(.Clock(clk[whichClock]), .Reset(SW[9]), .L(left), .R(right), .NL(LEDR[4]), .NR(LEDR[2]), .lightOn(LEDR[3]));
	normalLight n4(.Clock(clk[whichClock]), .Reset(SW[9]), .L(left), .R(right), .NL(LEDR[5]), .NR(LEDR[3]), .lightOn(LEDR[4]));
	
	// center light
	centerLight c1(.Clock(clk[whichClock]), .Reset(SW[9] | winL | winR), .L(left), .R(right), .NL(LEDR[6]), .NR(LEDR[4]), .lightOn(LEDR[5]));
	
	// for readability
	normalLight n6(.Clock(clk[whichClock]), .Reset(SW[9]), .L(left), .R(right), .NL(LEDR[7]), .NR(LEDR[5]), .lightOn(LEDR[6]));
	normalLight n7(.Clock(clk[whichClock]), .Reset(SW[9]), .L(left), .R(right), .NL(LEDR[8]), .NR(LEDR[6]), .lightOn(LEDR[7]));
	normalLight n8(.Clock(clk[whichClock]), .Reset(SW[9]), .L(left), .R(right), .NL(LEDR[9]), .NR(LEDR[7]), .lightOn(LEDR[8]));
	normalLight n9(.Clock(clk[whichClock]), .Reset(SW[9]), .L(left), .R(right), .NL(1'b0),    .NR(LEDR[8]), .lightOn(LEDR[9]));
	
	
	
	// detects if the computer or the player wins
	winnerDetect win (LEDR[9], LEDR[1], left, right, winL, winR);
	
	counter leftCount (clk[whichClock], SW[9], winL, counterL);
	counter rightCount (clk[whichClock], SW[9], winR, counterR);
	
	// Hexdisplay for winner for Tug of War Game
	hexdisplay disp (clk[whichClock], SW[9], counterL, counterR, HEX5, HEX0);
	
	
endmodule 
 
// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ... 

module clock_divider (clock, divided_clocks); 
	input clock; 
	output [31:0] divided_clocks; 
	reg [31:0] divided_clocks;
 
	initial
		divided_clocks = 0;
	
	always @(posedge clock)
		divided_clocks = divided_clocks +1;
endmodule



// centerlight works!!
module centerLight (Clock, Reset, L, R, NL, NR, lightOn);
input Clock, Reset;
 // L is true when left key is pressed, R is true when the right key
// is pressed, NL is true when the light on the left is on, and NR
// is true when the light on the right is on.
input L, R, NL, NR;
// when lightOn is true, the center light should be on.
output reg lightOn;
reg PS;
reg NS;
parameter off = 1'b0, on = 1'b1;

// while
always @(*)
case(PS)
	off:	if (NL & R) NS = on;           
			else if (NR & L) NS = on;
			else NS = off;
	on:	if (R ^ L) NS = off;
			else NS = on;
	default: NS = 1'bx;	
endcase

always @(*)
case(PS)
	off: lightOn = off;
	on: lightOn = on;
	default: lightOn = 1'bx;	
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
	reg PS;
	reg NS;
	parameter off = 1'b0, on = 1'b1;
	// when lightOn is true, the normal light should be on.
	output reg lightOn;


	// while
	always @(*)
	case(PS)
		off:	if (NL & R) NS = on;           
				else if (NR & L) NS = on;
				else NS = off;
		on:	if (R ^ L) NS = off;
				else NS = on;
		default: NS = 1'bx;	
	endcase


	always @(*)
	case(PS)
		off: lightOn = 0;
		on: lightOn = 1;
		default: NS = 1'bx;	
	endcase

	// reset
	always @(posedge Clock)
		if (Reset)
			PS <= off; // normal light should be turned off when reset
		else
			PS <= NS;

endmodule


// basic adder operates on 1 clock cycle (working!)
module adder (A, B, Cin, Cout, Out);
	output Out, Cout;
	input A, B, Cin;
	
	assign Out = A ^ B ^ Cin;
	assign Cout = (A&Cin) | (A&B) | (B&Cin);
endmodule

// adder testbench
module adder_testbench();
	wire Out, Cout;
	reg A, B, Cin;
	
	adder dut(A, B, Cin, Cout, Out);
	
	parameter d = 20;
	
	initial begin
		A = 0;
		B = 0;
		Cin = 0;
	end
	
	reg [3:0] i;
	initial begin
	#d; 
		for(i = 0; ~i[3]; i = i + 1) begin
			{A, B, Cin} = i[2:0];
			#d;
		end
	end
endmodule

// 3-bit adder
module threeBitAdder(A, B, Out);
	output [2:0] Out;
	input [2:0] A, B;
	wire [2:0] C;

	adder first(A[0], B[0], 0, C[0], Out[0]);
	adder second(A[1], B[1], C[0], C[1], Out[1]);
	adder third(A[2], B[2], C[1], C[2], Out[2]);

endmodule

// 3-bit adder test bench
module threeBitAdder_testbench();
	wire [2:0] Out;
	reg [2:0] A, B;
	
	threeBitAdder dut(A, B, Out);
	
	parameter d = 20;
	
	initial begin
		A = 0;
		B = 0;
	end
	
	reg [6:0] i;
	initial begin
	#d; 
		for(i = 0; ~i[6]; i = i + 1) begin
			{A, B} = i[5:0];
			#d;
		end
	end
endmodule


// 10-bit adder
module tenBitAdder(A, B, Out);
	output [9:0] Out;
	input [8:0] A, B;
	wire [8:0] C;
	// 10 adders
	adder a0(A[0], B[0], 0, C[0], Out[0]);
	adder a1(A[1], B[1], C[0], C[1], Out[1]);
	adder a2(A[2], B[2], C[1], C[2], Out[2]);
	adder a3(A[3], B[3], C[2], C[3], Out[3]);
	adder a4(A[4], B[4], C[3], C[4], Out[4]);
	adder a5(A[5], B[5], C[4], C[5], Out[5]);
	adder a6(A[6], B[6], C[5], C[6], Out[6]);
	adder a7(A[7], B[7], C[6], C[7], Out[7]);
	adder a8(A[8], B[8], C[7], C[8], Out[8]);
	assign Out[9] = C[8];
	//adder a9(A[9], B[9], C[8], C[9], Out[9]);
	
endmodule


// 10-bit adder test bench
module tenBitAdder_testbench();
	wire [9:0] Out;
	reg [9:0] A, B;
	
	tenBitAdder dut(A, B, Out);
	
	parameter d = 20;
	
	initial begin
		A = 0;
		B = 0;
	end
	
	reg [20:0] i;
	initial begin
	#d; 
		for(i = 0; ~i[20]; i = i + 1) begin
			{A, B} = i[19:0];
			#d;
		end
	end
endmodule


// Linear feedback shift register; random gen
module LFSR(Clk, Reset, Out);
	input Clk, Reset;
	output [8:0] Out;
	reg [8:0] PS, NS;
	reg T;
	
	always @(*) begin
		T = ~(PS[4] ^ PS[8]);
		NS = {PS[7:0], T};
	end
		
	assign Out = PS;
	
	always @(posedge Clk)
		if (Reset)
			PS <= 9'b000000000;
		else 
			PS <= NS;

endmodule


//
module LFSR_testbench();
	reg clk, Reset;
	wire [8:0] Out;

	LFSR dut(clk, Reset, Out);
	
	parameter CLOCK_PERIOD = 100;
	
	initial clk = 1; 
	always begin 
		#(CLOCK_PERIOD/2); 
		clk = ~clk; 
	end 
	
	initial begin 
						@(posedge clk);
		Reset <= 1; @(posedge clk);	
		Reset <= 0; @(posedge clk); 
						@(posedge clk); 
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
		Reset <= 1; @(posedge clk);
		Reset <= 0; @(posedge clk);
						@(posedge clk);
						
						
		$stop; 
	end
	
endmodule

module winnerDetect (leftMostLight, rightMostLight, left, right, winL, winR);
	input leftMostLight, rightMostLight, left, right;
	output winL, winR;
	
	assign winL = leftMostLight & left & ~right;
	assign winR = rightMostLight & right & ~left;
endmodule 

// User Input for buttons
module button(Clock, Reset, pressed, set);
	input Clock, Reset;
	input pressed;
	output reg set;
	reg [1:0] PS, NS;
	parameter [1:0] on = 2'b00, hold = 2'b01, off = 2'b10;
	
	always @(*)
	case(PS)
		on:	if (pressed) NS = hold;
				else NS = off;
		hold:	if (pressed) NS = hold;
				else NS = off;
		off: 	if (pressed) NS = on;
				else NS = off;
		default: NS = 2'bxx;
	endcase
	
	always @(*)
	case(PS)
		on: set = 1;
		hold: set = 0;
		off: set = 0;
		default: set = 1'bx;
	endcase
		
	always @(posedge Clock)
		if (Reset) PS <= off;
		else PS <= NS;
	
endmodule


// counter uses signal to increment score for hexdisplay
module counter(Clock, Reset, Signal, out);
	input Clock, Reset;
	input Signal;
	reg [2:0] PS, NS;
	output [2:0] out;
	
	wire [2:0] sum;
	
	threeBitAdder adder(PS, 3'b001, sum);
	
	// state logic
	always @(*) begin
		if (Reset) begin
			NS <= 3'b000;
		end
		else if (Signal)
			NS = sum;
		else
			NS = PS;
	end
	
	// output logic
	always @(posedge Clock) begin
		out = PS;
		PS <= NS;
	end
endmodule

// new hexdisplay 
// clock, reset (not sure if needed), counter 1 for leftmost hex, counter 2 for right most hex,
// lightOn(1 & 2) is what to display
module hexdisplay(Clock, Reset, counter1, counter2, lightOn1, lightOn2);
	input Clock, Reset;
	input [2:0] counter1, counter2;
	reg [6:0] PS, NS;
	output reg[6:0] lightOn1, lightOn2;
	
	parameter [6:0] zero = 7'b1000000, 	one = 7'b1111001,		two = 7'b0100100,
						 three = 7'b0110000, four = 7'b0011001, 	five = 7'b0010010,
						 six = 7'b0000010, 	seven = 7'b1111000;
	
	always @(*) begin
		case (counter1)
			3'b000:	lightOn1 = zero;
			3'b001:	lightOn1 = one;
			3'b010:	lightOn1 = two;
			3'b011:	lightOn1 = three;
			3'b100:	lightOn1 = four;
			3'b101:	lightOn1 = five;
			3'b110:	lightOn1 = six;
			3'b111:	lightOn1 = seven;
		endcase
		
		case (counter2)
			3'b000:	lightOn2 = zero;
			3'b001:	lightOn2 = one;
			3'b010:	lightOn2 = two;
			3'b011:	lightOn2 = three;
			3'b100:	lightOn2 = four;
			3'b101:	lightOn2 = five;
			3'b110:	lightOn2 = six;
			3'b111:	lightOn2 = seven;
		endcase
	end
endmodule


module Lab3_testbench();
	reg CLOCK_50;
	reg [9:0] SW;
	reg [3:0] KEY;
	reg [9:0] LEDR;
	reg [6:0] HEX0;
	

	
	Lab3 dut (CLOCK_50, SW, LEDR, KEY, HEX0);
	

	initial CLOCK_50 = 1;
	initial KEY[3:0] = 4'b1111;
	parameter CLOCK_PERIOD = 100;
	
	always begin
			#(CLOCK_PERIOD/2);
		CLOCK_50 = ~CLOCK_50;
	end

	
	
	initial begin
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
										
		// reset is off								
		SW[9] <= 0; 		@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
										
		// reset is on								
		SW[9] <= 1;			@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
		
		// reset is off
		SW[9] <= 0;
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
										
										
		KEY[0] <= 0; 			
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
										
		KEY[0] <= 1;
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
										
								KEY[0] <= 0; 				@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
										
		KEY[0] <= 1;		@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
										
								KEY[0] <= 0; 				@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
										
		KEY[0] <= 1;		@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
										
								KEY[0] <= 0; 				@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								
		KEY[0] <= 1;		@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
										
								KEY[0] <= 0; 				@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
										
		KEY[0] <= 1;		@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
										
								KEY[0] <= 0; 				@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
										
		KEY[0] <= 1;		@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);

		// reset is on								
		SW[9] <= 1;			@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
		
		// reset is off
		SW[9] <= 0;
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);
								@(posedge CLOCK_50);								
		

		
		$stop;
	end
endmodule


module centerLight_testbench();

	reg Clk, Reset;
	
	wire out;
	wire [3:0] KEY;
	wire [6:0] HEX;
	wire [9:0] LEDR;

	reg [9:0] SW;	
	reg NL, NR, L, R;
	centerLight dut(.Clock(Clk), .Reset(Reset), .L(L), .R(R), .NL(NL), .NR(NR), .lightOn(LEDR[5]));


	parameter CLOCK_PERIOD=100;

	initial Clk = 1;
	always begin
			#(CLOCK_PERIOD/2);
		Clk = ~Clk;
	end

	
	initial begin

		Reset <= 1; @(posedge Clk);
						@(posedge Clk);
						@(posedge Clk);
						@(posedge Clk);
						
						
		Reset <= 0;	@(posedge Clk);
						@(posedge Clk);
						@(posedge Clk);
						@(posedge Clk);
						
						
		L <= 1;		@(posedge Clk);
						@(posedge Clk);
						@(posedge Clk);
						@(posedge Clk);
						
						
		NR <= 1;		@(posedge Clk); 
						@(posedge Clk);
						@(posedge Clk);
						@(posedge Clk);
						@(posedge Clk);
						
						
		NR <= 0;		@(posedge Clk);
						@(posedge Clk);
						@(posedge Clk);	
						@(posedge Clk);
						@(posedge Clk);
						
						
		L <= 0;		@(posedge Clk); 
						@(posedge Clk);
						@(posedge Clk);
						@(posedge Clk);
	
	
		R <= 1;		@(posedge Clk);
						@(posedge Clk);
						@(posedge Clk);
						@(posedge Clk);
						
						
		NL <= 1; 	@(posedge Clk); 
						@(posedge Clk);
						@(posedge Clk);
						@(posedge Clk);
						
						
		NL <= 0;		@(posedge Clk);
						@(posedge Clk);
						@(posedge Clk);
						@(posedge Clk);
						@(posedge Clk);
						
						
		R <= 0;		@(posedge Clk);
						@(posedge Clk);
						@(posedge Clk);
					   @(posedge Clk);
										
		$stop;
	end
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
 
 
 
