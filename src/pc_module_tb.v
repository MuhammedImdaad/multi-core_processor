`timescale 1ns/1ns
module pc_module_tb;
	reg [5:0] gamma;
	reg clk;
	reg s, we;
	wire [5:0] pcout;
	// reg we; // we: enable
	// clock and reset

	initial begin
		clk = 1'b0;
		forever begin
			#1;
			clk = ~clk;
		end
	end

	pc_module pc (
		gamma,
		clk,
		s,
		we,
		pcout
		//  we, // we: enable
		// clock and reset
	);
initial begin
	@(posedge clk);
        	gamma = 5'b11000;
        	s = 1'd1;
        	we = 0;
        	// rst = 0;
	@(posedge clk);
        	gamma = 5'b11000;
        	s = 1'd1;
        	we = 1;
        	// rst = 0;
	@(posedge clk);
        	gamma = 5'b11000;
        	s = 1'd0;
        	we = 1;
        	// rst = 1;
	@(posedge clk);
        	gamma = 5'b11000;
        	s = 1'd1;
        	we = 1;
        	// rst = 0;
	@(posedge clk);
        	gamma = 5'b11111;
        	s = 1'd0;
        	we = 1;
        	// rst = 0;
	@(posedge clk);
#2 $stop;
    
end
endmodule