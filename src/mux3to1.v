module mux3to1 
	#(parameter width = 32)
	(
		dina, 
		dinb, 
		dinc, 
		s, 
		dout
	); // 3-to-1 multiplexer, 32-bit
	
	input [width-1:0] dina, dinc; // inputs, 32 bits
	input [11:0] dinb;
	input [1:0] s; // input, 2 bits
	output [width-1:0] dout; // output, 32 bits
	
	function [width-1:0] select; // function name (= return value, 32 bits)
	    input [width-1:0] a0,a1, a2; // notice the order of the input arguments
	    input [1:0] s; // notice the order of the input arguments
	    case (s) // cases:
		    2'b01: select = a0; // if (s==1) return value = a0
		    2'b10: select = a1; // if (s==2) return value = a1
		    2'b11: select = a2; // if (s==3) return value = a2
			default: select = a0;
	    endcase
    endfunction
    
	assign dout = select(dina, dinb, dinc, s); // call the function with parameters

	endmodule