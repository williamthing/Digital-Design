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

module mystore (item, out0, out1, out2, out3, out4, out5);
input [2:0] item;
output reg [6:0] out0, out1, out2, out3, out4, out5;

always @(*)
case (item)

// ring
3'b000: 
begin
out0 = 7'b1111111;
out1 = 7'b1111111;
out2 = 7'b0010000;
out3 = 7'b1001000;
out4 = 7'b1001111;
out5 = 7'b1001110;
end

// ball
3'b100:
begin
out0 = 7'b1111111;
out1 = 7'b1111111;
out2 = 7'b1000111;
out3 = 7'b1000111;
out4 = 7'b0001000;
out5 = 7'b0000000;
end

// boob
3'b110:
begin
out0 = 7'b1111111;
out1 = 7'b1111111;
out2 = 7'b0000000;
out3 = 7'b1000000;
out4 = 7'b1000000;
out5 = 7'b0000000;
end

// glasses
3'b001:
begin
out0 = 7'b1111111;
out1 = 7'b0111011;
out2 = 7'b0111011;
out3 = 7'b1000000;
out4 = 7'b0111111;
out5 = 7'b1000000;
end

// PC
3'b101:
begin
out0 = 7'b1111111;
out1 = 7'b1111111;
out2 = 7'b1111111;
out3 = 7'b1111111;
out4 = 7'b1000110;
out5 = 7'b0001100;
end

// Chair
3'b011:
begin
out0 = 7'b1111111;
out1 = 7'b1001110;
out2 = 7'b1001111;
out3 = 7'b0001000;
out4 = 7'b0001001;
out5 = 7'b1000110;
end


default:
begin
out0 = 7'bX;
out1 = 7'bX;
out2 = 7'bX;
out3 = 7'bX;
out4 = 7'bX;
out5 = 7'bX;
end

endcase
endmodule

// lab3 integration
module labint (lit, swatch);
output [1:0] lit;
input [3:0] swatch;

wire A, B, C, X;

// Stolen or Not
not(A, swatch[0]);
nor(B, A, swatch[1], swatch[3]);
nor(C, swatch[0], swatch[2], swatch[3]);
or(lit[0], B, C);

// Discounted
and(X, swatch[0], swatch[2]);
or(lit[1], swatch[1], X);

endmodule

// test bench
module Lab3_testbench();
wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
wire [1:0] LEDR;
reg [7:0] SW;
Lab3 dut (.HEX0, .HEX1, .HEX2, .HEX3, .HEX4, .HEX5, .LEDR,
.SW);
// Try all combinations of inputs.
integer i;
initial begin
// set these switches to not being used


for(i = 0; i < 16; i++) begin
SW[3:0] = i; #10;
end
end
endmodule
