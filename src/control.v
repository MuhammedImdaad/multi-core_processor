module control(
     clk, 
     z, 
     instruction, 
     alu_en, 
     M1, 
     M2, 
     M3, 
     M4, 
     w_pc, 
     w_IR, 
     w_AR,
     rpa, 
     rpb, 
     wpn, 
     write_en, 
     alpha, 
     gamma, 
     write_ram, 
     q 
);

input clk;
input z; //flag raised by ALU 
input [20:0] instruction; //fetched by IR
output reg [2:0] alu_en; //ALU operation selection
output reg [1:0] M1; //data selection for Register file
output reg M2; //data selection for DR
output reg M3; //selection for PC module
output reg M4; //data selection for IR
output reg w_pc; //PC enable
output reg w_IR; //IR enable
output reg w_AR; //AR enable
output reg [4:0] rpa; //register file read A bus 
output reg [4:0] rpb; //register file read B bus 
output reg [4:0] wpn; //register file write A bus 
output reg write_en; //register file write/reset selection
output reg [5:0] gamma; //PC jump address
output reg [11:0] alpha; //DRAM address
output reg write_ram; //DRAM write enable
output reg q = 0; //process END flag

integer present = 5'd1;

parameter present0         = 5'd0;
parameter fetch1           = 5'd1;
parameter fetch2           = 5'd2;
parameter rst              = 5'd3;
parameter loadI1           = 5'd4;
parameter loadI2           = 5'd5;
parameter loadI3           = 5'd6;
parameter mul              = 5'd7;
parameter add              = 5'd8;
parameter sub              = 5'd9;
parameter jmpz             = 5'd10;
parameter jmp              = 5'd11;
parameter store1           = 5'd12;
parameter store2           = 5'd13;
parameter inc1             = 5'd14;
parameter inc2             = 5'd15;
parameter load1            = 5'd16;
parameter load2            = 5'd17;
parameter load3            = 5'd18;
parameter mv               = 5'd19;
parameter write            = 5'd20;
parameter div              = 5'd21;
parameter mod              = 5'd22;
parameter term             = 5'd23;
parameter store3           = 5'd24;
parameter next_instruction = 5'd30;

wire [3:0] opcode   = instruction[20:17];
wire [4:0] operand1 = instruction[16:12];
wire [4:0] operand2 = instruction[11:7];
wire [5:0] immd1    = instruction[16:11];
wire [11:0] immd2   = instruction[11:0];

always @(posedge clk) begin
 
write_en  <= 0;
w_AR      <= 0; 
write_ram <= 0;
w_pc      <= 0;
wpn       <= 5'b0;

if(present == next_instruction) begin

case (opcode)

4'b0001 : present = term;
4'b0010 : present = rst;
4'b0011 : present = write; 
4'b0100 : present = loadI1; 
4'b0101 : present = mul; 
4'b0110 : present = load1; 
4'b0111 : present = mv; 
4'b1000 : present = add; 
4'b1001 : present = inc1; 
4'b1010 : present = sub; 
4'b1011 : present = jmpz; 
4'b1100 : present = jmp; 
4'b1101 : present = store1; 
4'b1110 : present = div; 
4'b1111 : present = mod; 

endcase
end

case(present)

fetch1 : begin
w_IR <= 1;
present <= fetch2;
end

fetch2 : begin
$display ("instruction %b", opcode);
M3 <= 1'b1;
w_pc <= 1;
w_IR <= 0;
present <= next_instruction;
end

term : begin
q <= 1'b1;
end

rst : begin
wpn <= operand1;
present <= fetch1;
end

write : begin
write_en <= 1;
wpn <= operand1;
alpha <= immd2;
M1 <= 2'b10;
present <= fetch1;
end

loadI1 : begin
alpha <= immd2;
M4 <= 1'b1;
w_AR <= 1;
present <= loadI2;
end

loadI2 : begin
M2 <= 1'b0;
present <= loadI3;
end

loadI3 : begin
M1 <= 2'b01;
write_en <= 1;
wpn <= operand1;
present <= fetch1;
end

mul : begin
alu_en <= 3'b011;
rpa <= operand1;
rpb <= operand2;
present <= fetch1;
end

add : begin
alu_en <= 3'b001;
rpa <= operand1;
rpb <= operand2;
present <= fetch1;
end

sub : begin
alu_en <= 3'b010;
rpa <= operand1;
rpb <= operand2;
present <= fetch1;
end

div : begin
alu_en <= 3'b100;
rpa <= operand1;
rpb <= operand2;
present <= fetch1;
end

mod : begin
alu_en <= 3'b101;
rpa <= operand1;
rpb <= operand2;
present <= fetch1;
end

jmpz : begin
if (z) begin
     gamma <= immd1;
     M3 <= 1'b0;
     w_pc <= 1;
end
present <= fetch1;
end

jmp : begin
gamma <= immd1;
M3 <= 1'b0;
w_pc <= 1;
present <= fetch1;
end

store1 : begin
M4 <= 1'b0;
rpa <= operand2;
w_AR <= 1;
present <= store2;
end

store2 : begin
rpa <= operand1;
M2 <= 1'b1;
present = store3;
end

store3 : begin 
write_ram <= 1;
present <= fetch1;
end 

inc1 : begin
rpa <= operand1;
rpb <= 5'd19;
alu_en <= 3'b001;
present <= inc2;
end

inc2 : begin
M1 <= 2'b11;
wpn <= operand1;
write_en <= 1;
present <= fetch1;
end

load1 : begin
M4 <= 1'b0;
w_AR <= 1;
rpa <= operand2;
present <= load2;
end

load2 : begin
M2 <= 1'b0;
present <= load3;
end

load3 : begin
M1 <= 2'b01;
wpn <= operand1;
write_en <= 1;
present <= fetch1;
end

mv : begin
M1 <= 2'b11;
wpn <= operand1;
write_en <= 1;
present <= fetch1;
end

default : begin
M3 <= 1'b1;
end

endcase
end
endmodule