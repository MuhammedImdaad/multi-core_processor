module register 
	#(parameter width = 32)
	(
		input [width-1:0] din, // input
		input clk, 
		input we, 
		output reg [width-1:0] dout // output 
	);

	initial dout = 0;	
	always @(posedge clk) begin
		if (we) dout <= din;
	end
		
endmodule