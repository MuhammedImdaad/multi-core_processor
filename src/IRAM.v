module IRAM(
	input clk,
	input [5:0] PC0,
	output [20:0] INS_0,

	input [5:0] PC1,
	output [20:0] INS_1,

	input [5:0] PC2,
	output [20:0] INS_2,

	input [5:0] PC3,
	output [20:0] INS_3
	);
				
	reg [20:0] ram [51:0];	
	
	assign INS_0 = ram[PC0];
	assign INS_1 = ram[PC1];
	assign INS_2 = ram[PC2];
	assign INS_3 = ram[PC3];
	
	initial begin  // X * Y = Z

		//registering starting address of matrixes
		ram [0]  = 21'b001100001000000000000; //write Ax 0 0000
		ram [1]  = 21'b001100010000000010000; //write Ay 16 1024 
		ram [2]  = 21'b001100011000000100000; //write Az 32 2048 
		
		//registering input matrix size information
		ram [3]  = 21'b010000100000000110000; //LOADI Rx 48 3072		
		ram [4]  = 21'b010000101000000110001; //LOADI Cx 49 3073 
		ram [5]  = 21'b010000110000000110010; //LOADI Cy 50 3074 

		//registering the size of the output matrix
		ram [6]  = 21'b010100100001100000000; //MUL Rx Cy	
		ram [7]  = 21'b011101110000000000000; //MV Sz

		//instantiating registers for variable use
		ram [8]  = 21'b001001000000000000000; //RST TR2 
		ram [9]  = 21'b001001011000000000000; //RST I
		ram [10] = 21'b001001100000000000000; //RST J
		ram [11] = 21'b001001101000000000000; //RST K  
		ram [12] = 21'b001010010000000000000; //RST Cp

		//registering core ID into current pointer
		ram [13] = 21'b100010010011110000000; //ADD Cp ID 	
		ram [14] = 21'b011110010000000000000; //Mv Cp

		//updating starting address of output matrix
		ram [15] = 21'b100000011100100000000; //ADD Az Cp 
		ram [16] = 21'b011100011000000000000; //Mv Az   

		//checking whether current pointer surpass the output matrix size
		ram [17] = 21'b101001110100100000000; //SUB Sz Cp
		ram [18] = 21'b101111001100000000000; //JMPZ 51

		//calculating and updating current address of input matrices
		ram [19] = 21'b111010010001100000000; //DIV Cp Cy
		ram [20] = 21'b011101011000000000000; //Mv I
		ram [21] = 21'b111110010001100000000; //MOD Cp Cy
		ram [22] = 21'b011101100000000000000; //Mv J
		ram [23] = 21'b010101011001010000000; //MUL I Cx
		ram [24] = 21'b011100111000000000000; //Mv TR1
		ram [25] = 21'b100000001001110000000; //ADD Ax TR1
		ram [26] = 21'b011110000000000000000; //Mv PAx
		ram [27] = 21'b010101100001010000000; //MUL J Cx
		ram [28] = 21'b011100111000000000000; //Mv TR1
		ram [29] = 21'b100000010001110000000; //ADD Ay TR1 
		ram [30] = 21'b011110001000000000000; //Mv PAy 

		//multiplying two points in input matrices
		ram [31] = 21'b011001001100000000000; //LOAD Vx PAx 
		ram [32] = 21'b011001010100010000000; //LOAD Vy PAy 
		ram [33] = 21'b010101001010100000000; //MUL Vx Vy
		ram [34] = 21'b011100111000000000000; //MV TR1
		ram [35] = 21'b100000111010000000000; //ADD TR1 TR2
		ram [36] = 21'b011101000000000000000; //MV TR2

		//checking whether calcution for a single point is over
		ram [37] = 21'b100101101000000000000; //INC K
		ram [38] = 21'b101000101011010000000; //SUB Cx K
		ram [39] = 21'b101110101100000000000; //JMPZ 43  

		//increment current addresses of input matrices
		ram [40] = 21'b100110000000000000000; //INC PAx 
		ram [41] = 21'b100110001000000000000; //INC PAy
		ram [42] = 21'b110001111100000000000; //JMP 31	
	
		//storing output matrix value 
		ram [43] = 21'b001001101000000000000; //RST K		
		ram [44] = 21'b110101000000110000000; //STORE TR2 Az 
		ram [45] = 21'b001001000000000000000; //RST TR2

		//parallel processing 
		ram [46] = 21'b100010010101000000000; //ADD Cp no_cores
		ram [47] = 21'b011110010000000000000; //MV Cp	
		ram [48] = 21'b100000011101000000000; //ADD Az no_cores
		ram [49] = 21'b011100011000000000000; //MV Az	
		ram [50] = 21'b110001000100000000000; //JMP 17

		//end flag for simulation purpose
		ram [51] = 21'b000100000000000000000; //END 
	
	end
	
	// always @(posedge clk)begin
	// 	instr_out = ram[PC];		
		
	// end
	

endmodule 