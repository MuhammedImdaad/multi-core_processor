`timescale 1ns/1ns

module regfile_tb;
	reg [31:0] din; // data of write port
	reg [4:0] rpa; // reg # of read port A
	reg [4:0] rpb; // reg # of read port B
	reg [4:0] wp; // reg # of write port
    reg [2:0] coreID;
	reg we,rst; // write reset enable
	reg clk;
	wire [31:0] douta;
	wire [31:0] doutb;

	initial begin
		clk = 1'b0;
		forever begin
			#1;
			clk = ~clk;
		end
	end

	regfile r (rpa, rpb, din ,wp, we, clk, rst, douta, doutb, 3'b10);
	initial begin
	@(posedge clk);
        	rpa = 5'd18;
        	rpb = 5'd20;
        	din = 32'h11111111;
        	wp = 5'd1;
        	we = 1;
        	rst = 0;
            // coreID = 2;
	@(posedge clk);
        	rpa = 5'd18;
        	rpb = 5'd1;
        	din = 32'h11111111;
        	wp = 5'd1;
        	we = 0;
        	rst = 1;
	@(posedge clk);
        	rpa = 5'd15;
        	rpb = 5'd1;
        	din = 32'h11111111;
        	wp=5'd0;
        	we = 0;
        	rst=0;
	 #1 $stop;
	end
	// always #1 clk = ~clk;
endmodule