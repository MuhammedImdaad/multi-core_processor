`timescale 1ns/1ns
module alu_tb;
reg [31:0] A_bus;
reg [31:0] B_bus;
reg [2:0] op;
wire [31:0] C_bus;
wire Z;
alu g (A_bus, B_bus, op, C_bus, Z);
initial begin
A_bus = 32'd10; 
B_bus = 32'd6;
op = 3'b001;
#1 $display (" A_bus=%d", A_bus, " b=%b", B_bus, " add=%b", op, " output=%d", C_bus, " z = %b", Z);
A_bus = 32'd8; 
B_bus = 32'd7;
op = 3'b010;
#1 $display (" A_bus=%b", A_bus, " b=%b", B_bus, " sub=%b", op, " output=%d", C_bus, " Z = %b", Z);
op = 3'b011;
#1 $display (" A_bus=%b", A_bus, " b=%b", B_bus, " mul=%b", op, " output=%d", C_bus, " Z = %b", Z);
A_bus = 32'd7; 
B_bus = 32'd7;
op = 3'b010;
#1 $display (" A_bus=%b", A_bus, " b=%b", B_bus, " sub=%b", op, " output=%d", C_bus, " Z = %b", Z);
A_bus = 32'd6; 
B_bus = 32'd7;
op = 3'b010;
#1 $display (" A_bus=%b", A_bus, " b=%b", B_bus, " sub=%b", op, " output=%d", C_bus, " Z = %b", Z);
A_bus = 32'd17; 
B_bus = 32'd5;
op = 3'b100;
#1 $display (" A_bus=%b", A_bus, " b=%b", B_bus, " div=%b", op, " output=%d", C_bus, " Z = %b", Z);
op = 3'b101;
#1 $display (" A_bus=%b", A_bus, " b=%b", B_bus, " mod=%b", op, " output=%d", C_bus, " Z = %b ", Z);
#2 $stop; 
end
endmodule