module pc_module 
	#(parameter width = 6)
	(
		input [width-1:0] gamma,
		input clk, 
		input s, we, enable,
		output reg [width-1:0] pcout 
	);

	wire [width-1:0] w1;
	wire [width-1:0] w2;

	//mux will selection which address to send to PC
	mux2to1 #(width) pcmux (w1, gamma, s, w2); //s==1 => PC INC
	pc_alu inc_alu(pcout, w1);
	
	//to start the process from 0th instruction
	initial pcout = 0;
	always @(posedge clk)
	 	if (we && enable) pcout <= w2;

endmodule
