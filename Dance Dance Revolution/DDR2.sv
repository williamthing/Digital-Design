// William Thing
// Lab 7

module Lab3(CLOCK_50, SW, LEDR, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, GPIO_0); 
	input CLOCK_50; 
	input [9:0] SW;
	input [3:0] KEY;
	inout [35:0] GPIO_0;
	output reg [9:0] LEDR;
	output reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	// clock divider 
	parameter whichClock = 5; // change to 0 for testbenches
	wire [31:0] clk;
	clock_divider cdiv (CLOCK_50, clk);
	
	
	wire [7:0] ROW, GREEN, RED;
	
	// assign LED DISPLAY FOR THE ROWS
	assign GPIO_0[9] = ROW[0];
	assign GPIO_0[8] = ROW[1];
	assign GPIO_0[7] = ROW[2];
	assign GPIO_0[6] = ROW[3];
	assign GPIO_0[0] = ROW[4];
	assign GPIO_0[5] = ROW[5];
	assign GPIO_0[4] = ROW[6];
	assign GPIO_0[3] = ROW[7];
	
	// assign LED DISPLAY FOR THE GREEN (COLS)
	assign GPIO_0[35] = GREEN[0];
	assign GPIO_0[33] = GREEN[1];
	assign GPIO_0[31] = GREEN[2];
	assign GPIO_0[18] = GREEN[3];

	// assign LED Display for RED (COLS)
	assign GPIO_0[34] = RED[0];
	assign GPIO_0[32] = RED[1];
	assign GPIO_0[30] = RED[2];
	assign GPIO_0[28] = RED[3];
	
	reg [7:0][7:0] green_array, red_array;
	
	// only the 4 least significant bits means something
	// 1000 = most right light on
	// 0001 = most left light on
	// first index refers to the bottom of the led display
	/*
	initial green_array = {	8'b0000000,
									8'b0000000,
									8'b0000000,
									8'b0000000,
									8'b0000000,
									8'b0000000,
									8'b0000000,
									8'b0000000};
	
	initial red_array = {	8'b0000000,
									8'b0000000,
									8'b0000000,
									8'b0000000,
									8'b0000000,
									8'b0000000,
									8'b0000000,
									8'b0000000};
									*/
									
	
	// LED MATRIX DISPLAY
	led_matrix_driver test (clk[whichClock], red_array, green_array, RED[7:0], GREEN[7:0], ROW);
	
	
	wire [8:0] r, r1;
	// rand
	LFSR random (clk[whichClock], SW[1], r);
	LFSR randled (oo, SW[1], r1);
	
	/*
	// fancy LEDR
	assign LEDR[0] = r1[1];
	assign LEDR[9] = r1[1];
	assign LEDR[1] = r1[2];
	assign LEDR[8] = r1[2];
	assign LEDR[2] = r1[5];
	assign LEDR[7] = r1[5];
	assign LEDR[3] = r1[3];
	assign LEDR[6] = r1[3];
	assign LEDR[4] = r1[4];
	assign LEDR[5] = r1[4];
	*/
	
	wire signal3_2, signal3_1, signal3_0;
	
	// column 3
	move_light col3_0 (oo, SW[9], r[1], 						green_array[7][3]);
	move_light col3_1 (oo, SW[9], green_array[7][3], green_array[6][3]);
	move_light col3_2 (oo, SW[9], green_array[6][3], green_array[5][3]);
	move_light col3_3 (oo, SW[9], green_array[5][3], green_array[4][3]);
	move_light col3_4 (oo, SW[9], green_array[4][3], green_array[3][3]);
	move_light col3_5 (oo, SW[9], green_array[3][3], green_array[2][3]);
	// diff
	move_light col3_6 (oo, (SW[9] | signal3_2), green_array[2][3], red_array[1][3]);
	
	move_light col3_7_green (oo, (SW[9] | signal3_1), red_array[1][3], green_array[0][3]);
	move_light col3_7_red (oo, (SW[9] | signal3_1), red_array[1][3], red_array[0][3]);
	
	scoreKeeper score3(clk[whichClock], SW[9], trig0, green_array[0][3], red_array[1][3], signal3_2, signal3_1, signal3_0);
	
	
	wire signal2_2, signal2_1;
	
	// column 2
	move_light col2_0 (oo, SW[9], r[2], 						green_array[7][2]);
	move_light col2_1 (oo, SW[9], green_array[7][2], green_array[6][2]);
	move_light col2_2 (oo, SW[9], green_array[6][2], green_array[5][2]);
	move_light col2_3 (oo, SW[9], green_array[5][2], green_array[4][2]);
	move_light col2_4 (oo, SW[9], green_array[4][2], green_array[3][2]);
	move_light col2_5 (oo, SW[9], green_array[3][2], green_array[2][2]);
	
	// diff
	move_light col2_6 (oo, (SW[9] | signal2_2), green_array[2][2], red_array[1][2]);
	
	move_light col2_7_green (oo, (SW[9] | signal2_1), red_array[1][2], green_array[0][2]);
	move_light col2_7_red (oo, (SW[9] | signal3_1), red_array[1][2], red_array[0][2]);
	
	scoreKeeper score2(clk[whichClock], SW[9], trig1, green_array[0][2], red_array[1][2], signal2_2, signal2_1, signal2_0);
	
	
	wire signal1_2, signal1_1;
	
	// column 1
	move_light col1_0 (oo, SW[9], r[3], 						green_array[7][1]);
	move_light col1_1 (oo, SW[9], green_array[7][1], green_array[6][1]);
	move_light col1_2 (oo, SW[9], green_array[6][1], green_array[5][1]);
	move_light col1_3 (oo, SW[9], green_array[5][1], green_array[4][1]);
	move_light col1_4 (oo, (SW[9] | signal0_2), green_array[4][1], green_array[3][1]);
	move_light col1_5 (oo, (SW[9] | signal0_2), green_array[3][1], green_array[2][1]);
	// diff
	move_light col1_6 (oo, (SW[9] | signal1_2), green_array[2][1], red_array[1][1]);
	
	move_light col1_7 (oo, (SW[9] | signal1_1), red_array[1][1], green_array[0][1]);
	move_light col1_7_red (oo, (SW[9] | signal3_1), red_array[1][1], red_array[0][1]);
	
	scoreKeeper score1(clk[whichClock], SW[9], trig2, green_array[0][1], red_array[1][1], signal1_2, signal1_1, signal1_0);
	
	
	wire signal0_2, signal0_1;
	
	// column 0
	move_light col0_0 (oo, SW[9], r[4], 						green_array[7][0]);
	move_light col0_1 (oo, SW[9], green_array[7][0], green_array[6][0]);
	move_light col0_2 (oo, SW[9], green_array[6][0], green_array[5][0]);
	move_light col0_3 (oo, SW[9], green_array[5][0], green_array[4][0]);
	move_light col0_4 (oo, SW[9], green_array[4][0], green_array[3][0]);
	move_light col0_5 (oo, SW[9], green_array[3][0], green_array[2][0]);
	// diff
	move_light col0_6 (oo, (SW[9] | signal0_2), green_array[2][0], red_array[1][0]);
	
	move_light col0_7 (oo, (SW[9] | signal0_1), red_array[1][0], green_array[0][0]);
	move_light col0_7_red (oo, (SW[9] | signal0_1), red_array[1][0], red_array[0][0]);

	scoreKeeper score0(clk[whichClock], SW[9], trig3, green_array[0][0], red_array[1][0], signal0_2, signal0_1, signal0_0);
	
	wire oo;
	twentyBitCounter(clk[whichClock], SW[9], 0, 0, oo);
	
	// user input
	wire trig0, trig1, trig2, trig3;
	button userinput0(clk[whichClock], SW[9], ~KEY[0], trig0);
