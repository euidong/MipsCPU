module First_pipe(
  input CLK,
  input stall2,
  input wire [31:0] next_PC1,
  input wire [31:0] instruct1,

  output reg [31:0] next_PC1_2,
  output reg [31:0] instruct1_2
);



always @(negedge CLK)
begin
  next_PC1_2 <= next_PC1;
  instruct1_2 <= instruct1;
end

endmodule
