module Third_pipe(
  input wire CLK,
  input wire [31:0] imm3,
  input wire [31:0] branch_addr3,
  input wire [31:0] jump_addr3,
  input wire [4:0] Wreg_addr3,
  input wire [31:0] ALUresult3,
  input wire PCSrc3,
  input wire JtoPC3,
  input wire RegWrite3,
  input wire MemWrite3,
  input wire MemRead3,
  input wire MemtoReg3,

  output reg [31:0] imm3_4,
  output reg [31:0] branch_addr3_1,
  output reg [31:0] jump_addr3_1,
  output reg [4:0] Wreg_addr3_4,
  output reg [31:0] ALUresult3_4,
  output reg PCSrc3_4,
  output reg JtoPC3_4,
  output reg RegWrite3_4,
  output reg MemWrite3_4,
  output reg MemRead3_4,
  output reg MemtoReg3_4
);



always @(negedge CLK)
begin
  imm3_4 <= imm3;
  Wreg_addr3_4 <= Wreg_addr3;
  ALUresult3_4 <= ALUresult3;
  jump_addr3_1 <= jump_addr3;
  branch_addr3_1 <= branch_addr3;

  PCSrc3_4 <= PCSrc3;
  JtoPC3_4 <= JtoPC3;
  RegWrite3_4 <= RegWrite3;
  MemWrite3_4 <= MemWrite3;
  MemRead3_4 <= MemRead3;
  MemtoReg3_4 <= MemtoReg3;
end
endmodule
