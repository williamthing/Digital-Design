module move_light (Clock, Reset, current, next);
	input Clock, Reset;
	output reg next;
	wire PS;
	reg NS;
	input current;
	
	parameter on = 1'b1, off = 1'b0;
	
	// assignment statement
	always @(*)
	case(PS)
		on: 	if (current) NS = on;
				else NS = off;
		off:	if (current) NS = on;
				else NS = off;
		default: NS = 1'bx;
	endcase
	
	// what will happen
	always @(PS)
		case(PS)
			on: next = 1;
			off: next = 0;
			default: next = 1'bx;
	endcase
	
	always @(posedge Clock)
		if (Reset) 
			PS <= off;
		else 
			PS <= NS;
	
endmodule

module move_light_testbench();
	reg clk, Reset, in;
	wire Out;

	move_light dut(clk, Reset, in, Out);
	
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
		in <= 0;		@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						
		in <= 1;		@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						
		in <= 0;		@(posedge clk);
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
