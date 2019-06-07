module Forth_pipe(
  input CLK,
  input wire [31:0] Wdata4,
  input wire [4:0] Wreg_addr4,
  input wire RegWrite4,

  output reg [31:0] Wdata4_5,
  output reg [4:0] Wreg_addr4_5,
  output reg RegWrite4_5
);



always @(negedge CLK)
begin
Wdata4_5 <= Wdata4;
Wreg_addr4_5 <= Wreg_addr4;
RegWrite4_5 <= RegWrite4;
end

endmodule
