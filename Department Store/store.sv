// William Thing
// EE271
// LAB 3

// Top-level module that defines the I/Os for the DE-1 SoC board
module Lab3 (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
output [1:0] LEDR;
input [3:0] KEY;	// Turns off Keys
input [9:0] SW;	// 4 switches for UPCM but keeping 9 but turning off in tb

// Default values, turns off the HEX displays
assign HEX0 = 7'b1111111;	// turns HEX DISPLAY all off
assign HEX1 = 7'b1111111;
assign HEX2 = 7'b1111111;
assign HEX3 = 7'b1111111;
assign HEX4 = 7'b1111111;
assign HEX5 = 7'b1111111;

wire A, B, C, X;

// Stolen or Not
not(A, SW[0]);
nor(B, A, SW[1], SW[3]);
nor(C, SW[0], SW[2], SW[3]);
or(LEDR[0], B, C);

// Discounted
and(X, SW[0], SW[2]);
or(LEDR[1], SW[1], X);

endmodule

// Test Bench
module Lab3_testbench();
wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
wire [1:0] LEDR;
reg [3:0] KEY;
reg [9:0] SW;
Lab3 dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .KEY, .LEDR,
.SW);
// Try all combinations of inputs.
integer i;
initial begin
// set these switches to not being used
SW[9] = 1'b0;
SW[8] = 1'b0;
SW[7] = 1'b0;
SW[6] = 1'b0;
SW[5] = 1'b0;
SW[4] = 1'b0;

for(i = 0; i < 16; i++) begin
SW[3:0] = i; #10;
end
end
endmodule