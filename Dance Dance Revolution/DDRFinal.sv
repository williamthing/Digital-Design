// William Thing
// Final Project

module DDR(CLOCK_50, SW, LEDR, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, GPIO_0); 
	input CLOCK_50; 
	input [9:0] SW;
	input [3:0] KEY;
	inout [35:0] GPIO_0;
	output reg [9:0] LEDR;
	output reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	// clock divider 
	parameter whichClock = 4; // change to 0 for testbenches
	wire [31:0] clk;
	clock_divider cdiv (CLOCK_50, clk);
	
	wire oo;
	twentyBitCounter(clk[whichClock], SW[9], 0, 0, oo);
	
	wire [7:0] ROW, GREEN, RED;
	
	wire trig0, trig1, trig2, trig3;
	
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
	assign GPIO_0[17] = RED[2];
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
	//LFSR randled (oo, SW[1], r1);
	
	/*
	// extra feature: fancy LEDR
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
	
	wire add3_2, add3_1, add3_0;
	
	// column 3
	move_light col3_0 (oo, SW[9], r[0], 						green_array[7][3]);
	move_light col3_1 (oo, SW[9], green_array[7][3], green_array[6][3]);
	move_light col3_2 (oo, SW[9], green_array[6][3], green_array[5][3]);
	move_light col3_3 (oo, SW[9], green_array[5][3], green_array[4][3]);
	move_light col3_4 (oo, SW[9], green_array[4][3], green_array[3][3]);
	move_light col3_5 (oo, SW[9], green_array[3][3], green_array[2][3]);
	// diff
	move_light_last col3_6 (oo, SW[9], add3_2, green_array[2][3], red_array[1][3]);
	
	move_light col3_7_green (oo, SW[9], red_array[1][3], green_array[0][3]);
	move_light col3_7_red (oo, SW[9], red_array[1][3], red_array[0][3]);
	
	scoreKeeper score3(clk[whichClock], SW[9], red_array[1][3], green_array[0][3], trig0, add3_2, add3_1, add3_0);
	
	
	
	//wire signal2_2, signal2_1, signal2_0;
	wire add2_2, add2_1, add2_0;
	
	// column 2
	move_light col2_0 (oo, SW[9], r[1], 						green_array[7][2]);
	move_light col2_1 (oo, SW[9], green_array[7][2], green_array[6][2]);
	move_light col2_2 (oo, SW[9], green_array[6][2], green_array[5][2]);
	move_light col2_3 (oo, SW[9], green_array[5][2], green_array[4][2]);
	move_light col2_4 (oo, SW[9], green_array[4][2], green_array[3][2]);
	move_light col2_5 (oo, SW[9], green_array[3][2], green_array[2][2]);
	
	// diff
	move_light_last col2_6 (oo, SW[9], add2_2, green_array[2][2], red_array[1][2]);
	
	move_light col2_7_green (oo, SW[9], red_array[1][2], green_array[0][2]);
	move_light col2_7_red (oo, SW[9], red_array[1][2], red_array[0][2]);
	
	scoreKeeper score2(clk[whichClock], SW[9], red_array[1][2], green_array[0][2], trig1, add2_2, add2_1, add2_0);
	
	
	
	//wire signal1_2, signal1_1, signal1_0;
	wire add1_2, add1_1, add1_0;
	
	// column 1
	move_light col1_0 (oo, SW[9], r[2], 						green_array[7][1]);
	move_light col1_1 (oo, SW[9], green_array[7][1], green_array[6][1]);
	move_light col1_2 (oo, SW[9], green_array[6][1], green_array[5][1]);
	move_light col1_3 (oo, SW[9], green_array[5][1], green_array[4][1]);
	move_light col1_4 (oo, SW[9], green_array[4][1], green_array[3][1]);
	move_light col1_5 (oo, SW[9], green_array[3][1], green_array[2][1]);
	// diff
	move_light_last col1_6 (oo, SW[9], add1_2, green_array[2][1], red_array[1][1]);
	
	move_light col1_7 (oo, SW[9], red_array[1][1], green_array[0][1]);
	move_light col1_7_red (oo, SW[9], red_array[1][1], red_array[0][1]);
	
	scoreKeeper score1(clk[whichClock], SW[9], red_array[1][1], green_array[0][1], trig2, add1_2, add1_1, add1_0);
	
	
	//wire signal0_2, signal0_1, signal0_0;
	wire add0_2, add0_1, add0_0;
	
	// column 0
	move_light col0_0 (oo, SW[9], r[3], 						green_array[7][0]);
	move_light col0_1 (oo, SW[9], green_array[7][0], green_array[6][0]);
	move_light col0_2 (oo, SW[9], green_array[6][0], green_array[5][0]);
	move_light col0_3 (oo, SW[9], green_array[5][0], green_array[4][0]);
	move_light col0_4 (oo, SW[9], green_array[4][0], green_array[3][0]);
	move_light col0_5 (oo, SW[9], green_array[3][0], green_array[2][0]);
	// diff
	move_light_last col0_6 (oo, SW[9], add0_2, green_array[2][0], red_array[1][0]);
	
	move_light col0_7 (oo, SW[9], red_array[1][0], green_array[0][0]);
	move_light col0_7_red (oo, SW[9], red_array[1][0], red_array[0][0]);

	
	scoreKeeper score0(clk[whichClock], SW[9], red_array[1][0], green_array[0][0], trig3 , add0_2, add0_1, add0_0);
	
	
	// 1 place
	wire firstPos, firstNeg;

	// 10 place
	wire tenPos, tenNeg;
	
	// 100 place
	wire hundredPos, hundredNeg;
	
	// 1000 place
	wire thousandPos, thousandNeg;
	
	// 10000 place
	wire tenThousandPos, tenThousandNeg;
	
	// 100000 place
	wire hundredThousandPos, hundredThousandNeg;

	
	// small swap incorrect naming
	// red = 2pts orange = 1pts other = -2pts
	wire add_2, add_1, sub_2;
	
	assign add_2 = add0_2 | add1_2 | add2_2 | add3_2;
	assign add_1 = add0_1 | add1_1 | add2_1 | add3_1;
	assign sub_2 = add0_0 | add1_0 | add2_0 | add3_0;
	
	scoreCounterForOne count1(clk[whichClock], SW[9], HEX1, add_1, add_2, sub_2, firstPos, firstNeg, HEX0);
	scoreCounter count10(clk[whichClock], SW[9], firstPos, firstNeg, HEX2, tenPos, tenNeg, HEX1);
	scoreCounter count100(clk[whichClock], SW[9], tenPos, tenNeg, HEX3, hundredPos, hundredNeg, HEX2);
	scoreCounter count1000(clk[whichClock], SW[9], hundredPos, hundredNeg, HEX4, thousandPos, thousandNeg, HEX3);
	scoreCounter count10000(clk[whichClock], SW[9], thousandPos, thousandNeg, HEX5, tenThousandPos, tenThousandNeg, HEX4);
	scoreCounter count100000(clk[whichClock], SW[9], tenThousandPos, tenThousandNeg, otherLeds, hundredThousandPos, hundredThousandNeg, HEX5);
	
	// user input
	button userinput0(clk[whichClock], SW[9], ~KEY[0], trig0);
	button userinput1(clk[whichClock], SW[9], ~KEY[1], trig1);
	button userinput2(clk[whichClock], SW[9], ~KEY[2], trig2);
	button userinput3(clk[whichClock], SW[9], ~KEY[3], trig3);
	
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

// controller for LED MATRIX 
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


// LFSR TESTBENCH
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
 
// DDR testbench, odd remarks when compiling, giving errors in button and
// GPIO 
module DDR_testbench();
	reg CLOCK_50; 
	reg [9:0] SW;
   reg [3:0] KEY;
	reg [35:0] GPIO_0;
	reg [9:0] LEDR;
	reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	/*
		input CLOCK_50; 
	input [9:0] SW;
	input [3:0] KEY;
	inout [35:0] GPIO_0;
	output reg [9:0] LEDR;
	output reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	*/

	
	Lab3 dut (.CLOCK_50, .SW, .LEDR, .KEY, .HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .GPIO_0);
	
	parameter CLOCK_PERIOD=100;
	initial CLOCK_50=1;
	initial KEY[3:0]=4'b1111;
	
	always begin
			#(CLOCK_PERIOD/2);
		CLOCK_50 = ~CLOCK_50;
	end
	initial begin
										@(posedge CLOCK_50);
		SW[9] <= 0;					@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[3:0] <= 1;				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		SW[9] <= 1; 				@(posedge CLOCK_50);
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
										
		KEY[1] <= 0; 				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										
		KEY[1] <= 1;				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										
		KEY[1] <= 0; 				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										
		KEY[1] <= 1;				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										
		KEY[1] <= 0; 				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										
		KEY[2] <= 1;				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										
		KEY[2] <= 0; 				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										
		KEY[2] <= 1;				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[2] <= 0;		 		@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		
		KEY[2] <= 1;				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										
		KEY[3] <= 0; 				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										
		KEY[3] <= 1;				@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
										@(posedge CLOCK_50);
		KEY[3] <= 0;		 		@(posedge CLOCK_50);
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
