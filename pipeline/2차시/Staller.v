module Staller(
input wire [31:0] instruct,
input wire [4:0] Wreg_addr2,

input wire flag,
input wire [5:0] OP2,

output reg stall2
);

always @ (*)
begin
  if (flag)
    stall2 <= 0;

  else if (instruct[31:26] == 6'b000010) // jump인 경우
    stall2 <= 1;

  else if (instruct[31:26] == 6'b000100) //beg인 경우
    stall2 <= 1;

  else if (OP2 == 6'b100011) // 2번째 stage에 있는 내용이 lw
  begin
    if (instruct[31:26] != 6'b000010 && Wreg_addr2 == instruct[25:21]) // 1번째 stage에 있는 jump가 아닌 명령어가 lw가 쓸려는 레지스터를 읽으려 할 때
      stall2 <= 1;
    else if (instruct[31:26] == 6'b000000 && Wreg_addr2 == instruct[20:16]) // 1번째 stage에 있는 R-type 명령어가 lw가 쓸려는 레지스터를 읽으려 할 때
      stall2 <= 1;
  end
end

initial
begin
  stall2 <= 0;
end
endmodule