//	button userinput1(clk[whichClock], SW[9], ~KEY[1], trig1);
//	button userinput2(clk[whichClock], SW[9], ~KEY[2], trig2);
//	button userinput3(clk[whichClock], SW[9], ~KEY[3], trig3);
	
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

// 
module led_matrix_driver (clock, red_array, green_array, red_driver, green_driver, row_sink);
		input clock;
		input [7:0][7:0] red_array, green_array;
		output reg [7:0] red_driver, green_driver, row_sink;
		reg [2:0] count;
		always @(posedge clock)
		count <= count + 3'b001;
		always @(*)
			case (count)
				3'b000: row_sink = 8'b11111110;
				3'b001: row_sink = 8'b11111101;
				3'b010: row_sink = 8'b11111011;
				3'b011: row_sink = 8'b11110111;
				3'b100: row_sink = 8'b11101111;
				3'b101: row_sink = 8'b11011111;
				3'b110: row_sink = 8'b10111111;
				3'b111: row_sink = 8'b01111111;
			endcase
		assign red_driver = red_array[count];
		assign green_driver = green_array[count];
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
						@(posedge clk); 
						@(posedge clk); 
						@(posedge clk); 
						@(posedge clk);	
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
						@(posedge clk); 
						@(posedge clk); 
						@(posedge clk); 
						@(posedge clk);
		Reset <= 0; @(posedge clk);
						@(posedge clk); 
						@(posedge clk); 
						@(posedge clk); 
						@(posedge clk); 
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

