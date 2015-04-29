// William Thing

// Top-level module that defines the I/Os for the DE-1 SoC board
module Lab3 (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, SW);
output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
output [1:0] LEDR;
input [7:0] SW;	// 4 switches for UPCM but keeping 9 but turning off in tb

assign HEX2 = 7'b1111111;
assign HEX3 = 7'b1111111;
assign HEX4 = 7'b1111111;
assign HEX5 = 7'b1111111;
seg7 mod1 (SW[3:0], HEX0[6:0]);
seg7 mod2 (SW[7:4], HEX1[6:0]);

//mystore store (SW[2:0], HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
//labint detector (LEDR[1:0], SW[3:0]);

endmodule
