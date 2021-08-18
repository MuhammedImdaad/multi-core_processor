module regfile (
		rpa, 
		rpb, 
		din,
		wp, 
		we, 
		clk, 
		douta, 
		doutb,
		coreID,
		no_Cores
); 
	
	input [31:0] din; // data of write port
	input [4:0] rpa; // reg # of read port A
	input [4:0] rpb; // reg # of read port B
	input [4:0] wp; // reg # of write port
	input [2:0] coreID;
	input [2:0] no_Cores;
	input we; 
	input clk; // clock
	output [31:0] douta, doutb; // read ports A and B
	reg [31:0] register [20:1]; // 20 32-bit registers
	
	
	assign douta = (rpa <= 0)? 0 : register[rpa]; // read port A
	assign doutb = (rpb <= 0)? 0 : register[rpb]; // read port B
	
	initial begin
		register[19] <= 32'd1;
	end

	always @(posedge clk) begin // write port
		//to special purpose extended registers to store number of cores and core ID
		register[15] <= {29'b0, coreID};
		register[20] <= {29'b0, no_Cores};	

		if (wp) begin 
			if (we) register[wp] <= din;
			else register[wp] <= 32'd0;
		end 
	end
endmodule
