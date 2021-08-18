module processor_tb();

    reg [20:0] Instruction;
	reg [31:0] Data;
	reg clk;
	wire [5:0] PC_out;
	wire [11:0] AR_out;
	wire DRAM_we;
	wire [31:0] DR_out;
	wire [2:0] ID = 0;
	wire End;
	SINGLE_CORE_PROCESSOR Single_Core_Processor(
                    .Instruction(Instruction),
	                .Data(Data),
	                .clk(clk),
                    .PC_out(PC_out),
	                .AR_out(AR_out),
	                .DRAM_we(DRAM_we),
	                .DR_out(DR_out),
					.coreID(ID),
					.End(End)
);
	
	initial begin
		clk=1'b0;
		forever #10 clk = ~clk;
	end

	initial begin
		@(posedge clk);
		Instruction = 21'b010000101000000100010; //LOADI Cx 34 
	    Data = 32'd5;	
		#160 $stop;

		// @(posedge clk);
		// Instruction = 20'b00110010010000000000;
	    // Data = 32'b1100;	
		// #100;

		// @(posedge clk);
		// Instruction = 20'b00110011100000000000;
	    // Data = 32'b10100;	
		// #100;

		// @(posedge clk);		
		// Instruction = 20'b01000100110000000000;
	    // Data = 32'b11001;	
		// #100;

		// @(posedge clk);	
		// Instruction = 20'b01000101110000000001;
	    // Data = 32'b1001011;
		// #100;

		// @(posedge clk);
		// Instruction = 20'b01000110110000000010;
	    // Data = 32'b1000101;
		// #100 ;
	end
	
endmodule 