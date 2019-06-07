module Forwarder
(
  input wire RegWrite5,
  input wire RegWrite4,
  input wire ALUSrc3,
  input wire [4:0] Rreg_addr13,
  input wire [4:0] Rreg_addr23,
  input wire [4:0] Wreg_addr5,
  input wire [4:0] Wreg_addr4,
  input wire [31:0] ALUresult4,
  input wire [31:0] Rdata12_3,
  input wire [31:0] Rdata22_3,
  input wire [31:0] Wdata5,
  input wire [31:0] imm3,

  output reg [31:0] Rdata13,
  output reg [31:0] Rdata23
);

always @(*)
begin
  if(RegWrite5 && Rreg_addr13==Wreg_addr5)
    Rdata13 <= Wdata5;
  else if(RegWrite4 && Rreg_addr13 ==Wreg_addr4)
    Rdata13 <= ALUresult4;
  else
    Rdata13 <= Rdata12_3;
end

always @(*)
begin
  if (ALUSrc3)
    Rdata23 <= imm3;
  else
  begin
    if(RegWrite5 && Rreg_addr23==Wreg_addr5)
      Rdata13 <= Wdata5;
    else if(RegWrite4 && Rreg_addr23 ==Wreg_addr4)
      Rdata13 <= ALUresult4;
    else
      Rdata13 <= Rdata22_3;
  end
end


endmodule
