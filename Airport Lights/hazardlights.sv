// William Thing

module hazardlights (CLOCK_50,SW, LEDR,KEY); 
	input CLOCK_50; 
	input [1:0] SW;
	input [1:0] KEY;
	output [2:0] LEDR;
	wire [31:0] clk;
	wire [2:0]  out;
	parameter whichClock = 23; 	
	light_fsm go (clk[whichClock], SW, LEDR,~KEY[0]); 
	//light_fsm eq (CLOCK_50, SW, LEDR,); 
	clock_divider cdiv (CLOCK_50, clk);   
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

module light_fsm (Clock,SW, out, Reset);
	input Clock, Reset; 
	input [1:0] SW;
	output reg [2:0] out;
	wire Reset; 
	reg [1:0] PS; // Present State
	reg [1:0] NS; // Next State
	
	parameter [3:0] ends = 2'b00, mid = 2'b01, lft = 2'b10, rgt = 2'b11;
	
	// Next State Logic
	always @(*)
		case(PS)
			ends: if(~SW[1] & ~SW[0])         NS = mid;
					else if (~SW[1] & SW[0])    NS= rgt; // right2left
					else if (SW[1] & ~SW[0])    NS= lft; // left2right
					else NS=PS;
			
			mid:  if (~SW[1] & ~SW[0])        NS = ends;
					else if (~SW[1] & SW[0])    NS =lft;
					else if (SW[1] & ~SW[0])    NS = rgt;
					else NS=PS;
			lft:  if (~SW[1] & ~SW[0])        NS = ends;
					else if (~SW[1] & SW[0])    NS = rgt;
					else if (SW[1] & ~SW[0])    NS= mid;
					else NS=PS;
			rgt: 	if (~SW[1] & ~SW[0])        NS = ends;
					else if (~SW[1] & SW[0])    NS = mid;
					else if (SW[1] & ~SW[0])    NS= lft;
					else NS=PS;
			default: NS =2'bxx;
		endcase
	
	//Output Logic
	always @(posedge Clock) begin
		if(PS == ends) out = 3'b101;
		if (PS == mid) out = 3'b010;
		if (PS == lft) out = 3'b100;
		if (PS == rgt) out = 3'b001;
		PS = NS;
		if (Reset) PS=1;
		end
	

endmodule

// Flip Flop
module D_FF (Q, d, reset, clk);
	output Q;
	input d, reset, clk;
	reg Q; // Indicate that q is stateholding
	
	always @(posedge clk or posedge reset)
	if (reset)
		Q = 0; // On reset, set to 0
	else
		Q = d; // Otherwise out = d
endmodule

// 
module hazardlights_testbench();
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
