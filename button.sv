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
