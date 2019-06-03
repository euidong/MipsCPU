module First_pipe(
  input CLK,
  input wire [31:0] next_PC1,
  input wire [31:0] instruct1,
  input wire JtoPC1,
  input wire Branch1,
  input wire RegWrite1,
  input wire RegDst1,
  input wire ALUSrc1,
  input wire MemWrite1,
  input wire MemRead1,
  input wire MemtoReg1,
  input wire [3:0] ALUOp1,

  output reg [31:0] next_PC1_2,
  output reg [31:0] instruct1_2,
  output reg JtoPC1_2,
  output reg Branch1_2,
  output reg RegWrite1_2,
  output reg RegDst1_2,
  output reg ALUSrc1_2,
  output reg MemWrite1_2,
  output reg MemRead1_2,
  output reg MemtoReg1_2,
  output reg [3:0] ALUOp1_2
);



always @(negedge CLK)
begin
  next_PC1_2 <= next_PC1;
  instruct1_2 <= instruct1;
  JtoPC1_2 <= JtoPC1;
  Branch1_2 <= Branch1;
  RegWrite1_2 <= RegWrite1;
  RegDst1_2 <= RegDst1;
  ALUSrc1_2 <= ALUSrc1;
  MemWrite1_2 <= MemWrite1;
  MemRead1_2 <= MemRead1;
  MemtoReg1_2 <= MemtoReg1;
  ALUOp1_2 <= ALUOp1;
end

endmodule
