module Top_Level_Module(
	input clk,
	input [2:0] no_Cores,

	input enable_0,	
	output wire End_core0,
	output wire [5:0] PC0_out,

	input enable_1,	
	output wire End_core1,
	output wire [5:0] PC1_out,

	input enable_2,
	output wire End_core2,
	output wire [5:0] PC2_out,
	
	input enable_3,
	output wire End_core3,
	output wire [5:0] PC3_out,

	input [31:0] dataIn_file,
	input [11:0] addr_file,
	input we_file,
	output wire [31:0] dataOut_file
);

//	Core0 Wires
	wire W_EN0;
	wire [20:0] INS_0;
	wire [31:0] Data_0;
	wire [11:0] AR0_out;
	wire [31:0] DR0_out;

//	Core1 Wires
	wire W_EN1;
	wire [20:0] INS_1;
	wire [31:0] Data_1;
	wire [11:0] AR1_out;
	wire [31:0] DR1_out;

//	Core2 Wires
	wire W_EN2;
	wire [20:0] INS_2;
	wire [31:0] Data_2;
	wire [11:0] AR2_out;
	wire [31:0] DR2_out;

//	Core3 Wires
	wire W_EN3;
	wire [20:0] INS_3;
	wire [31:0] Data_3;
	wire [11:0] AR3_out;
	wire [31:0] DR3_out;


	SINGLE_CORE_PROCESSOR core0(
		.Instruction(INS_0),	
		.Data(Data_0),
		.clk(clk),
		.PC_out(PC0_out),
		.AR_out(AR0_out),
		.DRAM_we(W_EN0),
		.DR_out(DR0_out),
		.End(End_core0),
		.coreID(3'b0),
		.enable(enable_0),
		.no_Cores(no_Cores)
	);

	SINGLE_CORE_PROCESSOR core1(
		.Instruction(INS_1),	
		.Data(Data_1),
		.clk(clk),
		.PC_out(PC1_out),
		.AR_out(AR1_out),
		.DRAM_we(W_EN1),
		.DR_out(DR1_out),
		.End(End_core1),
		.coreID(3'b01),
		.enable(enable_1),
		.no_Cores(no_Cores)
	);

	SINGLE_CORE_PROCESSOR core2(
		.Instruction(INS_2),	
		.Data(Data_2),
		.clk(clk),
		.PC_out(PC2_out),
		.AR_out(AR2_out),
		.DRAM_we(W_EN2),
		.DR_out(DR2_out),
		.End(End_core2),
		.coreID(3'b10),
		.enable(enable_2),
		.no_Cores(no_Cores)
	);

	SINGLE_CORE_PROCESSOR core3(
		.Instruction(INS_3),	
		.Data(Data_3),
		.clk(clk),
		.PC_out(PC3_out),
		.AR_out(AR3_out),
		.DRAM_we(W_EN3),
		.DR_out(DR3_out),
		.End(End_core3),
		.coreID(3'b11),
		.enable(enable_3),
		.no_Cores(no_Cores)
	);

	DRAM DRAM(
		.clk(clk),

		.dataIn_0(DR0_out),
		.addr_0(AR0_out),
		.we_0(W_EN0),
		.dataOut_0(Data_0),

		.dataIn_1(DR1_out),
		.addr_1(AR1_out),
		.we_1(W_EN1),
		.dataOut_1(Data_1),

		.dataIn_2(DR2_out),
		.addr_2(AR2_out),
		.we_2(W_EN2),
		.dataOut_2(Data_2),

		.dataIn_3(DR3_out),
		.addr_3(AR3_out),
		.we_3(W_EN3),
		.dataOut_3(Data_3),

		.dataIn_file(dataIn_file),
		.dataOut_file(dataOut_file),
		.addr_file(addr_file),
		.we_file(we_file)
	);
			
	IRAM IRAM(
		.clk(clk),

		.PC0(PC0_out),
		.INS_0(INS_0),

		.PC1(PC1_out),
		.INS_1(INS_1),

		.PC2(PC2_out),
		.INS_2(INS_2),

		.PC3(PC3_out),
		.INS_3(INS_3)
	);
			

endmodule 