module Second_pipe(
  input CLK,
  input wire [4:0] Rreg_addr12,
  input wire [4:0] Rreg_addr22,
  input wire [4:0] Wreg_addr2,
  input wire [31:0] imm2,
  input wire [31:0] Rdata12,
  input wire [31:0] Rdata22,
  input wire [31:0] next_PC2,
  input wire JtoPC2,
  input wire Branch2,
  input wire RegWrite2,
  input wire ALUSrc2,
  input wire MemWrite2,
  input wire MemRead2,
  input wire MemtoReg2,
  input wire [3:0] ALUOp2,

  output reg [4:0] Rreg_addr12_3,
  output reg [4:0] Rreg_addr22_3,
  output reg [4:0] Wreg_addr2_3,
  output reg [31:0] imm2_3,
  output reg [31:0] Rdata12_3,
  output reg [31:0] Rdata22_3,
  output reg [31:0] next_PC2_3,
  output reg JtoPC2_3,
  output reg Branch2_3,
  output reg RegWrite2_3,
  output reg ALUSrc2_3,
  output reg MemWrite2_3,
  output reg MemRead2_3,
  output reg MemtoReg2_3,
  output reg [3:0] ALUOp2_3
);



always @(negedge CLK)
begin
  next_PC2_3 <= next_PC2;
  Rdata12_3 <= Rdata12;
  Rdata22_3 <= Rdata22;
  Rreg_addr12_3 <= Rreg_addr12;
  Rreg_addr22_3 <= Rreg_addr22;
  Wreg_addr2_3 <= Wreg_addr2;
  imm2_3 <= imm2;

  JtoPC2_3 <= JtoPC2;
  Branch2_3 <= Branch2;
  RegWrite2_3 <= RegWrite2;
  ALUSrc2_3 <= ALUSrc2;
  MemWrite2_3 <= MemWrite2;
  MemRead2_3 <= MemRead2;
  MemtoReg2_3 <= MemtoReg2;
  ALUOp2_3 <= ALUOp2;
end

endmodule
