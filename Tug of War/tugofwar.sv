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