module winnerDetect_testbench();
	reg A, B, L, R;
	wire winL, winR;
	
	winnerDetect dut(A, B, L, R, winL, winR);
	
	parameter d = 20;
	
	initial begin
		A = 0;
		B = 0;
		L = 0;
		R = 0;
	end
	
	reg [4:0] i;
	initial begin
	#d; 
		for(i = 0; ~i[4]; i = i + 1) begin
			{A, B, L, R} = i[3:0];
			#d;
		end
	end
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


module button_testbench();
	reg reset, clk;
	reg w;
	wire out;
	
	button dut(clk, reset, w, out);
	
	parameter CLOCK_PERIOD=100; 
	initial clk=1; 
	always begin 
		#(CLOCK_PERIOD/2); 
		clk = ~clk; 
	end 
	
	initial begin 
										@(posedge clk);
		reset <= 1; 				@(posedge clk);
		reset <= 0; w <= 1'b0;	@(posedge clk); 
										@(posedge clk); 
										@(posedge clk);
										@(posedge clk); 
										@(posedge clk);
						w <= 1'b1;	@(posedge clk);
										@(posedge clk);
										@(posedge clk);
										@(posedge clk); 
										@(posedge clk);
						w <= 2'b0;	@(posedge clk);
										@(posedge clk);
										@(posedge clk);
										@(posedge clk); 
										@(posedge clk);
						w <= 2'b1;	@(posedge clk);
										@(posedge clk);
										@(posedge clk); 
										@(posedge clk);
		reset <= 1;					@(posedge clk);
										@(posedge clk);
										@(posedge clk); 
										@(posedge clk);
		reset <= 0;					@(posedge clk);
										@(posedge clk);
										@(posedge clk); 
										@(posedge clk);
		$stop;
	end
	
endmodule 


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

// Clock, Reset, counter1, counter2, lightOn1, lightOn2
module hexdisplay_testbench();
	reg Clk, Reset;
	
	
	reg [2:0] c1, c2;
	
	wire [6:0] L1, L2;
	
	hexdisplay dut(Clk, Reset, c1, c2, L1, L2);


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
						
						
		c1 <= 3'b000;		
						@(posedge Clk);
						@(posedge Clk);
						@(posedge Clk);
						@(posedge Clk);
						
						
		c1 <= 3'b001;		
						@(posedge Clk); 
						@(posedge Clk);
						@(posedge Clk);
						@(posedge Clk);
						@(posedge Clk);
						
						
		c1 <= 3'b010;	
						@(posedge Clk);
						@(posedge Clk);
						@(posedge Clk);	
						@(posedge Clk);
						@(posedge Clk);
						
						
		c2 <= 3'b000;		
						@(posedge Clk);
						@(posedge Clk);
						@(posedge Clk);
						@(posedge Clk);
						
						
		c2 <= 3'b001;		
						@(posedge Clk); 
						@(posedge Clk);
						@(posedge Clk);
						@(posedge Clk);
						@(posedge Clk);
						
						
		c2 <= 3'b010;	
						@(posedge Clk);
						@(posedge Clk);
						@(posedge Clk);	
						@(posedge Clk);
						@(posedge Clk);
										
		$stop;
	end
endmodule

 
module Lab3_testbench();
	reg CLOCK_50;
	reg [9:1] LEDR;
	reg [6:0] HEX0,HEX5;
	reg [9:0] SW;
	reg [3:0] KEY;

	
	Lab3 dut (CLOCK_50, SW, LEDR, KEY, HEX0,HEX5);
	
	parameter CLOCK_PERIOD=100;
	initial CLOCK_50=1;
	initial KEY[3:0]=4'b1111;
	
	always begin
			#(CLOCK_PERIOD/2);
		CLOCK_50 = ~CLOCK_50;
	end
	initial begin
										@(posedge CLOCK_50);
		SW[9] <= 1;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		SW[8:0] <= 0;				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		SW[9] <= 0; 				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[0] <= 0; 				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										
		KEY[0] <= 1;				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										
		KEY[0] <= 0; 				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										
		KEY[0] <= 1;				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										
		KEY[0] <= 0; 				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										
		KEY[0] <= 1;				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										
		KEY[0] <= 0; 				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										
		KEY[0] <= 1;				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										
		KEY[0] <= 0; 				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										
		KEY[0] <= 1;				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										
		KEY[0] <= 0; 				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										
		KEY[0] <= 1;				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[0] <= 0;		 		@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										
	   SW[2] <= 1;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		SW[7] <= 1;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										
								
		SW[9] <= 1;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		SW[9] <= 0; 				
		
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);		

 		$stop; 
		end
endmodule
