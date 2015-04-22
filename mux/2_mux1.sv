// William Thing
// module
module mux2_1(out, i0, i1, sel);
	output out;
	input i0, i1, sel;
	
	assign out = (i1 & sel) | (i0 & ~sel);
endmodule


// tester module
module mux2_1_testbench();
	reg i0, i1, sel;
	wire out;
	
	mux2_1 dut (.out, .i0, .i1, .sel);
	
	initial begin
		sel=0; i0=0; i1=0; #10;
		sel=0; i0=0; i1=1; #10;
		sel=0; i0=1; i1=0; #10;
		sel=0; i0=1; i1=1; #10;
		sel=1; i0=0; i1=0; #10;
		sel=1; i0=0; i1=1; #10;
		sel=1; i0=1; i1=0; #10;
		sel=1; i0=1; i1=1; #10;
	end
endmodule