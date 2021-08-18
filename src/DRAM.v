module DRAM
(
	//core 0-4

	input [31:0] dataIn_0,
	input [11:0] addr_0,
	input we_0, clk,
	output [31:0] dataOut_0,

	input [31:0] dataIn_1,
	input [11:0] addr_1,
	input we_1,
	output [31:0] dataOut_1,

	input [31:0] dataIn_2,
	input [11:0] addr_2,
	input we_2,
	output [31:0] dataOut_2,

	input [31:0] dataIn_3,
	input [11:0] addr_3,
	input we_3,
	output [31:0] dataOut_3,
	
	//communicate with outside (testbench with txt files)
	input [31:0] dataIn_file,
	input [11:0] addr_file,
	input we_file,
	output [31:0] dataOut_file
);

	reg [31:0] ram[50:0];
	
	//reading DRAM when IR is fed
	assign dataOut_0 = ram[addr_0];
	assign dataOut_1 = ram[addr_1];
	assign dataOut_2 = ram[addr_2];
	assign dataOut_3 = ram[addr_3];	

	assign dataOut_file = ram[addr_file];

	// initial begin
	// ram[0] = 32'd1;
	// ram[1] = 32'd2;
	// ram[2] = 32'd3;
	// ram[3] = 32'd4;
	// ram[4] = 32'd5;
	// ram[5] = 32'd6;
	// ram[6] = 32'd7;
	// ram[7] = 32'd8;
	// ram[8] = 32'd0;
	// ram[9] = 32'd1;
	// ram[10] = 32'd1;
	// ram[11] = 32'd0;

	// ram[12] = 32'd1;
	// ram[13] = 32'd1;
	// ram[14] = 32'd1;
	// ram[15] = 32'd1;
	// ram[16] = 32'd2;
	// ram[17] = 32'd2;
	// ram[18] = 32'd2;
	// ram[19] = 32'd2;
	// ram[20] = 32'd3;
	// ram[21] = 32'd3;
	// ram[22] = 32'd3;
	// ram[23] = 32'd3;

	// ram[24] = 32'd0;
	// ram[25] = 32'd0;
	// ram[26] = 32'd0;
	// ram[27] = 32'd0;
	// ram[28] = 32'd0;
	// ram[29] = 32'd0;
	// ram[30] = 32'd0;
	// ram[31] = 32'd0;
	// ram[32] = 32'd0;

	// ram[33] = 32'd3;
	// ram[34] = 32'd4;
	// ram[35] = 32'd3;

	// end
	
	always @ (posedge clk)
	begin
	// Write DR when IR is fed and write command is given 
		if (we_0)
			ram[addr_0] = dataIn_0;
		if (we_1)
			ram[addr_1] = dataIn_1;
		if (we_2)
			ram[addr_2] = dataIn_2;
		if (we_3)
			ram[addr_3] = dataIn_3;
		if (we_file)
			ram[addr_file] = dataIn_file;
	end
	
endmodule