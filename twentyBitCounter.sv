module twentyBitCounter(CLOCK, RESET, S, VAL, OUT);
	input CLOCK, RESET;
	input [2:0] VAL;
	input [19:0] S;
	output reg  OUT;

	wire [19:0] PS;
	reg [19:0] NS;
	
	always @ (PS)
		begin
			NS[0]  = ~PS[0];
			NS[1]  = PS[1]  ^ (PS[0]);
			NS[2]  = PS[2]  ^ (PS[1]&PS[0]);
			NS[3]  = PS[3]  ^ (PS[2]&PS[1]&PS[0]);
			NS[4]  = PS[4]  ^ (PS[3]&PS[2]&PS[1]&PS[0]);
			NS[5]  = PS[5]  ^ (PS[4]&PS[3]&PS[2]&PS[1]&PS[0]);
			NS[6]  = PS[6]  ^ (PS[5]&PS[4]&PS[3]&PS[2]&PS[1]&PS[0]);
			NS[7]  = PS[7]  ^ (PS[6]&PS[5]&PS[4]&PS[3]&PS[2]&PS[1]&PS[0]);
			NS[8]  = PS[8]  ^ (PS[7]&PS[6]&PS[5]&PS[4]&PS[3]&PS[2]&PS[1]&PS[0]);
			NS[9]  = PS[9]  ^ (PS[8]&PS[7]&PS[6]&PS[5]&PS[4]&PS[3]&PS[2]&PS[1]&PS[0]);
			NS[10] = PS[10] ^ (PS[9]&PS[8]&PS[7]&PS[6]&PS[5]&PS[4]&PS[3]&PS[2]&PS[1]&PS[0]);
			NS[11] = PS[11] ^ (PS[10]&PS[9]&PS[8]&PS[7]&PS[6]&PS[5]&PS[4]&PS[3]&PS[2]&PS[1]&PS[0]);
			NS[12] = PS[12] ^ (PS[11]&PS[10]&PS[9]&PS[8]&PS[7]&PS[6]&PS[5]&PS[4]&PS[3]&PS[2]&PS[1]&PS[0]);
			NS[13] = PS[13] ^ (PS[12]&PS[11]&PS[10]&PS[9]&PS[8]&PS[7]&PS[6]&PS[5]&PS[4]&PS[3]&PS[2]&PS[1]&PS[0]);
			NS[14] = PS[14] ^ (PS[13]&PS[12]&PS[11]&PS[10]&PS[9]&PS[8]&PS[7]&PS[6]&PS[5]&PS[4]&PS[3]&PS[2]&PS[1]&PS[0]);
			NS[15] = PS[15] ^ (PS[14]&PS[13]&PS[12]&PS[11]&PS[10]&PS[9]&PS[8]&PS[7]&PS[6]&PS[5]&PS[4]&PS[3]&PS[2]&PS[1]&PS[0]);
			NS[16] = PS[16] ^ (PS[15]&PS[14]&PS[13]&PS[12]&PS[11]&PS[10]&PS[9]&PS[8]&PS[7]&PS[6]&PS[5]&PS[4]&PS[3]&PS[2]&PS[1]&PS[0]);
			NS[17] = PS[17] ^ (PS[16]&PS[15]&PS[14]&PS[13]&PS[12]&PS[11]&PS[10]&PS[9]&PS[8]&PS[7]&PS[6]&PS[5]&PS[4]&PS[3]&PS[2]&PS[1]&PS[0]);
			NS[18] = PS[18] ^ (PS[17]&PS[16]&PS[15]&PS[14]&PS[13]&PS[12]&PS[11]&PS[10]&PS[9]&PS[8]&PS[7]&PS[6]&PS[5]&PS[4]&PS[3]&PS[2]&PS[1]&PS[0]);
			NS[19] = PS[19] ^ (PS[18]&PS[17]&PS[16]&PS[15]&PS[14]&PS[13]&PS[12]&PS[11]&PS[10]&PS[9]&PS[8]&PS[7]&PS[6]&PS[5]&PS[4]&PS[3]&PS[2]&PS[1]&PS[0]);
		end
	
	always @ (PS or VAL)
		begin
			if (VAL == 0) 
				OUT = (PS == S);
			else if (VAL == 1) 
				OUT = (PS == S) | (PS == 524288);
			else 
				OUT = (PS == S);
		end
		
	D_FF dff0 (PS[0], NS[0], RESET, CLOCK);
	
	D_FF dff1 (PS[1], NS[1], RESET, CLOCK);
	D_FF dff2 (PS[2], NS[2], RESET, CLOCK);
	D_FF dff3 (PS[3], NS[3], RESET, CLOCK);
	D_FF dff4 (PS[4], NS[4], RESET, CLOCK);
	D_FF dff5 (PS[5], NS[5], RESET, CLOCK);
	D_FF dff6 (PS[6], NS[6], RESET, CLOCK);
	D_FF dff7 (PS[7], NS[7], RESET, CLOCK);
	D_FF dff8 (PS[8], NS[8], RESET, CLOCK);
	D_FF dff9 (PS[9], NS[9], RESET, CLOCK);
	D_FF dff10 (PS[10], NS[10], RESET, CLOCK);
	D_FF dff11 (PS[11], NS[11], RESET, CLOCK);
	D_FF dff12 (PS[12], NS[12], RESET, CLOCK);
	D_FF dff13 (PS[13], NS[13], RESET, CLOCK);
	D_FF dff14 (PS[14], NS[14], RESET, CLOCK);
	D_FF dff15 (PS[15], NS[15], RESET, CLOCK);
	D_FF dff16 (PS[16], NS[16], RESET, CLOCK);
	D_FF dff17 (PS[17], NS[17], RESET, CLOCK);
	D_FF dff18 (PS[18], NS[18], RESET, CLOCK);
	D_FF dff19 (PS[19], NS[19], RESET, CLOCK);
	
endmodule

module twentyBitCounter_testbench();
	reg clk, Reset, in1, in2;
	wire Out;

	twentyBitCounter dut(clk, Reset, in1, in2, Out);
	
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
		in1 <= 0;	@(posedge clk);
		in2 <= 0;	@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
						@(posedge clk);
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
