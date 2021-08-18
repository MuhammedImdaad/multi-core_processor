module SINGLE_CORE_PROCESSOR(
	
	input wire [20:0] Instruction,
	input wire [31:0] Data,
	input wire clk,
	input [2:0] coreID,
	input [2:0] no_Cores,
	input wire enable,
	
	output wire [5:0] PC_out,
	output wire [11:0] AR_out,
	output wire DRAM_we,
	output wire [31:0] DR_out,
	output wire End
);

//	Declaring All the wires
//	Register File
	wire [4:0] RPA;
	wire [4:0] RPB;
	wire [31:0] Data_in;
	wire [4:0] WPN;
	wire Reg_write_en;
	wire [31:0] douta;
	wire [31:0] doutb;

//	ALU MAIN
	wire [2:0] op;
	wire [31:0] ALU_out;
	wire Z;

//	Control Unit
	wire [20:0] IR_out;
	wire [1:0] M1;
	wire M2;
	wire M3;
	wire M4;
	wire [11:0] alpha;
	wire [5:0] gamma;
	
//	special purpose register write enable
	wire w;
	assign w = 1'b1;
//	PC 
	wire w_pc;
// IR
    wire w_IR;	
//	AC
	wire [31:0] AC_out;
//	AR
	wire [11:0] AR_in;
	wire w_AR;
//	DR
	wire [31:0] DR_in;
	
//	REGISTER FILE
	regfile Reg_File(
			.rpa(RPA), 
			.rpb(RPB), 
			.din(Data_in) ,
			.wp(WPN), 
			.we(Reg_write_en), 
			.clk(clk), 
			.douta(douta), 
			.doutb(doutb),
			.coreID(coreID),
			.no_Cores(no_Cores)
	);
	
//	ALU
	alu ALU_main(
			.A_bus(douta), 
			.B_bus(doutb), 
			.op(op), 
			.C_bus(ALU_out),
			.Z(Z)
	);
	
	
//	Control Unit	
	control Control_Unit(
			.clk(clk), 
			.z(Z), 
			.instruction(IR_out), 
			.alu_en(op), 
			.M1(M1),
			.M2(M2),
			.M3(M3),
			.M4(M4),
			.rpa(RPA),
			.rpb(RPB),
			.wpn(WPN),
			.write_en(Reg_write_en),
			.alpha(alpha),
			.gamma(gamma),
			.write_ram(DRAM_we),
			.q(End),
			.w_pc(w_pc),
			.w_IR(w_IR),
			.w_AR(w_AR)
	);
								
//	PC Module
	pc_module pc(
			.gamma(gamma),
			.clk(clk),
			.s(M3),
			.pcout(PC_out),
			.we(w_pc),
			.enable(enable)
	);

//	IR
	parameter IR_width = 21;
	register #(.width(IR_width)) IR (
				.din(Instruction),
				.clk(clk),
				.we(w_IR),
				.dout(IR_out)
	);
	
//	AC
	parameter AC_width = 32;
	register #(.width(AC_width)) AC (
				.din(ALU_out),
				.clk(clk),
				.we(w),
				.dout(AC_out)
	);

//	AR 2->1  MUX	
	parameter AR_width = 12;
	mux2to1  #(.width(AR_width)) M4_mux(
				.dina(alpha),
				.dinb(douta), 
				.s(M4), 
				.dout(AR_in)
	);
					
//	AR
	register #(.width(AR_width)) AR (
				.din(AR_in),
				.clk(clk),
				.we(w_AR),
				.dout(AR_out)
	);

//	DR 2->1  MUX	
	mux2to1 M2_mux(
				.dina(douta),
				.dinb(Data), 
				.s(M2), 
				.dout(DR_in)
	);

//	DR
	parameter DR_width = 32;
	register #(.width(DR_width)) DR (
				.din(DR_in),
				.clk(clk),
				.we(w),
				.dout(DR_out)
	);
													
//	DR 3->1  MUX	
	mux3to1 M1_mux(
				.dina(DR_out),
				.dinb(alpha),
				.dinc(AC_out),
				.s(M1),
				.dout(Data_in)
	);
					
endmodule 