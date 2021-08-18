module pc_alu(PC, PC_1);

	input [5:0] PC;
	output [5:0] PC_1;
	
	//PC incrementation
	assign PC_1 = PC + 6'd1;	
	
endmodule 
