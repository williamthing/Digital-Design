// William Thing

// Top-level module that defines the I/Os for the DE-1 SoC board
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
output [9:0] LEDR;
input [3:0] KEY;
input [9:0] SW;

// Default values, turns off the HEX displays
assign HEX0 = 7'b1111111;	// turns HEX DISPLAY all off
assign HEX1 = 7'b1111111;
assign HEX2 = 7'b1111111;
assign HEX3 = 7'b1111111;
assign HEX4 = 7'b1111111;
assign HEX5 = 7'b1111111;
// Logic to check if SW[3]..SW[0] match your bottom digit,
// and SW[7]..SW[4] match the next.
// Result should drive LEDR[0].
//assign LEDR[0] = ~(~(~SW[0] & sSW[1]) | ~(SW[2] & SW[3]));  // LED array 0 signifies the 0, displays true for input 7 NOTE** They don't want this way

// recognizer for input of 7
wire w1, w2, w3, f1;			// creating wires to save gate output
not (w1, SW[3]);				// assigns w1
nand (w2, w1, SW[2]);			// assign w2
nand (w3, SW[0], SW[1]);		// asign w3
nor (f1, w2, w3);				// puts into output f1

// recognizer for input of 8
wire x1, x2, f2;
nor (x1, SW[5], SW[6]);
nand (x2, x1, SW[7]);
nor (f2, x2, SW[4]);

// combines to output if 8 and 7 true
and (LEDR[0], f1, f2);

endmodule

// Test Bench
module DE1_SoC_testbench();
wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
wire [9:0] LEDR;
reg [3:0] KEY;
reg [9:0] SW;
DE1_SoC dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR,
.SW);
// Try all combinations of inputs.
integer i;
initial begin
SW[9] = 1'b0;
SW[8] = 1'b0;
for(i = 0; i <256; i++) begin
SW[7:0] = i; #10;
end
end
endmodule