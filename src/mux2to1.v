module mux2to1
	#(parameter width = 32) 
	( // multiplexer, 32 bits
		input [width-1:0] dina, // inputs, 32 bits
		input [width-1:0] dinb,
		input s, // input, 1 bit
		output [width-1:0] dout // output, 32 bits
	);
	assign dout = s ? dina : dinb;  // s=1 a; s=0 b;
endmodule
