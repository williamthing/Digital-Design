module scoreKeeper(Clock, Reset, OlightOn, lastlightOn, key, add1, add2, sub2);
	input Clock, Reset;
	input key, OlightOn, lastlightOn;
	output reg add1, add2, sub2;
	
	wire [1:0] PS;
	reg [1:0] NS;
	
	parameter [1:0] none = 2'b00, plus1 = 2'b01, plus2 = 2'b10, minus2 = 2'b11;
	
	always @ (PS or OlightOn or lastlightOn or key) 
	begin
		
		case (PS)
			none: if (OlightOn & key) 
						NS = plus2;
				   else if (lastlightOn & key) 
						NS = plus1;
				   else if ((key & ~OlightOn) | (key & ~lastlightOn)) 
						NS = minus2;
					else 
						NS = none;
			
			plus1:if (OlightOn & key) 
						NS = plus2;
				   else if (lastlightOn & key) 
						NS = plus1;
				   else if ((key & ~OlightOn) | (key & ~lastlightOn)) 
						NS = minus2;
					else 
						NS = none;
			
			plus2: if (OlightOn & key) 
						NS = plus2;
				   else if (lastlightOn & key) 
						NS = plus1;
				   else if ((key & ~OlightOn) | (key & ~lastlightOn)) 
						NS = minus2;
					else 
						NS = none;
			
			minus2:if (OlightOn & key) 
						NS = plus2;
				   else if (lastlightOn & key) 
						NS = plus1;
				   else if ((key & ~OlightOn) | (key & ~lastlightOn)) 
						NS = minus2;
					else 
						NS = none;
			
			default: NS = 2'bx;
		endcase
	end
	
	always @ (PS) begin
		case (PS)
			none:  begin
						add1 = 0; add2 = 0; sub2 = 0;
					end
			
			plus1: begin
						add1 = 1; add2 = 0; sub2 = 0;
					end
			
			plus2: begin
						add1 = 0; add2 = 1; sub2 = 0;
					end
			
			minus2: begin
						add1 = 0; add2 = 0; sub2 = 1;
					end
			
			default: begin 
							add1 = 1'bx; add2 = 1'bx; sub2 = 1'bx;
						end
			
		endcase
	end
		
	D_FF D1(.q(PS[0]), .d(NS[0]), .reset(Reset), .clk(Clock));
	D_FF D2(.q(PS[1]), .d(NS[1]), .reset(Reset), .clk(Clock));
	
endmodule

module scoreKeeper_testbench();
	reg clk, Reset, in1, in2, key1, add1, add2, sub2;
	wire Out;

	scoreKeeper dut(clk, Reset, in1, in2, key1, add1, add2, sub2);
	
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
		in1 <= 0;	@(posedge clk);
						@(posedge clk);
		in1 <= 1;	@(posedge clk);
						@(posedge clk);
						@(posedge clk); 
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						
		key1 <= 0;	@(posedge clk);
						@(posedge clk);
						@(posedge clk); 
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						
		key1 <= 1;	@(posedge clk);
						@(posedge clk);
						@(posedge clk); 
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						
		key1 <= 0;	@(posedge clk);
						@(posedge clk);
						@(posedge clk); 
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk); 
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
		in1 <= 0;	@(posedge clk);		
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
