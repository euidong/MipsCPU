module Staller(
input wire CLK,
input wire Branch1,
input wire Branch3,
input wire JtoPC1,
input wire JtoPC3,
input wire MemRead1,
input wire MemRead2,
input wire RegWrite1,

output reg stall_JB,
output reg stall_lw
);

always @ (negedge CLK)
begin
/* branch와 jump 명령어의 2 CLK stall 구현 */
  if (Branch1 | JtoPC1)
    stall_JB <= 1;
  if (Branch3 | JtoPC3)
    stall_JB <= 0;
/* LW명령어인 경우 1 CLK stall 구현 */
  if (MemRead1)
    stall_lw <= 1;
  if(MemRead2 & !RegWrite1)
    stall_lw <= 0;
end

initial
begin
  stall_JB <= 0;
  stall_lw <= 0;
end

endmodule
