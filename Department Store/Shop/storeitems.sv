// William Thing

// Top-level module that defines the I/Os for the DE-1 SoC board
module Lab3 (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR, SW);
output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
output [1:0] LEDR;
input [7:0] SW;	// 4 switches for UPCM but keeping 9 but turning off in tb

/* Just changing first two hex displays

assign HEX2 = 7'b1111111;
assign HEX3 = 7'b1111111;
assign HEX4 = 7'b1111111;
assign HEX5 = 7'b1111111;
seg7 mod1 (SW[3:0], HEX0[6:0]);
seg7 mod2 (SW[7:4], HEX1[6:0]);
*/

mystore store (SW[2:0], HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
labint detector (LEDR[1:0], SW[3:0]);

endmodule

module seg7 (bcd, leds);
input [3:0] bcd;
output reg [6:0] leds;
always @(*)
case (bcd)
// Light: 6543210

4'b0000: leds = 7'b1000000; // 0 active low
4'b0001: leds = 7'b1111001; // 1 active low
4'b0010: leds = 7'b0100100; // 2 active low
4'b0011: leds = 7'b0110000; // 3 active low
4'b0100: leds = 7'b0011001; // 4 active low
4'b0101: leds = 7'b0010010; // 5 active low
4'b0110: leds = 7'b0000010; // 6 active low
4'b0111: leds = 7'b1111000; // 7 active low
4'b1000: leds = 7'b0000000; // 8 active low
4'b1001: leds = 7'b0010000; // 9 active low
default: leds = 7'bX;
// uses endcase because of case statement
endcase
endmodule
