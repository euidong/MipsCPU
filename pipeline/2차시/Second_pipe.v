module Second_pipe(
  input CLK,
  input wire [4:0] Wreg_addr2,
  input wire [31:0] imm2,
  input wire [31:0] Rdata12,
  input wire [31:0] Rdata22,
  input wire [31:0] next_PC2,
  input wire [5:0] OP2,
  input wire [5:0] Funct2,
  input wire RegWrite2,

  output reg [31:0] next_PC2_3,
  output reg [5:0] OP2_3,
  output reg [5:0] Funct2_3,
  output reg [31:0] Rdata12_3,
  output reg [31:0] Rdata22_3,
  output reg [4:0] Wreg_addr2_3,
  output reg [31:0] imm2_3,
  output reg RegWrite2_3
);



always @(negedge CLK)
begin
  next_PC2_3 <= next_PC2;
  OP2_3 <= OP2;
  Funct2_3 <= Funct2;
  Rdata12_3 <= Rdata12;
  Rdata22_3 <= Rdata22;
  Wreg_addr2_3 <= Wreg_addr2;
  imm2_3 <= imm2;
  RegWrite2_3 <= RegWrite2;
end

endmodule
